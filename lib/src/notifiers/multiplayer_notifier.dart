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

  List<List<int>> matrix = List.empty(growable: true);
  List<Coordinates> guestMoves = List.empty(growable: true);
  List<Coordinates> creatorMoves = List.empty(growable: true);
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listener;


  bool _isMatrixBeingCreated = false;
  bool _isMatrixReceived = false;
  bool _isFetchingData = false;
  bool _isListening = false;
  Player turn = Player.creator;

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
  Player get getTurn => turn;

  int getSqDim() {
    return matrix.length;
  }

  int getMatrixElement(final Coordinates move) {
    return matrix.elementAt(move.x - 1).elementAt(move.y - 1);
  }

  Coordinates? getGuestLastMove() {
    if (guestMoves.isEmpty) {
      return null;
    }
    return guestMoves.last;
  }

  Coordinates? getCreatorLastMove() {
    if (creatorMoves.isEmpty) {
      return null;
    }
    return creatorMoves.last;
  }

  void generateMatrix() {
    final Random random = Random();
    final int sqDim = random.nextInt(GameUtils.MULTIPLAYER_SQ_DIM_MAX - GameUtils.MULTIPLAYER_SQ_DIM_MIN) + GameUtils.MULTIPLAYER_SQ_DIM_MIN;
    matrix = GameUtils.computeRandomMatrix(sqDim);
  }

  Future<bool> createAndPushMatrix() async {
    bool isSuccessful = true;
    if (!_isMatrixBeingCreated) {
      _isMatrixBeingCreated = true;
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

  Future<bool> notifyCreatorNewMove(final Coordinates move) async {
    bool isSuccessful = false;
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .update({
        'creatorLastMove': {
          'x': move.x,
          'y': move.y,
        },
        'turn': 'guest',
      }).whenComplete(() => {
        turn = Player.guest,
        isSuccessful = true,
      }).onError((error, stackTrace) => {
        isSuccessful = false,
      });
    return isSuccessful;
  }

  Future<bool> notifyGuestNewMove(final Coordinates move) async {
    bool isSuccessful = false;
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .update({
        'guestLastMove': {
          'x': move.x,
          'y': move.y,
        },
        'turn': 'creator',
      }).whenComplete(() => {
        print('guest move stored!'),
        turn = Player.guest,
        isSuccessful = true,
      }).onError((error, stackTrace) => {
        isSuccessful = false,
      });
    return isSuccessful;
  }

  Future<bool> listenToGuestMove() async {
    _isListening = true;
    listener = FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}').snapshots().listen((event) async => {
        if (event.exists && event.data()!.containsKey('guestLastMove')) {
          guestMoves.add(Coordinates(event.get(FieldPath(const ['guestLastMove', 'x'])), event.get(FieldPath(const ['guestLastMove', 'y'])))),
          guestMoves.forEach((element) {
            print('x : ' + (element.x).toString());
            print('y : ' + (element.y).toString());
          }),
          turn = Player.creator,
          _isListening = false,
          listener.cancel(),
        }
      },
    );
    return true;
  }

  Future<bool> listenToCreatorMove() async {
    _isListening = true;
    listener = FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}').snapshots().listen((event) async => {
        if (event.exists && event.data()!.containsKey('creatorLastMove')) {
          creatorMoves.add(Coordinates(event.get(FieldPath(const ['creatorLastMove', 'x'])), event.get(FieldPath(const ['creatorLastMove', 'y'])))),
          creatorMoves.forEach((element) {
            print('x : ' + (element.x).toString());
            print('y : ' + (element.y).toString());
          }),
          turn = Player.guest,
          _isListening = false,
          listener.cancel(),
        }
      },
    );
    return true;
  }
}
