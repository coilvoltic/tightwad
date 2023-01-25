import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/coordinates.dart';
import 'package:tightwad/src/utils/game_utils.dart';
import 'package:tightwad/src/utils/utils.dart';

class MultiPlayerNotifier extends ChangeNotifier {

  GameStatus _gameStatus = GameStatus.none;
  static MultiPlayerStatus multiPlayerStatus = MultiPlayerStatus.none;

  late List<List<int>> matrix = List.empty(growable: true);

  bool _isMatrixBeingCreated = false;
  bool _isMatrixReceived = false;
  bool _isFetchingData = false;

  static void generateAndSetRoomId() async {
    final Random random = Random();
    final String roomId = (random.nextInt(Utils.ROOM_ID_MAX - Utils.ROOM_ID_MIN) + Utils.ROOM_ID_MIN).toString();
    setRoomId(roomId);
  }

  static void setRoomId(String roomId) async {
    await Database.registerRoomId(roomId);
  }

  void setGameStatus(final GameStatus gameStatus, { bool shouldNotify = true }) {
    _gameStatus = gameStatus;
    if (shouldNotify) {
      notifyListeners();
    }
  }

  GameStatus get getGameStatus => _gameStatus;

  int getSqDim() {
    return matrix.length;
  }

  int getMatrixElement(final Coordinates move) {
    return matrix.elementAt(move.x - 1).elementAt(move.y - 1);
  }

  void generateMatrix() {
    final Random random = Random();
    final int sqDim = random.nextInt(GameUtils.MULTIPLAYER_SQ_DIM_MAX - GameUtils.MULTIPLAYER_SQ_DIM_MIN) + GameUtils.MULTIPLAYER_SQ_DIM_MIN;
    matrix = GameUtils.computeRandomMatrix(sqDim);
  }

  void setMatrix(final dynamic serializedMatrix) {
    serializedMatrix.forEach((row) => {
      matrix.add(row.cast<int>()),
    });
  }

  Future<bool> createAndPushMatrix() async {
    bool isSuccessful = true;
    if (!_isMatrixBeingCreated) {
      _isMatrixBeingCreated = true;
      print('enter');
      generateMatrix();
      await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
        .update({
          'matrix': jsonEncode(matrix),
        }).whenComplete(() => {
          _isMatrixBeingCreated = false,
          isSuccessful = true,
          setGameStatus(GameStatus.playing),
        }).onError((error, stackTrace) => {
          _isMatrixBeingCreated = false,
          isSuccessful = false,
        });
    }
    return isSuccessful;
  }

  Future<bool> waitForMatrixAndStoreIt() async {
    bool isSuccessful = true;
    if (_isFetchingData) {
      return true;
    }
    _isFetchingData = true;
    while (!_isMatrixReceived && isSuccessful) {
      await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .get()
        .then((doc) {
          if (doc.exists && doc.data()?.containsKey('matrix') == true && doc.get('matrix') != '') {
            jsonDecode(doc.get('matrix')).forEach((row) => {
              matrix.add(row.cast<int>()),
            });
            _isMatrixReceived = true;
            _isFetchingData = false;
            setGameStatus(GameStatus.playing);
          }
        }).timeout(const Duration(seconds: Utils.REQUEST_TIME_OUT), onTimeout: () {
          isSuccessful = false;
        }).onError((errorObj, stackTrace) {
          isSuccessful = false;
        });
      await Future.delayed(const Duration(seconds: 1));
    }
    return isSuccessful;
  }

}
