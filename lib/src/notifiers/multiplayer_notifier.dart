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
  static bool isSessionInitialized = false;

  List<List<int>> matrix = List.empty(growable: true);
  List<Coordinates> guestMoves = List.empty(growable: true);
  List<Coordinates> creatorMoves = List.empty(growable: true);
  List<Coordinates> _guestPossibleMoves = List.empty(growable: true);
  List<Coordinates> _creatorPossibleMoves = List.empty(growable: true);
  List<RoundStatus> _guestRoundStatus = List.empty(growable: true);
  List<RoundStatus> _creatorRoundStatus = List.empty(growable: true);

  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listener;

  bool _isMatrixBeingCreated = false;
  bool _isMatrixReceived = false;
  bool _isFetchingData = false;
  bool _isListening = false;
  int  _creatorScore = 0;
  int  _guestScore = 0;
  String _creatorName = '';
  String _guestName = '';
  Player turn = Player.creator;
  int _nbOfRounds = 0;
  int _currentRound = 1;

  GameStatus get getGameStatus => _gameStatus;
  Player get getTurn => turn;
  int get getCreatorScore => _creatorScore;
  int get getGuestScore => _guestScore;
  String get getCreatorName => _creatorName;
  String get getGuestName => _guestName;
  List<RoundStatus> get getCreatorRoundStatus => _creatorRoundStatus;
  List<RoundStatus> get getGuestRoundStatus => _guestRoundStatus;
  int get getCurrentRound => _currentRound;
  int get getNbOfRounds => _nbOfRounds;

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

  int getNbOfCreatorPress() {
    return creatorMoves.length;
  }

  int getNbOfGuestPress() {
    return guestMoves.length;
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

  Future<bool> initializeSession() async {
    bool isSuccessful = true;
    isSessionInitialized = true;
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .get()
        .then((doc) {
          if (doc.exists &&
              doc.data()?.containsKey('guestName') != null &&
              doc.data()?.containsKey('creatorName') != null &&
              doc.data()?.containsKey('nbOfRounds') != null) {
            _creatorName = doc.get('creatorName');
            _guestName = doc.get('guestName');
            _nbOfRounds = doc.get('nbOfRounds');
          }
          for (int i = 0; i < _nbOfRounds; i++) {
            _creatorRoundStatus.add(RoundStatus.none);
            _guestRoundStatus.add(RoundStatus.none);
          }
        }).timeout(const Duration(seconds: Utils.REQUEST_TIME_OUT), onTimeout: () {
        }).onError((errorObj, stackTrace) {
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
      _creatorPossibleMoves = GameUtils.fillAllMoves(getSqDim());
      await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
        .update({
          'matrix': jsonEncode(matrix),
        }).whenComplete(() => {
          _isMatrixBeingCreated = false,
          setGameStatus(GameStatus.playing),
        }).onError((error, stackTrace) => {
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
    while (!_isMatrixReceived) {
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
        }).onError((errorObj, stackTrace) {
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
    if (isEndGame()) {
      notifyListeners();
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
    bool isSuccessful = true;
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .update({
        'creatorLastMove': {
          'x': move.x,
          'y': move.y,
        },
        'guestLastMove': '',
      }).whenComplete(() => {
        if (!isEndGame()) {
          turn = Player.guest,
          notifyListeners(),
        },
      }).onError((error, stackTrace) => {
      });
    return isSuccessful;
  }

  void updateLocalGuestTiles(final Coordinates move) {
    _guestScore += matrix.elementAt(move.x - 1).elementAt(move.y - 1);
    guestMoves.add(move);
    if (isEndGame()) {
      notifyListeners();
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
    bool isSuccessful = true;
    GameUtils.updatePossibleMoves(_guestPossibleMoves, move, getSqDim());
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .update({
        'guestLastMove': {
          'x': move.x,
          'y': move.y,
        },
        'creatorLastMove': '',
      }).whenComplete(() => {
        if (!isEndGame()) {
          turn = Player.creator,
          notifyListeners(),
        },
      }).onError((error, stackTrace) => {
      });
    return isSuccessful;
  }

  Future<bool> listenToGuestMove() async {
    if (!_isListening) {
      print('listening...');
      _isListening = true;
      listener =  FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}').snapshots().listen((event) async => {
          print('got event!...'),
          if (event.exists && event.data()!.containsKey('guestLastMove') && event.get('guestLastMove') != '') {
            guestMoves.add(Coordinates(event.get(FieldPath(const ['guestLastMove', 'x'])), event.get(FieldPath(const ['guestLastMove', 'y'])))),
            listener.cancel(),
            _guestScore += matrix.elementAt(guestMoves.last.x - 1).elementAt(guestMoves.last.y - 1),
            if (isEndGame()) {
              notifyListeners(),
              endGame(),
              await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
              .update({
                'guestLastMove': '',
              }),
            } else {
              turn = Player.creator,
              _creatorPossibleMoves.removeWhere((element) =>
                element.x == getGuestLastMove().x && element.y == getGuestLastMove().y),
              if (creatorMoves.length == getSqDim() - 2) {
                GameUtils.preventPotentialStuckSituation(_creatorPossibleMoves),
              },
              _isListening = false,
              notifyListeners(),
            },
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
            listener.cancel(),
            _creatorScore += matrix.elementAt(creatorMoves.last.x - 1).elementAt(creatorMoves.last.y - 1),
            if (isEndGame()) {
              notifyListeners(),
              endGame(),
              await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
              .update({
                'creatorLastMove': '',
              }),
            } else {
              turn = Player.guest,
              _guestPossibleMoves.removeWhere((element) =>
                element.x == getCreatorLastMove().x && element.y == getCreatorLastMove().y),
              if (guestMoves.length == getSqDim() - 2) {
                GameUtils.preventPotentialStuckSituation(_guestPossibleMoves),
              },
              _isListening = false,
              notifyListeners(),
            },
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

  void endGame() async {
    if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.creator) {
      if (_creatorScore < _guestScore) {
        _creatorRoundStatus[_currentRound - 1] = RoundStatus.won;
        setWin();
      } else if (_creatorScore > _guestScore) {
        _creatorRoundStatus[_currentRound - 1] = RoundStatus.lost;
        setLose();
      } else {
        _creatorRoundStatus[_currentRound - 1] = RoundStatus.draw;
        setDraw();
      }
    } else if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.guest) {
      if (_guestScore < _creatorScore) {
        _guestRoundStatus[_currentRound - 1] = RoundStatus.won;
        setWin();
      } else if (_guestScore > _creatorScore) {
        _guestRoundStatus[_currentRound - 1] = RoundStatus.lost;
        setLose();
      } else {
        _guestRoundStatus[_currentRound - 1] = RoundStatus.draw;
        setDraw();
      }
    }
  }

  void reinitializeLevel() {
    _isMatrixReceived = false;
    _isMatrixBeingCreated = false;
    _isListening = false;
    _creatorScore = 0;
    _guestScore = 0;
    matrix.clear();
    creatorMoves.clear();
    guestMoves.clear();
    _currentRound++;
    setGameStatus(GameStatus.loading);
  }

  void clearAndLeaveSession() {
    // setGameStatus(GameStatus.finish);
  }

  bool isEndGame() {
    return creatorMoves.length == getSqDim() && guestMoves.length == getSqDim();
  }

  void setWin() {
    Timer(const Duration(seconds: 2), () {
      setGameStatus(GameStatus.win);
      Timer(const Duration(seconds: 2), () {
        checkEndSession();
      });
    });
  }

  void setLose() {
    Timer(const Duration(seconds: 2), () {
      setGameStatus(GameStatus.lose);
      Timer(const Duration(seconds: 2), () {
        checkEndSession();
      });
    });
  }

  void setDraw() {
    Timer(const Duration(seconds: 2), () {
      setGameStatus(GameStatus.draw);
      Timer(const Duration(seconds: 2), () {
        checkEndSession();
      });
    });
  }

  void checkEndSession() {
    if (_currentRound == _nbOfRounds) {
      clearAndLeaveSession();
    } else {
      reinitializeLevel();
    }
  }

}
