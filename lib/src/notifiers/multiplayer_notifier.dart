import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
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
  static bool shouldSessionBeInitialized = false;

  List<List<int>>   matrix                = List.empty(growable: true);
  List<Coordinates> guestMoves            = List.empty(growable: true);
  List<Coordinates> creatorMoves          = List.empty(growable: true);
  List<Coordinates> _guestPossibleMoves   = List.empty(growable: true);
  List<Coordinates> _creatorPossibleMoves = List.empty(growable: true);
  List<RoundStatus> guestRoundStatus      = List.empty(growable: true);
  List<RoundStatus> creatorRoundStatus    = List.empty(growable: true);

  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listener;

  bool   _isMatrixReceived      = false;
  bool   _isListening           = false;
  int    _creatorScore          = 0;
  int    _guestScore            = 0;
  int    _nbOfRounds            = 0;
  int    _currentRound          = 1;
  String _creatorName           = '';
  String _guestName             = '';
  Player turn                   = Player.creator;

  GameStatus        get getGameStatus          => _gameStatus;
  Player            get getTurn                => turn;
  int               get getCreatorScore        => _creatorScore;
  int               get getGuestScore          => _guestScore;
  int               get getCurrentRound        => _currentRound;
  int               get getNbOfRounds          => _nbOfRounds;
  String            get getCreatorName         => _creatorName;
  String            get getGuestName           => _guestName;
  List<RoundStatus> get getCreatorRoundStatus  => creatorRoundStatus;
  List<RoundStatus> get getGuestRoundStatus    => guestRoundStatus;

  final player = AudioPlayer();
  void playSound(final String soundPath) async {
    await player.play(AssetSource(soundPath));
  }

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

  Future<void> initializeSession() async {
    shouldSessionBeInitialized = false;
    _currentRound = 1;
    creatorRoundStatus.clear();
    guestRoundStatus.clear();
    turn = Player.creator;
    initializeData();
    await fetchUsefulSessionData();
  }

  Future<void> initializeGame() async {
    if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.creator) {
      await createAndPushMatrix();
    } else if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.guest) {
      await waitForMatrixAndStoreIt();
    }
  }

  Future<void> fetchUsefulSessionData() async {
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
            creatorRoundStatus.add(RoundStatus.none);
            guestRoundStatus.add(RoundStatus.none);
          }
        }).timeout(const Duration(seconds: Utils.REQUEST_TIME_OUT), onTimeout: () {
          setError();
        }).onError((_, __) {
          setError();
        });
  }

  void generateMatrix() {
    final Random random = Random();
    final int sqDim = random.nextInt(GameUtils.MULTIPLAYER_SQ_DIM_MAX - GameUtils.MULTIPLAYER_SQ_DIM_MIN) + GameUtils.MULTIPLAYER_SQ_DIM_MIN;
    matrix = GameUtils.computeRandomMatrix(sqDim);
  }

  Future<void> createAndPushMatrix() async {
    generateMatrix();
    _creatorPossibleMoves = GameUtils.fillAllMoves(getSqDim());
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .update({
        'matrix': jsonEncode(matrix),
      }).whenComplete(() => {
        setGameStatus(GameStatus.playing),
      }).timeout(const Duration(seconds: Utils.REQUEST_TIME_OUT), onTimeout: () {
        setError();
      }).onError((error, stackTrace) => {
        setError(),
      });
  }

  Future<void> waitForMatrixAndStoreIt() async {
    while (!_isMatrixReceived) {
      await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .get()
        .then((doc) {
          if (doc.exists && doc.data()?.containsKey('matrix') == true && doc.get('matrix') != '') {
            jsonDecode(doc.get('matrix')).forEach((row) => {
              matrix.add(row.cast<int>()),
            });
            _isMatrixReceived = true;
            _guestPossibleMoves = GameUtils.fillAllMoves(getSqDim());
            setGameStatus(GameStatus.playing);
          }
        }).timeout(const Duration(seconds: Utils.REQUEST_TIME_OUT), onTimeout: () {
          setError();
        }).onError((errorObj, stackTrace) {
          setError();
        });
      await Future.delayed(const Duration(seconds: 1));
    }
    await FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}')
      .update({
        'matrix': '',
        'matrix_backup': jsonEncode(matrix),
      });
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

  Future<void> notifyCreatorNewMove(final Coordinates move) async {
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
      }).timeout(const Duration(seconds: Utils.REQUEST_TIME_OUT), onTimeout: () {
        setError();
      }).onError((error, stackTrace) => {
        setError(),
      });
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

  Future<void> notifyGuestNewMove(final Coordinates move) async {
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
      }).timeout(const Duration(seconds: Utils.REQUEST_TIME_OUT), onTimeout: () {
        setError();
      }).onError((error, stackTrace) => {
        setError(),
      });
  }

  Future<void> listenToGuestMove() async {
    if (!_isListening) {
      _isListening = true;
      listener =  FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}').snapshots().listen((event) async => {
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
      });
    }
  }

  Future<void> listenToCreatorMove() async {
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
      });
    }
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
        creatorRoundStatus[_currentRound - 1] = RoundStatus.won;
        setWin();
      } else if (_creatorScore > _guestScore) {
        creatorRoundStatus[_currentRound - 1] = RoundStatus.lost;
        setLose();
      } else {
        creatorRoundStatus[_currentRound - 1] = RoundStatus.draw;
        setDraw();
      }
    } else if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.guest) {
      if (_guestScore < _creatorScore) {
        guestRoundStatus[_currentRound - 1] = RoundStatus.won;
        setWin();
      } else if (_guestScore > _creatorScore) {
        guestRoundStatus[_currentRound - 1] = RoundStatus.lost;
        setLose();
      } else {
        guestRoundStatus[_currentRound - 1] = RoundStatus.draw;
        setDraw();
      }
    }
  }

  void initializeData() {
    _isMatrixReceived = false;
    _isListening = false;
    _creatorScore = 0;
    _guestScore = 0;
    matrix.clear();
    creatorMoves.clear();
    guestMoves.clear();
  }

  void leaveSession() {
    if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.creator) {
      computeSessionStatus(creatorRoundStatus);
    } else if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.guest) {
      computeSessionStatus(guestRoundStatus);
    }
  }

  void computeSessionStatus(final List<RoundStatus> rounds) {
    int nbOfWins = 0;
    int nbOfLosses = 0;
    for (final RoundStatus round in rounds) {
      if (round == RoundStatus.won) {
        nbOfWins++;
      } else if (round == RoundStatus.lost) {
        nbOfLosses++;
      }
    }
    if (nbOfWins > nbOfLosses) {
      if (Database.getSoundSettingOn()) {
        playSound('victory.mp3');
      }
      setGameStatus(GameStatus.winsession);
      Timer(const Duration(seconds: 2), () {
        setGameStatus(GameStatus.leavewon);
      });
    } else {
      if (nbOfWins < nbOfLosses) {
        if (Database.getSoundSettingOn()) {
          playSound('defeat.mp3');
        }
        setGameStatus(GameStatus.losesession);
      } else {
        setGameStatus(GameStatus.drawsession);
      }
      Timer(const Duration(seconds: 2), () {
        setGameStatus(GameStatus.leavelostordraw);
      });
    }

  }

  bool isEndGame() {
    return creatorMoves.length == getSqDim() && guestMoves.length == getSqDim();
  }

  void setWin() {
    Timer(const Duration(seconds: 2), () {
      if (Database.getSoundSettingOn()) {
        playSound('wow.wav');
      }
      setGameStatus(GameStatus.win);
      Timer(const Duration(seconds: 3), () {
        checkEndSession();
      });
    });
  }

  void setLose() {
    Timer(const Duration(seconds: 2), () {
      if (Database.getSoundSettingOn()) {
        playSound('lose.wav');
      }
      setGameStatus(GameStatus.lose);
      Timer(const Duration(seconds: 3), () {
        checkEndSession();
      });
    });
  }

  void setDraw() {
    Timer(const Duration(seconds: 2), () {
      setGameStatus(GameStatus.draw);
      Timer(const Duration(seconds: 3), () {
        checkEndSession();
      });
    });
  }

  void setError() {
    if (Database.getSoundSettingOn()) {
      playSound('lose.wav');
    }
    setGameStatus(GameStatus.error);
    Timer(const Duration(seconds: 2), () {
      setGameStatus(GameStatus.retry);
    });
  }

  void checkEndSession() {
    if (_currentRound == _nbOfRounds) {
      leaveSession();
    } else {
      initializeData();
      _currentRound++;
      setGameStatus(GameStatus.loading);
    }
  }

}
