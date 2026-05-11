import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

import 'package:waxxapp/ApiService/user/get_selfie_verification_status_service.dart';
import 'package:waxxapp/ApiService/user/submit_selfie_verification_service.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

// Drives the selfie capture + ML Kit gating + submit flow on
// SelfieVerificationView.
//
// Approval policy (per the plan): admin reviews every submission.
// ML Kit is used solely to gate the SUBMIT button — if the photo
// has no detectable face, both eyes closed, or covers <20% of the
// frame, we surface a "retake" CTA before the user uploads. This
// reduces noise in the admin queue but doesn't auto-approve anything.
class SelfieVerificationController extends GetxController {
  // Picked file + ML Kit result for the current attempt. Cleared on
  // a retake or after a successful submit.
  final Rx<File?> selfieFile = Rx<File?>(null);
  final RxBool isAnalyzing = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool isLoadingStatus = false.obs;

  // Auto-check result. Stored on the Verification doc as context for
  // the admin reviewer + future analytics. Decision is still manual.
  final RxMap<String, dynamic> autoCheckResult = <String, dynamic>{}.obs;

  // Hard blocker: set when ML Kit found zero or multiple faces.
  // Non-null disables the Submit button and shows a retake prompt.
  final RxnString gateError = RxnString();

  // Soft hint: a non-blocking suggestion (e.g. "move closer", "open
  // your eyes"). Shown as a tip; the Submit button stays enabled.
  final RxnString softHint = RxnString();

  // Latest server-side status — drives the screen header chip.
  // Cleared / refreshed by refreshStatus() after a submit.
  final RxString latestStatus = "none".obs;
  final RxnString latestRejectionReason = RxnString();

  static const double _minFaceAreaRatio = 0.18;
  static const double _eyeOpenThreshold = 0.4;

  late final FaceDetector _faceDetector;

  @override
  void onInit() {
    super.onInit();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        // Need classification probabilities for eye-open / smile
        // checks — they're unset by default.
        enableClassification: true,
        enableLandmarks: false,
        enableContours: false,
        enableTracking: false,
        performanceMode: FaceDetectorMode.accurate,
        minFaceSize: 0.15,
      ),
    );
    refreshStatus();
  }

  @override
  void onClose() {
    _faceDetector.close();
    super.onClose();
  }

  Future<void> refreshStatus() async {
    if (loginUserId.isEmpty) return;
    isLoadingStatus.value = true;
    try {
      final res = await GetSelfieVerificationStatusApi.fetch(userId: loginUserId);
      if (res?.status == true && res?.verification != null) {
        latestStatus.value = res!.verification!.status ?? "none";
        latestRejectionReason.value = res.verification!.rejectionReason;
        verificationStatus.value = latestStatus.value;
      } else {
        latestStatus.value = "none";
        latestRejectionReason.value = null;
      }
    } finally {
      isLoadingStatus.value = false;
    }
  }

  Future<void> takeSelfie() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 80,
      maxWidth: 1280,
    );
    if (picked == null) return;

    final file = File(picked.path);
    selfieFile.value = file;
    gateError.value = null;
    softHint.value = null;
    autoCheckResult.clear();

    await _runMlKit(file);
  }

  void retake() {
    selfieFile.value = null;
    gateError.value = null;
    softHint.value = null;
    autoCheckResult.clear();
  }

  // Read the intrinsic pixel dimensions of an image file via
  // dart:ui's codec. Returns null if the bytes don't decode. Cheap
  // — done once per capture, not per frame.
  //
  // CRITICAL: both the Codec and the decoded Image hold native
  // memory and MUST be disposed. Leaking the Codec across a few
  // captures exhausts the native heap and crashes the app — that
  // was the "3rd selfie restarts the app" bug.
  Future<(int, int)?> _readImageSize(File file) async {
    ui.Codec? codec;
    ui.FrameInfo? frame;
    try {
      final bytes = await file.readAsBytes();
      codec = await ui.instantiateImageCodec(bytes);
      frame = await codec.getNextFrame();
      final w = frame.image.width;
      final h = frame.image.height;
      return (w, h);
    } catch (e) {
      log("_readImageSize error: $e");
      return null;
    } finally {
      frame?.image.dispose();
      codec?.dispose();
    }
  }

  Future<void> _runMlKit(File file) async {
    isAnalyzing.value = true;
    try {
      final input = InputImage.fromFile(file);
      final faces = await _faceDetector.processImage(input);

      // Capture probabilities up-front so they survive the gating
      // checks and end up posted to the backend regardless of
      // pass/fail (admin uses them to triage).
      double? leftEye;
      double? rightEye;
      double areaRatio = 0;

      if (faces.isNotEmpty) {
        final f = faces.first;
        leftEye = f.leftEyeOpenProbability;
        rightEye = f.rightEyeOpenProbability;
        // H3 fix: use the actual image dimensions instead of the
        // previous hardcoded 1280×1280 assumption. The earlier
        // assumption was square but ImagePicker with maxWidth:1280
        // + imageQuality:80 actually produces 1280×960 (or 960×1280
        // for portrait), which underestimated the face-area ratio
        // by ~25% on portrait selfies and made the 18% threshold
        // harder to pass.
        final size = await _readImageSize(file);
        final imgW = (size?.$1 ?? 1280).toDouble();
        final imgH = (size?.$2 ?? 1280).toDouble();
        final bb = f.boundingBox;
        areaRatio = (bb.width * bb.height) / (imgW * imgH);
      }

      autoCheckResult.assignAll({
        "faceCount": faces.length,
        "leftEyeOpen": leftEye,
        "rightEyeOpen": rightEye,
        "faceAreaRatio": areaRatio,
        "mlKitVersion": "google_mlkit_face_detection 0.13.x",
      });

      // Only the unambiguous cases BLOCK submission. The eye-open
      // and face-area heuristics are unreliable (ML Kit's
      // classification probabilities swing wildly with lighting and
      // EXIF orientation), and since an admin reviews every
      // submission anyway, gating on them just traps users who
      // actually look fine. Block on zero faces / multiple faces;
      // for the rest, surface a soft hint via softHint but leave
      // the Submit button enabled.
      if (faces.isEmpty) {
        gateError.value = "We couldn't detect a face. Make sure your face is centred and well-lit, then retake.";
        return;
      }
      if (faces.length > 1) {
        gateError.value = "We see more than one face. Please be alone in the photo.";
        return;
      }

      // Passed the hard gate — clear the blocker. Compute a soft
      // hint for the UI but don't prevent submit.
      gateError.value = null;
      if (areaRatio < _minFaceAreaRatio) {
        softHint.value = "Tip: move a little closer so your face fills more of the frame.";
      } else if ((leftEye ?? 1) < _eyeOpenThreshold || (rightEye ?? 1) < _eyeOpenThreshold) {
        softHint.value = "Tip: keep both eyes open and look straight at the camera.";
      } else {
        softHint.value = null;
      }
    } catch (e, st) {
      log("ML Kit error: $e\n$st");
      // Don't block submission on a tooling error; the admin queue
      // will still catch a bad photo. Record the failure cause for
      // the admin reviewer.
      autoCheckResult.assignAll({
        "faceCount": null,
        "mlKitVersion": "error",
        "mlKitError": e.toString(),
      });
      gateError.value = null;
      softHint.value = null;
    } finally {
      isAnalyzing.value = false;
    }
  }

  Future<bool> submit() async {
    if (selfieFile.value == null || gateError.value != null || isSubmitting.value) {
      return false;
    }
    if (loginUserId.isEmpty) {
      log("submit: no logged-in user");
      return false;
    }

    isSubmitting.value = true;
    try {
      final response = await SubmitSelfieVerificationApi.submit(
        userId: loginUserId,
        selfieFile: selfieFile.value!,
        autoCheckResult: Map<String, dynamic>.from(autoCheckResult),
      );
      if (response?.status == true) {
        verificationStatus.value = "pending_review";
        latestStatus.value = "pending_review";
        latestRejectionReason.value = null;
        // Clear the picked file so the screen returns to the
        // status-display state.
        selfieFile.value = null;
        return true;
      }
      log("submit: backend returned ${response?.message}");
      return false;
    } catch (e) {
      log("submit error: $e");
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  // Convenience getter for the view: "ready to submit?"
  bool get canSubmit =>
      selfieFile.value != null &&
      gateError.value == null &&
      !isAnalyzing.value &&
      !isSubmitting.value;
}
