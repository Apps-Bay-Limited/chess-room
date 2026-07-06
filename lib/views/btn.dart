import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/app_design.dart';

class Btn extends StatefulWidget {
  final List<Color>? gradient;
  final Color? color;
  final double? height;
  final double? width;
  final GestureTapCallback? onTap;
  final double borderRadius;
  final Widget? child;

  const Btn({
    super.key,
    this.gradient,
    this.color,
    this.onTap,
    this.child,
    this.borderRadius = 0,
    this.height,
    this.width,
  });

  @override
  State<Btn> createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (_pressed == pressed) return;
    setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return GestureDetector(
      onTapDown: enabled ? (_) => _setPressed(true) : null,
      onTapCancel: enabled ? () => _setPressed(false) : null,
      onTapUp: enabled ? (_) => _setPressed(false) : null,
      onTap: enabled
          ? () {
              HapticFeedback.lightImpact();
              widget.onTap!();
            }
          : null,
      child: AnimatedScale(
        scale: _pressed && !reduceMotion ? 0.96 : 1,
        duration: AppDurations.fast,
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: enabled ? 1 : 0.5,
          duration: AppDurations.fast,
          child: Container(
            height: widget.height == null
                ? null
                : (widget.height! < kMinTouchTarget ? kMinTouchTarget : widget.height),
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: widget.color,
              gradient: widget.gradient == null
                  ? null
                  : LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.1, 0.8],
                      colors: widget.gradient!),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    spreadRadius: 5,
                    blurRadius: 10)
              ],
            ),
            child: Center(
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
