import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tightwad/src/utils/utils.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.getBackgroundColorFromTheme(),
      body: SpinKitSquareCircle(
        color: Utils.getIconColorFromTheme(),
        size: 50.0,
        controller: AnimationController(vsync: this, duration: const Duration(seconds: 1)),
      ),
    );
  }
}
