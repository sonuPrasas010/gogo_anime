import 'dart:math' as math;

import 'package:flutter/material.dart';

class RotateAd extends StatefulWidget {
  const RotateAd({Key? key}) : super(key: key);

  @override
  State<RotateAd> createState() => _RotateAdState();
}

class _RotateAdState extends State<RotateAd>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: child,
        );
      },
      child: Image.asset(
        "lib/advertisement.png",
        height: 30,
        width: 30,
      ),
    );
  }
}
