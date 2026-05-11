import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/user_pages/selfie_verification/controller/selfie_verification_controller.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';

class SelfieVerificationView extends StatefulWidget {
  const SelfieVerificationView({super.key});

  @override
  State<SelfieVerificationView> createState() => _SelfieVerificationViewState();
}

class _SelfieVerificationViewState extends State<SelfieVerificationView> {
  // Own the controller's lifecycle from State, not from build(). The
  // controller holds a native ML Kit FaceDetector; calling
  // Get.put(...) inside build() replaced the instance on every
  // rebuild, churning FaceDetector create/close cycles. Now it's
  // created once on mount and torn down on pop.
  late final SelfieVerificationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SelfieVerificationController());
  }

  @override
  void dispose() {
    Get.delete<SelfieVerificationController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          flexibleSpace: const SimpleAppBarWidget(title: "Verify Your Account"),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Obx(() => _buildBody(controller)),
        ),
      ),
    );
  }

  Widget _buildBody(SelfieVerificationController c) {
    if (c.isLoadingStatus.value) {
      return const Center(child: CircularProgressIndicator());
    }

    final children = <Widget>[
      _buildStatusChip(c),
      20.height,
    ];

    if (c.latestStatus.value == "verified") {
      children.addAll([
        _buildVerifiedState(c),
      ]);
    } else if (c.latestStatus.value == "pending_review" && c.selfieFile.value == null) {
      children.addAll([
        _buildPendingState(c),
      ]);
    } else {
      // "none" or "rejected" → capture/retake flow.
      children.addAll([
        _buildInstructions(),
        18.height,
        _buildPreviewOrPlaceholder(c),
        14.height,
        _buildErrorOrHint(c),
        20.height,
        _buildActions(c),
      ]);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _buildStatusChip(SelfieVerificationController c) {
    final status = c.latestStatus.value;
    Color bg;
    String label;
    switch (status) {
      case "verified":
        bg = const Color(0xFF1D9BF0);
        label = "Verified ✓";
        break;
      case "pending_review":
        bg = const Color(0xFFFFC107);
        label = "Pending review";
        break;
      case "rejected":
        bg = AppColors.red;
        label = "Rejected";
        break;
      default:
        bg = AppColors.tabBackground;
        label = "Not verified";
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppFontStyle.styleW700(
            status == "verified" || status == "rejected" ? AppColors.white : AppColors.black,
            13,
          ),
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Take a clear selfie",
          style: AppFontStyle.styleW900(AppColors.white, 18),
        ),
        8.height,
        Text(
          "We use this to confirm you're a real person. An admin will "
          "review your selfie within 24 hours and add a verified badge "
          "to your profile.",
          style: AppFontStyle.styleW500(AppColors.unselected, 13),
        ),
        12.height,
        _bulletLine("Find a well-lit space."),
        _bulletLine("Look straight at the camera."),
        _bulletLine("Keep both eyes open."),
        _bulletLine("Make sure your full face is visible."),
      ],
    );
  }

  Widget _bulletLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("•  ", style: AppFontStyle.styleW700(AppColors.primary, 14)),
          Expanded(
            child: Text(
              text,
              style: AppFontStyle.styleW500(AppColors.unselected, 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewOrPlaceholder(SelfieVerificationController c) {
    final file = c.selfieFile.value;
    if (file == null) {
      return Container(
        height: 240,
        decoration: BoxDecoration(
          color: AppColors.tabBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.unselected.withValues(alpha: 0.4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.face_outlined, color: AppColors.unselected, size: 56),
            10.height,
            Text(
              "No selfie taken yet",
              style: AppFontStyle.styleW500(AppColors.unselected, 13),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            file,
            height: 320,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        if (c.isAnalyzing.value)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(
                      "Checking photo quality…",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorOrHint(SelfieVerificationController c) {
    if (c.gateError.value != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.red.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.red),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.red, size: 20),
            10.width,
            Expanded(
              child: Text(
                c.gateError.value!,
                style: AppFontStyle.styleW500(AppColors.red, 13),
              ),
            ),
          ],
        ),
      );
    }

    // Non-blocking tip (e.g. "move closer") — the photo is still
    // submittable; this just nudges the user toward a clearer shot.
    if (c.softHint.value != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 20),
            10.width,
            Expanded(
              child: Text(
                c.softHint.value!,
                style: AppFontStyle.styleW500(AppColors.unselected, 13),
              ),
            ),
          ],
        ),
      );
    }

    if (c.latestStatus.value == "rejected" && c.latestRejectionReason.value != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.red.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Previous submission was not approved.",
              style: AppFontStyle.styleW700(AppColors.red, 13),
            ),
            6.height,
            Text(
              "Reason: ${c.latestRejectionReason.value}",
              style: AppFontStyle.styleW500(AppColors.unselected, 12),
            ),
            6.height,
            Text(
              "Please retake and submit again.",
              style: AppFontStyle.styleW500(AppColors.unselected, 12),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildActions(SelfieVerificationController c) {
    final hasFile = c.selfieFile.value != null;

    if (!hasFile) {
      return MainButtonWidget(
        height: 50,
        width: double.infinity,
        borderRadius: 12,
        color: AppColors.primary,
        callback: c.takeSelfie,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, color: AppColors.black),
            10.width,
            Text(
              "Take Selfie",
              style: AppFontStyle.styleW700(AppColors.black, 14),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: MainButtonWidget(
            height: 50,
            borderRadius: 12,
            color: AppColors.tabBackground,
            border: Border.all(color: AppColors.unselected),
            callback: c.isSubmitting.value ? null : c.retake,
            child: Text(
              "Retake",
              style: AppFontStyle.styleW700(AppColors.white, 14),
            ),
          ),
        ),
        12.width,
        Expanded(
          child: MainButtonWidget(
            height: 50,
            borderRadius: 12,
            color: c.canSubmit ? AppColors.primary : AppColors.tabBackground,
            callback: c.canSubmit
                ? () async {
                    final ok = await c.submit();
                    if (ok) {
                      displayToast(
                        message: "Selfie submitted! An admin will review it shortly.",
                        isBottomToast: true,
                      );
                      await c.refreshStatus();
                    } else {
                      displayToast(
                        message: "Couldn't submit. Please try again.",
                        isBottomToast: true,
                      );
                    }
                  }
                : null,
            child: c.isSubmitting.value
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.black,
                    ),
                  )
                : Text(
                    "Submit",
                    style: AppFontStyle.styleW700(
                      c.canSubmit ? AppColors.black : AppColors.unselected,
                      14,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingState(SelfieVerificationController c) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your selfie is being reviewed.",
            style: AppFontStyle.styleW700(AppColors.white, 16),
          ),
          10.height,
          Text(
            "An admin typically reviews submissions within 24 hours. "
            "You'll get a notification once a decision is made.",
            style: AppFontStyle.styleW500(AppColors.unselected, 13),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifiedState(SelfieVerificationController c) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified, color: const Color(0xFF1D9BF0), size: 28),
              10.width,
              Text(
                "You're verified",
                style: AppFontStyle.styleW900(AppColors.white, 17),
              ),
            ],
          ),
          10.height,
          Text(
            "The verified badge now appears next to your name on your "
            "profile and product listings.",
            style: AppFontStyle.styleW500(AppColors.unselected, 13),
          ),
        ],
      ),
    );
  }
}
