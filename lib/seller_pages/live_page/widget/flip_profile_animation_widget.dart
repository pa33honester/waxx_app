import 'dart:math';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class FlipProfileAnimationWidget extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String message;
  final String backImageAsset;
  final VoidCallback onFlipCompleted; // Callback function

  const FlipProfileAnimationWidget({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.message,
    required this.onFlipCompleted, // Added callback parameter
    this.backImageAsset = AppAsset.icAppIcon,
  }) : super(key: key);

  @override
  _FlipProfileAnimationWidgetState createState() => _FlipProfileAnimationWidgetState();
}

class _FlipProfileAnimationWidgetState extends State<FlipProfileAnimationWidget> with SingleTickerProviderStateMixin {
  bool isFlipped = false;
  late AnimationController _controller;
  late Animation<double> _frontAnimation;
  late Animation<double> _backAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Add status listener for animation completion
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.onFlipCompleted(); // Invoke the callback
      }
    });

    _frontAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -pi / 2), weight: 0.5),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 0.5),
    ]).animate(_controller);

    _backAnimation = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(pi / 2), weight: 0.5),
      TweenSequenceItem(tween: Tween(begin: pi / 2, end: 0.0), weight: 0.5),
    ]).animate(_controller);

    Future.delayed(const Duration(milliseconds: 3200), _flipCard);
  }

  @override
  void dispose() {
    _controller.removeStatusListener((status) {}); // Clean up listener
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    setState(() {
      isFlipped = !isFlipped;
      isFlipped ? _controller.forward() : _controller.reverse();
    });
  }

  Widget _buildProfileImage(String imageUrl, String name) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        gradient: AppColors.greenYellowGradient,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 0.5,
          )
        ],
      ),
      child: Center(
        child: ClipOval(
          child: Container(
            width: 68,
            height: 68,
            color: Colors.white,
            child: _buildImageContent(imageUrl, name),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent(String imageUrl, String name) {
    if (imageUrl.isEmpty) {
      return _buildInitials(name);
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildInitials(name);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildInitials(name);
      },
    );
  }

  Widget _buildInitials(String name) {
    final initials = name.isNotEmpty ? name[0] : '?';
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back side
          AnimatedBuilder(
            animation: _backAnimation,
            builder: (context, _) {
              return Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002)
                  ..rotateY(_backAnimation.value),
                child: Visibility(
                  visible: _controller.value >= 0.5,
                  child: _buildBackSide(),
                ),
              );
            },
          ),

          // Front side
          AnimatedBuilder(
            animation: _frontAnimation,
            builder: (context, _) {
              return Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002)
                  ..rotateY(_frontAnimation.value),
                child: Visibility(
                  visible: _controller.value < 0.5,
                  child: _buildFrontSide(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFrontSide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetAnimator(
          incomingEffect: WidgetTransitionEffects.incomingSlideInFromBottom(),
          child: _buildProfileImage(widget.imageUrl, widget.name),
        ),
        const SizedBox(height: 8),
        Text(
          widget.name,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        TextAnimator(
          widget.message,
          style: AppFontStyle.styleW700(AppColors.black, 18),
          incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
          outgoingEffect: WidgetTransitionEffects.outgoingScaleDown(),
          atRestEffect: WidgetRestingEffects.none(),
          textAlign: TextAlign.center,
          initialDelay: const Duration(milliseconds: 0),
          spaceDelay: const Duration(milliseconds: 150),
          characterDelay: const Duration(milliseconds: 60),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildBackSide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 20.0,
                spreadRadius: 0.8,
              )
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Image.asset(
            widget.backImageAsset,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildInitials(widget.name);
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.name,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.message,
          style: AppFontStyle.styleW700(AppColors.black, 18),
        ),
      ],
    );
  }
}
