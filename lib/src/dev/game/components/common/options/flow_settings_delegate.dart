import 'dart:math';

import 'package:flutter/material.dart';

class FlowSettingsDelegate extends FlowDelegate {

  const FlowSettingsDelegate({
    required this.controller,
    required this.buttonSize,
    required this.xPos,
    required this.yPos,
    }) : super(repaint: controller);

  final Animation<double> controller;
  final double buttonSize;
  final double xPos;
  final double yPos;

  @override
  void paintChildren(FlowPaintingContext context) {

    const double buttonSizeRatio = 1.8;
    final double radius = buttonSize * buttonSizeRatio * controller.value;
    final int n = context.childCount;

    for (int i = 0; i < n; i++) {

      double x = 0.0;
      double y = 0.0;
      double z = 0.0;
      double scale = max(1 - controller.value, 0.9);

      /** Chaque bouton sauf le main. */
      if (i != n - 1) {
        final double theta = i * pi * 0.5 / (n - 3) - pi / 4 + pi;
        x = radius * cos(theta);
        y = radius * sin(theta);
        z = 0.0;
        scale = controller.value;
      }
      context.paintChild(
        i,
        transform: Matrix4.identity()
          ..translate(x + xPos, y + yPos, z)
          ..translate(buttonSize / 2, buttonSize / 2)
          ..rotateZ  (controller.value * 2 * pi)
          ..scale    (scale)
          ..translate(-buttonSize / 2, -buttonSize / 2)
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return false;
  }
}