import 'dart:async';

import 'package:flutter/material.dart';

class TimedInkwell extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final Duration tapDelay;

  const TimedInkwell({
    this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.tapDelay = const Duration(milliseconds: 300),
    super.key,
  });

  @override
  State<TimedInkwell> createState() => _TimedInkwellState();
}

class _TimedInkwellState extends State<TimedInkwell> {
  Timer? _tapTimer;
  bool _awaitingDoubleTap = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap?.call();
        if (_awaitingDoubleTap) {
          widget.onDoubleTap?.call();
          _awaitingDoubleTap = false;
          _tapTimer?.cancel();
          _tapTimer = null;
        } else {
          _awaitingDoubleTap = true;
          _tapTimer = Timer(widget.tapDelay, () => _awaitingDoubleTap = false);
        }
      },
      onLongPress: widget.onLongPress,
      child: widget.child,
    );
  }
}
