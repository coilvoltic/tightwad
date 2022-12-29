import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';

import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';


class Confettis extends StatefulWidget {
  const Confettis({ Key? key }) : super(key: key);

  @override
  State<Confettis> createState() => _ConfettisState();
}

class _ConfettisState extends State<Confettis> {

  late ConfettiController _controller;

  @override
  void initState()
  {
    super.initState();
    _controller = ConfettiController(duration: const Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameHandlerNotifier>(
      builder: (context, notifier, _) {
        if (notifier.getGameStatus == GameStatus.win       ||
            notifier.getGameStatus == GameStatus.nextlevel ||
            notifier.getGameStatus == GameStatus.finish)
        {
          _controller.play();
        }
        else
        {
          _controller.stop();
        }
        return Center(
          child: ConfettiWidget(
            confettiController: _controller,
            colors: const [
              Colors.blue,
              Colors.red,
              Colors.green,
              Colors.yellow,
              Colors.purple,
              Colors.orange,
              Colors.pink
            ],
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 20,
            shouldLoop: true,
          ),
        );
      }
    );
  }
}