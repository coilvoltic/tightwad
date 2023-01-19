import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tightwad/src/utils/utils.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitSquareCircle(
      color: Utils.getIconColorFromTheme(),
      size: 50.0,
      controller: _controller,
    );
  }
}
