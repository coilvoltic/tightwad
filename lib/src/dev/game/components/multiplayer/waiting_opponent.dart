import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/dev/game/components/multiplayer/validation_button.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/responsive.dart';
import 'package:tightwad/src/utils/utils.dart';

class WaitingOpponent extends StatefulWidget {
  const WaitingOpponent({Key? key}) : super(key: key);

  @override
  State<WaitingOpponent> createState() => _WaitingOpponentState();
}

class _WaitingOpponentState extends State<WaitingOpponent> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  final double ratioWaitingOpponentStatement = 0.41;
  final double ratioLoader = 0.15;
  final double ratioRoomIdStatement = 0.2;

  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> _listener;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _listener.cancel();
    super.dispose();
  }

  Widget buildWaitingOpponentStatement() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * ratioWaitingOpponentStatement,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'waiting for',
            style: TextStyle(
              fontFamily: 'BebasNeue',
              decoration: TextDecoration.none,
              fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 40),
              fontWeight: FontWeight.bold,
              color: Utils.getPassedColorFromTheme(),
            ),
          ),
          GlowText(
            'opponent',
            blurRadius: Utils.shouldGlow() ? Utils.GLOWING_VALUE : 0.0,
            glowColor: Utils.shouldGlow()
                  ? Utils.getPassedColorFromTheme()
                  : Colors.transparent,
            style: TextStyle(
              fontFamily: 'Parisienne',
              decoration: TextDecoration.none,
              fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 30),
              fontWeight: FontWeight.bold,
              color: Utils.getPassedColorFromTheme(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRoomIdStatement() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * ratioLoader,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'your room id',
            style: TextStyle(
              fontFamily: 'BebasNeue',
              decoration: TextDecoration.none,
              fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 8),
              fontWeight: FontWeight.bold,
              color: Utils.getPassedColorFromTheme(),
            ),
          ),
          Text(
            Database.getRoomId(),
            style: TextStyle(
              fontFamily: 'BebasNeue',
              decoration: TextDecoration.none,
              fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 15),
              fontWeight: FontWeight.bold,
              color: Utils.getPassedColorFromTheme(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoader() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * ratioRoomIdStatement,
      child: SpinKitWave(
        color: Utils.getIconColorFromTheme(),
        size: 50.0,
        controller: _controller,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {

    EntityNotifier entityNotifier = Provider.of<EntityNotifier>(context, listen: true);
    MultiPlayerNotifier mpNotifier = Provider.of<MultiPlayerNotifier>(context, listen: false);

    _listener = FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}').snapshots().listen((event) async => {
        if (event.exists) {
          if (event.get('gameStarted') == true) {
            mpNotifier.setGameStatus(GameStatus.loading),
            await Future.delayed(const Duration(seconds: Utils.LOADING_DURATION)),
            entityNotifier.changeGameEntity(Entity.multiplayergame),
          }
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Responsive(
        child: Consumer<OptionsNotifier>(builder: (context, _, __) {
            MultiPlayerNotifier mpNotifier = Provider.of<MultiPlayerNotifier>(context, listen: true);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildWaitingOpponentStatement(),
                buildLoader(),
                buildRoomIdStatement(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ValidationButton(onTap: () async {
                  mpNotifier.setGameStatus(GameStatus.loading);
                  await Utils.deleteRoomIfExists();
                  entityNotifier.changeGameEntity(Entity.lobby);
                  mpNotifier.setGameStatus(GameStatus.none);
                },
                icon: Icons.close),
              ],
            );
          }
        ),
      ),
    );
  }
}
