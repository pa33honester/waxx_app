import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiService/login/signup_assistant_service.dart';
import 'package:waxxapp/utils/Strings/strings.dart';

/// Who sent a chat bubble in the sign-up assistant.
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

/// The fixed, deterministic step the conversation is currently on. Each
/// step decides whether the composer accepts free text or only quick-reply
/// chips, and what the next step is.
enum BotStep {
  chooseProblem,
  // sign-up branch
  askFirstName,
  askLastName,
  askEmail,
  askPhone,
  askPassword,
  askConfirmPassword,
  summary,
  submitting,
  done,
  // login / other branches (hand off to existing flows)
  loginOptions,
  otherOptions,
}

/// Drives the in-app sign-up assistant chatbot. The whole conversation is
/// a small state machine that lives here on the client — there is no
/// server-side bot. On the sign-up branch it collects first name, last
/// name, email, an optional phone number and a password, shows a summary,
/// then POSTs a pending account request that an admin approves in the
/// admin panel. The login branch just routes the user into the existing
/// Forgot Password flow or the existing in-app Support Chat.
class SignupAssistantController extends GetxController {
  final RxList<BotMessage> messages = <BotMessage>[].obs;
  final Rx<BotStep> step = BotStep.chooseProblem.obs;
  final RxList<String> quickReplies = <String>[].obs;
  // Whether the bottom composer (free-text input) is shown. When false the
  // user is expected to tap one of the [quickReplies] chips instead.
  final RxBool acceptsText = false.obs;
  final RxBool isSubmitting = false.obs;

  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Collected sign-up details.
  String _firstName = "";
  String _lastName = "";
  String _email = "";
  String _phone = "";
  String _password = "";

  bool get _onPasswordStep => step.value == BotStep.askPassword || step.value == BotStep.askConfirmPassword;

  @override
  void onInit() {
    super.onInit();
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
          _botSay(St.botLoginHelp.tr);
          _setStep(BotStep.loginOptions, chips: [St.botResetPassword.tr, St.botChatSupport.tr, St.botBackToLogin.tr]);
        } else {
          _botSay(St.botOtherHelp.tr);
          _setStep(BotStep.otherOptions, chips: [St.botChatSupport.tr, St.botBackToLogin.tr]);
        }
        break;

      case BotStep.askPhone:
        // The only chip on this step is "Skip".
        if (label == St.botSkip.tr) {
          _userSay(label);
          _phone = "";
          _botSay(St.botAskPassword.tr);
          _setStep(BotStep.askPassword, text: true);
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

      case BotStep.loginOptions:
        _userSay(label);
        if (label == St.botResetPassword.tr) {
          Get.toNamed("/ForgotPassword");
          // leave the assistant on the stack so a back press returns here
          _setStep(BotStep.loginOptions, chips: [St.botResetPassword.tr, St.botChatSupport.tr, St.botBackToLogin.tr]);
        } else if (label == St.botChatSupport.tr) {
          Get.toNamed("/SupportChat");
          _setStep(BotStep.loginOptions, chips: [St.botResetPassword.tr, St.botChatSupport.tr, St.botBackToLogin.tr]);
        } else {
          Get.back();
        }
        break;

      case BotStep.otherOptions:
        _userSay(label);
        if (label == St.botChatSupport.tr) {
          Get.toNamed("/SupportChat");
          _setStep(BotStep.otherOptions, chips: [St.botChatSupport.tr, St.botBackToLogin.tr]);
        } else {
          Get.back();
        }
        break;

      case BotStep.done:
        if (label == St.botBackToLogin.tr) Get.back();
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
        _botSay(St.botAskPhone.tr);
        _setStep(BotStep.askPhone, text: true, chips: [St.botSkip.tr]);
        break;

      case BotStep.askPhone:
        if (!_isValidPhone(value)) {
          _botSay(St.botInvalidPhone.tr);
          return;
        }
        _phone = value;
        _botSay(St.botAskPassword.tr);
        _setStep(BotStep.askPassword, text: true);
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

  void _showSummary() {
    final fullName = [_firstName, _lastName].where((s) => s.trim().isNotEmpty).join(" ");
    final phone = _phone.trim().isEmpty ? St.botNotProvided.tr : _phone.trim();
    final summary = "${St.botSummaryIntro.tr}\n\n"
        "${St.botSummaryName.tr}: $fullName\n"
        "${St.botSummaryEmail.tr}: $_email\n"
        "${St.botSummaryPhone.tr}: $phone";
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
        mobileNumber: _phone,
      );
      if (result != null && result.status) {
        _botSay(result.message.trim().isNotEmpty ? result.message : St.botSubmitSuccess.tr);
        _setStep(BotStep.done, chips: [St.botBackToLogin.tr]);
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
    _phone = "";
    _password = "";
  }

  bool _isValidEmail(String email) =>
      RegExp(r"^[A-Za-z0-9.!#$%&'*+\-/=?^_`{|}~]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$").hasMatch(email.trim());

  bool _isValidPhone(String phone) => RegExp(r'^[+]?[0-9][0-9 \-()]{5,19}$').hasMatch(phone.trim());

  void _scrollToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}
