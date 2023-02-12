import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';

import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
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
    return Consumer2<GameHandlerNotifier, MultiPlayerNotifier>(
      builder: (context, ghNotifier, mpNotifier, _) {
        if (ghNotifier.getGameStatus == GameStatus.win        ||
            ghNotifier.getGameStatus == GameStatus.nextlevel  ||
            ghNotifier.getGameStatus == GameStatus.finish     ||
            mpNotifier.getGameStatus == GameStatus.win        ||
            mpNotifier.getGameStatus == GameStatus.winsession ||
            mpNotifier.getGameStatus == GameStatus.leavewon)
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