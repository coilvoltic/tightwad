import 'package:flutter/material.dart';

class WaitingOpponent extends StatefulWidget {
  const WaitingOpponent({Key? key}) : super(key: key);

  @override
  State<WaitingOpponent> createState() => _WaitingOpponentState();
}

class _WaitingOpponentState extends State<WaitingOpponent> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('waiting for opponent...'),
    );
  }
}