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

  late List<List<int>> matrix = List.empty(growable: true);

  static void generateAndSetRoomId() async {
    final Random random = Random();
    final String roomId = (random.nextInt(Utils.ROOM_ID_MAX - Utils.ROOM_ID_MIN) + Utils.ROOM_ID_MIN).toString();
    setRoomId(roomId);
  }

  static void setRoomId(String roomId) async {
    await Database.registerRoomId(roomId);
  }

  void setGameStatus(final GameStatus gameStatus, { bool shouldNotify = false }) {
    _gameStatus = gameStatus;
    if (shouldNotify) {
      notifyListeners();
    }
  }

  GameStatus get getGameStatus        => _gameStatus;
  bool       get getIsMatrixAvailable => _isMatrixAvailable;

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
  }

  Future<bool> pushNewMatrix() async {
    print('new matrix created');
    bool isSuccessful = false;
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .update({
        'matrix': jsonEncode(matrix),
      }).whenComplete(() => {
        isSuccessful = true,
      }).onError((error, stackTrace) => {
        isSuccessful = false,
      });
    return isSuccessful;
  }

  Future<void> waitForGuestToReceiveMatrix() async {
    print('wait for guest');
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

  Future<bool> waitForMatrixToBeAvailable() async {
    bool isSuccessful = false;
    print('wait for matrix!');
    FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}').snapshots().listen(
      (event) async => {
        print('listening new event...'),
        if (event.exists && event.data()?.containsKey('matrix') == true && event.get('matrix') != '') {
          print(event.get('matrix')),
          print(jsonDecode(event.get('matrix'))),
          jsonDecode(event.get('matrix')).forEach((row) => {
            matrix.add(row.cast<int>()),
          }),
          isSuccessful = true,
        },
      },
    );
    return isSuccessful;
  }

  Future<bool> notifyMatrixReceived() async {
    print('notify received!');
    bool isSuccessful = false;
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .update({
        'matrixReceived': true,
      })
      .whenComplete(() => {
        isSuccessful = true,
        setGameStatus(GameStatus.playing),
      }).onError((error, stackTrace) => {
        isSuccessful = false,
      });
    return isSuccessful;
  }

  Future<bool> initMatrixSharing() async {
    bool isSuccessful = false;
    print('Init matrix');
    if (_gameStatus == GameStatus.loading) {
      if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.creator) {
          generateMatrix();
          isSuccessful = await pushNewMatrix();
        await waitForGuestToReceiveMatrix();
      } else if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.guest) {
        isSuccessful = await waitForMatrixToBeAvailable();
        isSuccessful = isSuccessful && await notifyMatrixReceived();
      }
    }
    return isSuccessful;
  }
}
