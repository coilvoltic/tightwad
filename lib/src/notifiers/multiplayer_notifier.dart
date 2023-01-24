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
  bool _isMatrixAvailable = false;
  bool _isMatrixCreated = false;

  late List<List<int>> matrix = List.empty(growable: true);

  static void generateAndSetRoomId() async {
    final Random random = Random();
    final String roomId = (random.nextInt(Utils.ROOM_ID_MAX - Utils.ROOM_ID_MIN) + Utils.ROOM_ID_MIN).toString();
    setRoomId(roomId);
  }

  static void setRoomId(String roomId) async {
    await Database.registerRoomId(roomId);
  }

  void setGameStatus(final GameStatus gameStatus) {
    _gameStatus = gameStatus;
    notifyListeners();
  }

  GameStatus get getGameStatus        => _gameStatus;
  bool       get getIsMatrixAvailable => _isMatrixAvailable;
  bool       get getIsMatrixCreated   => _isMatrixCreated;

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
    print(matrix);
    _isMatrixCreated = true;
  }

  Future<void> pushNewMatrix() async {
    print('new matrix created');
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .update({
        'matrix': jsonEncode(matrix),
      });
  }

  Future<void> waitForGuestToReceiveMatrix() async {
    FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}').snapshots().listen(
      (event) async => {
        if (event.exists) {
          if (event.get('matrixReceived') == true) {
            setGameStatus(GameStatus.playing),
          }
        }
      },
    );
  }

  Future<void> waitForMatrixToBeAvailable() async {
    FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}').snapshots().listen(
      (event) async => {
        if (event.exists && event.data()?.containsKey('matrix') == true && event.get('matrix') != '' && !_isMatrixAvailable) {
          print(event.get('matrix')),
          print(jsonDecode(event.get('matrix'))),
          jsonDecode(event.get('matrix')).forEach((row) => {
            matrix.add(row.cast<int>()),
          }),
          _isMatrixAvailable = true,
          notifyListeners(),
        },
      },
    );
  }

  Future<void> notifyMatrixReceived() async {
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .update({
        'matrixReceived': true,
      })
      .whenComplete(() => {
        setGameStatus(GameStatus.playing),
      });
  }

  Future<bool> initMatrixSharing() async {
    if (_gameStatus == GameStatus.loading) {
      if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.creator) {
        if (!_isMatrixCreated) {
          generateMatrix();
          await pushNewMatrix();
        }
        await waitForGuestToReceiveMatrix();
        return true;
      } else if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.guest) {
        await waitForMatrixToBeAvailable();
        if (_isMatrixAvailable) {
          await notifyMatrixReceived();
          return true;
        }
      }
    }
    return false;
  }
}
