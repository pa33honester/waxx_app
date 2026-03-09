import 'dart:async';

import 'package:era_shop/utils/app_colors.dart';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({
    super.key,
    required this.endDate,
    this.color,
    this.iconColor,
    this.containerColor,
  });

  final String? endDate;
  final Color? color;
  final Color? iconColor;
  final Color? containerColor;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;
  String _remainingText = '';

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  @override
  void didUpdateWidget(covariant TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endDate != widget.endDate) {
      _updateRemaining();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateRemaining() {
    final text = _formatRemaining(widget.endDate);
    if (!mounted || text == _remainingText) {
      return;
    }
    setState(() {
      _remainingText = text;
    });
  }

  String _formatRemaining(String? endDate) {
    if (endDate == null || endDate.trim().isEmpty) {
      return '--';
    }

    DateTime? endTime;
    try {
      endTime = DateTime.parse(endDate);
    } catch (_) {
      return '--';
    }

    final remaining = endTime.difference(DateTime.now());
    if (remaining.isNegative || remaining.inSeconds <= 0) {
      _timer?.cancel();
      return 'Ended';
    }

    if (remaining.inDays > 1) {
      return '${remaining.inDays} days left';
    }
    if (remaining.inDays == 1) {
      return '1 day left';
    }

    final hours = remaining.inHours.remainder(24).toString().padLeft(2, '0');
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: widget.containerColor ?? AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_filled_rounded,
            size: 14,
            color: widget.iconColor ?? widget.color ?? AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            _remainingText,
            style: TextStyle(
              color: widget.color ?? AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
