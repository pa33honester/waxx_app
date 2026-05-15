import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiService/login/signup_assistant_service.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/globle_veriables.dart' as gv;

/// Who sent a chat bubble in the in-app help assistant.
enum BotSender { bot, user }

/// One bubble in the assistant transcript. Local-only — nothing here is
/// persisted; the only thing that leaves the device is the final account
/// request (see [SignupAssistantService.submitAccountRequest]).
class BotMessage {
  final BotSender sender;
  final String text;
  final DateTime time;
  BotMessage(this.sender, this.text) : time = DateTime.now();
}

/// The fixed, deterministic step the conversation is currently on. Each step
/// decides whether the bottom area shows the free-text composer, the WhatsApp
/// phone field, or only quick-reply chips, and what the next step is.
enum BotStep {
  chooseProblem,
  // sign-up branch
  askFirstName,
  askLastName,
  askEmail,
  askWhatsapp, // required WhatsApp number — the body shows a dial-code phone field here
  askPassword,
  askConfirmPassword,
  summary,
  submitting,
  done,
  // login / general-enquiry branches hand off to existing flows
  loginRedirect,
  generalEnquiry,
}

/// Drives the in-app help assistant chatbot — the small chat that pops up in
/// the bottom-right corner of the login / sign-up / onboarding screens (see
/// [SignupAssistantLauncher]). The whole conversation is a tiny state machine
/// that lives here on the client — there is no server-side bot.
///
/// * **Sign up** → collects first name, last name, email, a **required**
///   WhatsApp number (so the team can WhatsApp the person once their account
///   is created) and a password, shows a summary, then POSTs a pending account
///   request that an admin approves in the admin panel.
/// * **Login** → closes the panel and routes to the main `/SignIn` screen.
/// * **General enquiry** → closes the panel and opens the live `/SupportChat`.
class SignupAssistantController extends GetxController {
  final RxList<BotMessage> messages = <BotMessage>[].obs;
  final Rx<BotStep> step = BotStep.chooseProblem.obs;
  final RxList<String> quickReplies = <String>[].obs;
  // Whether the bottom free-text composer is shown. When false the user is
  // expected to tap a [quickReplies] chip — or, on [BotStep.askWhatsapp], use
  // the dial-code phone field the body renders for that step.
  final RxBool acceptsText = false.obs;
  final RxBool isSubmitting = false.obs;

  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Live snapshot of the WhatsApp number being typed — kept fresh by the
  // dial-code phone field's onChanged / onCountryChanged callbacks. The field
  // ([_WhatsappComposer]) owns its own internal text controller; we only mirror
  // its value here so the send button can read it.
  final RxString currentDialCode = "".obs; // e.g. "+233"
  final RxString currentWhatsappLocal = "".obs; // local part, as typed

  /// Set by the floating launcher so the Login / General-enquiry branches and
  /// the final "Close" chip can collapse the panel. Null when this controller
  /// is hosted by the full-screen `/SignupAssistant` route instead.
  VoidCallback? onRequestClose;

  // Collected sign-up details.
  String _firstName = "";
  String _lastName = "";
  String _email = "";
  String _whatsappNumber = ""; // local part, digits only
  String _whatsappDialCode = ""; // e.g. "+233"
  String _password = "";

  bool get _onPasswordStep => step.value == BotStep.askPassword || step.value == BotStep.askConfirmPassword;

  @override
  void onInit() {
    super.onInit();
    if ((gv.dialCode ?? "").isNotEmpty) currentDialCode.value = gv.dialCode!;
    _greet();
  }

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // ---- conversation flow -------------------------------------------------

  void _greet() {
    _botSay(St.botGreeting.tr);
    _setStep(
      BotStep.chooseProblem,
      chips: [St.botOptionSignup.tr, St.botOptionLogin.tr, St.botOptionOther.tr],
    );
  }

  /// Tapped one of the quick-reply chips.
  void onQuickReply(String label) {
    if (isSubmitting.value) return;
    switch (step.value) {
      case BotStep.chooseProblem:
        _userSay(label);
        if (label == St.botOptionSignup.tr) {
          _resetCollected();
          _botSay(St.botSignupIntro.tr);
          _botSay(St.botAskFirstName.tr);
          _setStep(BotStep.askFirstName, text: true);
        } else if (label == St.botOptionLogin.tr) {
          // → main login screen. If we're already on it, just collapse.
          _setStep(BotStep.loginRedirect);
          if (Get.currentRoute == "/SignIn") {
            onRequestClose?.call();
          } else {
            Get.offAllNamed("/SignIn");
          }
        } else {
          // General enquiry → hand off to the live human-support chat.
          _botSay(St.botConnectingSupport.tr);
          _setStep(BotStep.generalEnquiry);
          onRequestClose?.call();
          Get.toNamed("/SupportChat");
        }
        break;

      case BotStep.summary:
        _userSay(label);
        if (label == St.botSubmit.tr) {
          _submit();
        } else {
          // "Start over"
          _resetCollected();
          _botSay(St.botAskFirstName.tr);
          _setStep(BotStep.askFirstName, text: true);
        }
        break;

      case BotStep.done:
        if (label == St.botClose.tr) {
          if (onRequestClose != null) {
            onRequestClose!();
          } else {
            Get.back();
          }
        }
        break;

      default:
        break;
    }
  }

  /// Submitted free text from the composer.
  void onUserText() {
    final raw = inputController.text;
    final value = raw.trim();
    if (value.isEmpty || isSubmitting.value || !acceptsText.value) return;

    // Don't echo the actual password into the transcript.
    _userSay(_onPasswordStep ? "•" * value.length : raw.trim());
    inputController.clear();

    switch (step.value) {
      case BotStep.askFirstName:
        _firstName = value;
        _botSay(St.botAskLastName.tr);
        _setStep(BotStep.askLastName, text: true);
        break;

      case BotStep.askLastName:
        _lastName = value;
        _botSay(St.botAskEmail.tr);
        _setStep(BotStep.askEmail, text: true);
        break;

      case BotStep.askEmail:
        if (!_isValidEmail(value)) {
          _botSay(St.botInvalidEmail.tr);
          return;
        }
        _email = value.toLowerCase();
        _botSay(St.botAskWhatsapp.tr);
        _botSay(St.botWhatsappWhy.tr);
        // No free-text composer here — the body shows a dial-code phone field
        // and calls [onWhatsappSubmitted].
        _setStep(BotStep.askWhatsapp);
        break;

      case BotStep.askPassword:
        if (value.length < 8) {
          _botSay(St.botPasswordTooShort.tr);
          return;
        }
        _password = value;
        _botSay(St.botAskConfirmPassword.tr);
        _setStep(BotStep.askConfirmPassword, text: true);
        break;

      case BotStep.askConfirmPassword:
        if (value != _password) {
          _password = "";
          _botSay(St.botPasswordMismatch.tr);
          _setStep(BotStep.askPassword, text: true);
          return;
        }
        _showSummary();
        break;

      default:
        break;
    }
  }

  /// Submitted from the WhatsApp dial-code phone field (used instead of
  /// [onUserText] on [BotStep.askWhatsapp]).
  void onWhatsappSubmitted({required String localNumber, required String dialCode}) {
    if (step.value != BotStep.askWhatsapp || isSubmitting.value) return;
    final digits = localNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final normalized = digits.startsWith('0') ? digits.substring(1) : digits;
    final raw = dialCode.trim();
    final code = raw.isEmpty ? '' : (raw.startsWith('+') ? raw : '+$raw');
    if (code.isEmpty || normalized.length < 6 || normalized.length > 15) {
      _botSay(St.botInvalidWhatsapp.tr);
      return;
    }
    _whatsappNumber = normalized;
    _whatsappDialCode = code;
    currentWhatsappLocal.value = "";
    _userSay("$code $normalized");
    _botSay(St.botAskPassword.tr);
    _setStep(BotStep.askPassword, text: true);
  }

  void _showSummary() {
    final fullName = [_firstName, _lastName].where((s) => s.trim().isNotEmpty).join(" ");
    final summary = "${St.botSummaryIntro.tr}\n\n"
        "${St.botSummaryName.tr}: $fullName\n"
        "${St.botSummaryEmail.tr}: $_email\n"
        "${St.botSummaryWhatsapp.tr}: $_whatsappDialCode $_whatsappNumber";
    _botSay(summary);
    _setStep(BotStep.summary, chips: [St.botSubmit.tr, St.botEdit.tr]);
  }

  Future<void> _submit() async {
    isSubmitting.value = true;
    _setStep(BotStep.submitting);
    _botSay(St.botSubmitting.tr);
    try {
      final result = await SignupAssistantService.submitAccountRequest(
        firstName: _firstName,
        lastName: _lastName,
        email: _email,
        password: _password,
        mobileNumber: _whatsappNumber,
        countryCode: _whatsappDialCode,
      );
      if (result != null && result.status) {
        _botSay(result.message.trim().isNotEmpty ? result.message : St.botSubmitSuccess.tr);
        _setStep(BotStep.done, chips: [St.botClose.tr]);
      } else {
        _botSay((result?.message.trim().isNotEmpty ?? false) ? result!.message : St.botSubmitFailed.tr);
        _setStep(BotStep.summary, chips: [St.botSubmit.tr, St.botEdit.tr]);
      }
    } catch (_) {
      _botSay(St.botSubmitFailed.tr);
      _setStep(BotStep.summary, chips: [St.botSubmit.tr, St.botEdit.tr]);
    } finally {
      isSubmitting.value = false;
    }
  }

  // ---- helpers -----------------------------------------------------------

  void _botSay(String text) => _append(BotMessage(BotSender.bot, text));
  void _userSay(String text) => _append(BotMessage(BotSender.user, text));

  void _append(BotMessage m) {
    messages.add(m);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _setStep(BotStep next, {List<String> chips = const [], bool text = false}) {
    step.value = next;
    quickReplies.assignAll(chips);
    acceptsText.value = text;
  }

  void _resetCollected() {
    _firstName = "";
    _lastName = "";
    _email = "";
    _whatsappNumber = "";
    _whatsappDialCode = "";
    _password = "";
    currentWhatsappLocal.value = "";
    currentDialCode.value = gv.dialCode ?? "";
  }

  bool _isValidEmail(String email) =>
      RegExp(r"^[A-Za-z0-9.!#$%&'*+\-/=?^_`{|}~]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$").hasMatch(email.trim());

  void _scrollToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}
