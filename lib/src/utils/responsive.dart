import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive({Key? key, required this.child, this.maxWidth}) : super(key: key);

  final Widget child;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? 600,
        ),
        child: child,
      )
    );
  }
}