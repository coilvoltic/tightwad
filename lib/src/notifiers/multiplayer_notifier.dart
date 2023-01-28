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
  List<Coordinates> _guestPossibleMoves = List.empty(growable: true);
  List<Coordinates> _creatorPossibleMoves = List.empty(growable: true);

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

  Coordinates getGuestLastMove() {
    if (guestMoves.isEmpty) {
      return Coordinates(-1, -1);
    }
    return guestMoves.last;
  }

  Coordinates getCreatorLastMove() {
    if (creatorMoves.isEmpty) {
      return Coordinates(-1, -1);
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
      _creatorPossibleMoves = GameUtils.fillAllMoves(getSqDim());
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
      print('fetch matrix!');
      await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .get()
        .then((doc) {
          print('matrix fetched!');
          if (doc.exists && doc.data()?.containsKey('matrix') == true && doc.get('matrix') != '') {
            jsonDecode(doc.get('matrix')).forEach((row) => {
              matrix.add(row.cast<int>()),
            });
            _isMatrixReceived = true;
            _isFetchingData = false;
            _guestPossibleMoves = GameUtils.fillAllMoves(getSqDim());
            setGameStatus(GameStatus.playing);
          }
        }).timeout(const Duration(seconds: Utils.REQUEST_TIME_OUT), onTimeout: () {
          print('KL timed out.');
          isSuccessful = false;
        }).onError((errorObj, stackTrace) {
          print('KL an error occured.');
          isSuccessful = false;
        });
      await Future.delayed(const Duration(seconds: 1));
    }
    return isSuccessful;
  }

  void initializeGame() {
    _creatorPossibleMoves = GameUtils.fillAllMoves(getSqDim());
    _guestPossibleMoves = GameUtils.fillAllMoves(getSqDim());
  }

  Future<bool> notifyCreatorNewMove(final Coordinates move) async {
    bool isSuccessful = false;
    GameUtils.updatePossibleMoves(_creatorPossibleMoves, move, getSqDim());
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .update({
        'creatorLastMove': {
          'x': move.x,
          'y': move.y,
        },
        'guestLastMove': '',
      }).whenComplete(() => {
        turn = Player.guest,
        isSuccessful = true,
        notifyListeners(),
      }).onError((error, stackTrace) => {
        isSuccessful = false,
      });
    return isSuccessful;
  }

  Future<bool> notifyGuestNewMove(final Coordinates move) async {
    bool isSuccessful = false;
    GameUtils.updatePossibleMoves(_guestPossibleMoves, move, getSqDim());
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .update({
        'guestLastMove': {
          'x': move.x,
          'y': move.y,
        },
        'creatorLastMove': '',
      }).whenComplete(() => {
        turn = Player.creator,
        isSuccessful = true,
        notifyListeners(),
      }).onError((error, stackTrace) => {
        isSuccessful = false,
      });
    return isSuccessful;
  }

  Future<bool> listenToGuestMove() async {
    if (!_isListening) {
      _isListening = true;
      listener =  FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}').snapshots().listen((event) async => {
          if (event.exists && event.data()!.containsKey('guestLastMove') && event.get('guestLastMove') != '') {
            guestMoves.add(Coordinates(event.get(FieldPath(const ['guestLastMove', 'x'])), event.get(FieldPath(const ['guestLastMove', 'y'])))),
            turn = Player.creator,
            _isListening = false,
            _creatorPossibleMoves.removeWhere((element) =>
              element.x == getGuestLastMove().x && element.y == getGuestLastMove().y),
            listener.cancel(),
            notifyListeners(),
          }
        },
      );
    }
    return true;
  }

  Future<bool> listenToCreatorMove() async {
    if (!_isListening) {
      _isListening = true;
      listener = FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}').snapshots().listen((event) async => {
          if (event.exists && event.data()!.containsKey('creatorLastMove') && event.get('creatorLastMove') != '') {
            creatorMoves.add(Coordinates(event.get(FieldPath(const ['creatorLastMove', 'x'])), event.get(FieldPath(const ['creatorLastMove', 'y'])))),
            turn = Player.guest,
            _isListening = false,
            _guestPossibleMoves.removeWhere((element) =>
              element.x == getCreatorLastMove().x && element.y == getCreatorLastMove().y),
            listener.cancel(),
            notifyListeners(),
          }
        },
      );
    }
    return true;
  }

  bool isForbiddenGuestMove(final Coordinates move) {
    return !_guestPossibleMoves.any((item) => item.x == move.x && item.y == move.y);
  }

  bool isForbiddenCreatorMove(final Coordinates move) {
    return !_creatorPossibleMoves.any((item) => item.x == move.x && item.y == move.y);
  }

}
