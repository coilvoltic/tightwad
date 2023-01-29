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
  int  _creatorScore = 0;
  int  _guestScore = 0;
  bool _areNamesFetched = false;
  String _creatorName = '';
  String _guestName = '';
  Player turn = Player.creator;

  GameStatus get getGameStatus => _gameStatus;
  Player get getTurn => turn;
  int get getCreatorScore => _creatorScore;
  int get getGuestScore => _guestScore;
  bool get getAreNamesFetched => _areNamesFetched;
  String get getCreatorName => _creatorName;
  String get getGuestName => _guestName;

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

  Future<bool> fetchNames() async {
    bool isSuccessful = true;
    _areNamesFetched = true;
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .get()
        .then((doc) {
          if (doc.exists && doc.data()?.containsKey('guestName') != null && doc.data()?.containsKey('creatorName') != null) {
            _creatorName = doc.get('creatorName');
            _guestName = doc.get('guestName');
          }
        }).timeout(const Duration(seconds: Utils.REQUEST_TIME_OUT), onTimeout: () {
          isSuccessful = false;
          _areNamesFetched = false;
        }).onError((errorObj, stackTrace) {
          isSuccessful = false;
          _areNamesFetched = false;
        });
    return isSuccessful;
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
      print(matrix);
      _creatorPossibleMoves = GameUtils.fillAllMoves(getSqDim());
      await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
        .update({
          'matrix': jsonEncode(matrix),
        }).whenComplete(() => {
          _isMatrixBeingCreated = false,
          isSuccessful = true,
          print('matrix completed'),
          setGameStatus(GameStatus.playing),
        }).onError((error, stackTrace) => {
          _isMatrixBeingCreated = false,
          print('KL createMatrix error'),
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
            _guestPossibleMoves = GameUtils.fillAllMoves(getSqDim());
            setGameStatus(GameStatus.playing);
          }
        }).timeout(const Duration(seconds: Utils.REQUEST_TIME_OUT), onTimeout: () {
          isSuccessful = false;
        }).onError((errorObj, stackTrace) {
          isSuccessful = false;
        });
      await Future.delayed(const Duration(seconds: 1));
    }
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
    .update({
      'matrix': '',
      'matrix_backup': jsonEncode(matrix),
    });
    return isSuccessful;
  }

  void updateLocalCreatorTiles(final Coordinates move) {
    _creatorScore += matrix.elementAt(move.x - 1).elementAt(move.y - 1);
    creatorMoves.add(move);
    if (checkEndGame()) {
      endGame();
    } else {
      GameUtils.updatePossibleMoves(_creatorPossibleMoves, move, getSqDim());
      if (creatorMoves.length == getSqDim() - 2) {
        GameUtils.preventPotentialStuckSituation(_creatorPossibleMoves);
      }
      notifyListeners();
    }
  }

  Future<bool> notifyCreatorNewMove(final Coordinates move) async {
    bool isSuccessful = false;
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .update({
        'creatorLastMove': {
          'x': move.x,
          'y': move.y,
        },
        'guestLastMove': '',
      }).whenComplete(() => {
        if (!checkEndGame()) {
          turn = Player.guest,
        },
        isSuccessful = true,
        notifyListeners(),
      }).onError((error, stackTrace) => {
        isSuccessful = false,
      });
    return isSuccessful;
  }

  void updateLocalGuestTiles(final Coordinates move) {
    _guestScore += matrix.elementAt(move.x - 1).elementAt(move.y - 1);
    guestMoves.add(move);
    if (checkEndGame()) {
      endGame();
    } else {
      GameUtils.updatePossibleMoves(_guestPossibleMoves, move, getSqDim());
      if (guestMoves.length == getSqDim() - 2) {
        GameUtils.preventPotentialStuckSituation(_guestPossibleMoves);
      }
      notifyListeners();
    }
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
        if (!checkEndGame()) {
          turn = Player.creator,
        },
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
            print('guestMoves.length:'),
            print(guestMoves.length),
            _guestScore += matrix.elementAt(guestMoves.last.x - 1).elementAt(guestMoves.last.y - 1),
            if (checkEndGame()) {
              notifyListeners(),
              endGame(),
            } else {
              turn = Player.creator,
              _creatorPossibleMoves.removeWhere((element) =>
                element.x == getGuestLastMove().x && element.y == getGuestLastMove().y),
              if (creatorMoves.length == getSqDim() - 2) {
                GameUtils.preventPotentialStuckSituation(_creatorPossibleMoves),
              },
              notifyListeners(),
            },
            _isListening = false,
            listener.cancel(),
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
            _creatorScore += matrix.elementAt(creatorMoves.last.x - 1).elementAt(creatorMoves.last.y - 1),
            if (checkEndGame()) {
              notifyListeners(),
              endGame(),
            } else {
              turn = Player.guest,
              _guestPossibleMoves.removeWhere((element) =>
                element.x == getCreatorLastMove().x && element.y == getCreatorLastMove().y),
              if (guestMoves.length == getSqDim() - 2) {
                GameUtils.preventPotentialStuckSituation(_guestPossibleMoves),
              },
              notifyListeners(),
            },
            _isListening = false,
            listener.cancel(),
          },
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

  void endGame() {
    if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.creator) {
      if (_creatorScore < _guestScore) {
        setWin();
      } else {
        setLose();
      }
    } else if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.guest) {
      if (_guestScore < _creatorScore) {
        setWin();
      } else {
        setLose();
      }
    }
  }

  void reinitializeLevel() {
    _isMatrixReceived = false;
    _creatorScore = 0;
    _guestScore = 0;
    matrix.clear();
    creatorMoves.clear();
    guestMoves.clear();
    setGameStatus(GameStatus.loading);
  }

  bool checkEndGame() {
    return creatorMoves.length == getSqDim() && guestMoves.length == getSqDim();
  }

  void setWin() {
    Timer(const Duration(seconds: 2), () {
      setGameStatus(GameStatus.win);
      Timer(const Duration(seconds: 2), () {
        reinitializeLevel();
      });
    });
  }

  void setLose() {
    Timer(const Duration(seconds: 2), () {
      setGameStatus(GameStatus.lose);
      Timer(const Duration(seconds: 2), () {
        reinitializeLevel();
      });
    });
  }

}
