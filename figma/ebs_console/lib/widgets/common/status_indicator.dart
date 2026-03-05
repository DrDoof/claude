import 'package:flutter/material.dart';
import '../../theme/ebs_colors.dart';

enum IndicatorType { live, active, idle, warning }

class StatusIndicator extends StatefulWidget {
  final IndicatorType type;
  final double size;

  const StatusIndicator({
    super.key,
    required this.type,
    this.size = 8,
  });

  @override
  State<StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController? _controller;
  late final Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    if (widget.type == IndicatorType.live) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      )..repeat(reverse: true);
      _animation = Tween<double>(begin: 1.0, end: 0.4).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
      );
    } else {
      _controller = null;
      _animation = null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Color get _color {
    switch (widget.type) {
      case IndicatorType.live:
        return EbsColors.danger;
      case IndicatorType.active:
        return EbsColors.success;
      case IndicatorType.idle:
        return EbsColors.textMuted;
      case IndicatorType.warning:
        return EbsColors.warning;
    }
  }

  bool get _hasGlow =>
      widget.type == IndicatorType.live ||
      widget.type == IndicatorType.active ||
      widget.type == IndicatorType.warning;

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _color,
        boxShadow: _hasGlow
            ? [BoxShadow(color: _color.withValues(alpha: 0.6), blurRadius: 6)]
            : null,
      ),
    );

    if (_animation case final anim?) {
      return AnimatedBuilder(
        animation: anim,
        builder: (_, child) => Opacity(opacity: anim.value, child: child),
        child: dot,
      );
    }
    return dot;
  }
}
