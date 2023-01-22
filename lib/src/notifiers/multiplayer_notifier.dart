import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/coordinates.dart';
import 'package:tightwad/src/utils/game_utils.dart';

class MultiPlayerNotifier extends ChangeNotifier {

  GameStatus _gameStatus = GameStatus.none;
  static MultiPlayerStatus multiPlayerStatus = MultiPlayerStatus.none;

  late List<List<int>> matrix = List.empty(growable: true);

  static void generateAndSetRoomId() async {
    final Random random = Random();
    final String roomId = random.nextInt(999999).toString();
    setRoomId(roomId);
  }

  static void setRoomId(String roomId) async {
    await Database.registerRoomId(roomId);
  }

  void setGameStatus(final GameStatus gameStatus) {
    _gameStatus = gameStatus;
  }

  GameStatus get getGameStatus => _gameStatus;

  int getSqDim() {
    return matrix.length;
  }

  int getMatrixElement(final Coordinates move) {
    return matrix.elementAt(move.x - 1).elementAt(move.y - 1);
  }

  Future<void> generateAndPushNewMatrix() async {
    final Random random = Random();
    final int sqDim = random.nextInt(GameUtils.MULTIPLAYER_SQ_DIM_MAX - GameUtils.MULTIPLAYER_SQ_DIM_MIN) + GameUtils.MULTIPLAYER_SQ_DIM_MIN;

    matrix = GameUtils.computeRandomMatrix(sqDim);

    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .update({
        'matrix': jsonEncode(matrix),
      })
      .whenComplete(() => {
        _gameStatus = GameStatus.playing,
        notifyListeners(),
      });
  }

  Future<void> waitForGuestToReceiveMatrix() async {
    final Random random = Random();
    final int sqDim = random.nextInt(GameUtils.MULTIPLAYER_SQ_DIM_MAX - GameUtils.MULTIPLAYER_SQ_DIM_MIN) + GameUtils.MULTIPLAYER_SQ_DIM_MIN;

    matrix = GameUtils.computeRandomMatrix(sqDim);

    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .update({
        'matrix': matrix,
      })
      .whenComplete(() => {
        _gameStatus = GameStatus.playing,
        notifyListeners(),
      });
  }

  Future<void> fetchMatrix() async {
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .get()
      .then((doc) {
        final serializedMatrix = jsonDecode(doc.get('matrix'));
        serializedMatrix.forEach((row) => {
          matrix.add(row),
        });
      });
  }

  Future<void> notifyMatrixReceived() async {
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .update({
        'matrixReceived': true,
      })
      .whenComplete(() => {
        _gameStatus = GameStatus.playing,
        notifyListeners(),
      });
  }

}