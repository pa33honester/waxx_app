import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/user_pages/signup_assistant/controller/signup_assistant_controller.dart';
import 'package:waxxapp/user_pages/signup_assistant/view/signup_assistant_body.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';

/// Master kill switch for the in-app help assistant. While `false`, the
/// floating bottom-right launcher renders nothing everywhere it's placed
/// (login / sign-up / onboarding screens) — the bot code, the `/SignupAssistant`
/// route and the backend stay in place but become unreachable. Flip to `false`
/// to turn the feature off.
const bool kSignupAssistantEnabled = false;

/// A floating help-chat launcher: a small circular bubble pinned to the
/// bottom-right that animates open into a compact chat panel layered on top of
/// the current screen (it does NOT navigate). Drop one in as the last child of
/// any screen's `Stack` that should offer in-app help — currently the login /
/// sign-up / onboarding screens.
///
/// Hosts a fresh [SignupAssistantController] each time it's opened (and deletes
/// it on close) so every session starts a new conversation. The conversation UI
/// itself is [SignupAssistantBody]; the Login / General-enquiry branches close
/// this panel via the controller's `onRequestClose` hook before navigating.
class SignupAssistantLauncher extends StatefulWidget {
  const SignupAssistantLauncher({super.key, this.bottom = 16, this.right = 16});

  /// Offsets of the collapsed bubble (and the panel's bottom edge) from the
  /// bottom-right of the host `Stack`. Bump [bottom] on screens whose own
  /// controls sit in the bottom-right (e.g. the onboarding pager's next button).
  final double bottom;
  final double right;

  @override
  State<SignupAssistantLauncher> createState() => _SignupAssistantLauncherState();
}

class _SignupAssistantLauncherState extends State<SignupAssistantLauncher> with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
  )..addStatusListener(_onAnimStatus);

  void _onAnimStatus(AnimationStatus status) {
    // Fully collapsed → drop the controller so the next open is a clean slate.
    if (status == AnimationStatus.dismissed && Get.isRegistered<SignupAssistantController>()) {
      Get.delete<SignupAssistantController>();
    }
  }

  bool get _open => _anim.status == AnimationStatus.completed || _anim.status == AnimationStatus.forward;

  void _expand() {
    if (_open) return;
    final c = Get.isRegistered<SignupAssistantController>()
        ? Get.find<SignupAssistantController>()
        : Get.put(SignupAssistantController());
    c.onRequestClose = _collapse;
    _anim.forward();
  }

  void _collapse() {
    if (_anim.status == AnimationStatus.dismissed || _anim.status == AnimationStatus.reverse) return;
    FocusManager.instance.primaryFocus?.unfocus();
    _anim.reverse();
  }

  @override
  void dispose() {
    _anim.dispose();
    if (Get.isRegistered<SignupAssistantController>()) Get.delete<SignupAssistantController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kSignupAssistantEnabled) return const SizedBox.shrink();

    final media = MediaQuery.of(context);
    final keyboard = media.viewInsets.bottom;
    final safeBottom = media.padding.bottom;
    final safeTop = media.padding.top;

    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Lift the panel above the keyboard ourselves — this overlay sits in
          // the screen's outermost Stack, which doesn't shrink for the keyboard
          // regardless of the host Scaffold's resizeToAvoidBottomInset.
          final panelBottom = widget.bottom + (keyboard > 0 ? keyboard : safeBottom);
          final bubbleBottom = widget.bottom + safeBottom; // bubble doesn't ride the keyboard
          final panelWidth = math.min(360.0, constraints.maxWidth - 24);
          final maxPanelHeight = constraints.maxHeight - panelBottom - safeTop - 16;
          final panelHeight = math.max(220.0, math.min(520.0, maxPanelHeight));

          return AnimatedBuilder(
            animation: _anim,
            builder: (context, _) {
              final t = _anim.value; // 0..1
              final showCard = t > 0.001;
              return Stack(
                children: [
                  // Tap-outside-to-close scrim (only while open / animating).
                  if (showCard)
                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _collapse,
                        child: ColoredBox(color: Colors.black.withValues(alpha: 0.05 * t)),
                      ),
                    ),
                  // The chat panel — grows out of the bubble's corner.
                  if (showCard)
                    Positioned(
                      right: widget.right,
                      bottom: panelBottom,
                      child: Opacity(
                        opacity: t,
                        child: Transform.scale(
                          alignment: Alignment.bottomRight,
                          scale: 0.7 + 0.3 * Curves.easeOut.transform(t),
                          child: _ChatCard(width: panelWidth, height: panelHeight, onClose: _collapse),
                        ),
                      ),
                    ),
                  // The collapsed bubble (hidden + non-interactive while the panel is up).
                  Positioned(
                    right: widget.right,
                    bottom: bubbleBottom,
                    child: IgnorePointer(
                      ignoring: t > 0.5,
                      child: Opacity(
                        opacity: 1.0 - t,
                        child: Transform.scale(scale: math.max(0.5, 1.0 - t), child: _FabBubble(onTap: _expand)),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _FabBubble extends StatelessWidget {
  const _FabBubble({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: St.signupAssistantTitle.tr,
      child: Material(
        color: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 6,
        shadowColor: Colors.black54,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 56,
            height: 56,
            child: Icon(Icons.support_agent_rounded, color: AppColors.black, size: 28),
          ),
        ),
      ),
    );
  }
}

class _ChatCard extends StatelessWidget {
  const _ChatCard({required this.width, required this.height, required this.onClose});
  final double width;
  final double height;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      shadowColor: Colors.black54,
      borderRadius: BorderRadius.circular(18),
      color: AppColors.black,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            // Header.
            Container(
              height: 52,
              color: AppColors.tabBackground,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.support_agent_rounded, color: AppColors.black, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      St.signupAssistantTitle.tr,
                      style: AppFontStyle.styleW800(AppColors.white, 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: Icon(Icons.close_rounded, color: AppColors.white, size: 22),
                    splashRadius: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    tooltip: St.botClose.tr,
                  ),
                ],
              ),
            ),
            const Expanded(child: SignupAssistantBody(compact: true)),
          ],
        ),
      ),
    );
  }
}
