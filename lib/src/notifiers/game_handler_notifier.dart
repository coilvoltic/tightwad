import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:tightwad/src/utils/coordinates.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/level_handler_factory.dart';
import 'package:tightwad/src/database/database.dart';

class GameHandlerNotifier extends ChangeNotifier {
  GameStatus gameStatus = GameStatus.playing;
  // int lvl = Database.getLevel();
  int lvl = 5;
  bool isNewLvl = false;
  Coordinates algoNextMove = Coordinates(0, 0);

  List<Coordinates> algoMovesList = List.empty(growable: true);
  late List<List<int>> possiblePermutations = [];

  int userScore = 0;
  int algoScore = 0;

  late List<Coordinates> userPossibleMoveList = List.empty(growable: true);
  List<Coordinates> userMoveList = List.empty(growable: true);

  int nbAlgoPress = 0;
  int nbUserPress = 0;

  late bool canUserMove;

  late List<List<int>> matrix = List.empty(growable: true);

  GameHandlerNotifier() {
    computeAllPermutations();
    computeRandomMatrix(
        levels[lvl].getSqNbOfTiles,
        levels[lvl].getMatrixElementMaxValue,
        levels[lvl].getSmallMatrixElementMaxValue);
    canUserMove = levels[lvl].getFirstPlayer == Player.user;
    initializeAlgoMove();
    initializeUserPossibleMoves();
  }

  /* '----------' INITIALIZATION '----------' */
  final player = AudioPlayer();
  void playSound(final String soundPath) async {
    await player.play(AssetSource(soundPath));
  }

  void computeAllPermutations() {
    bool broken = false;
    for (int i = 0;
        i < pow(levels[lvl].getSqNbOfTiles, levels[lvl].getSqNbOfTiles);
        i++) {
      List<int> checkPermutation =
          List.filled(levels[lvl].getSqNbOfTiles, 0, growable: false);
      broken = false;
      for (int j = 0; j < levels[lvl].getSqNbOfTiles; j++) {
        checkPermutation[j] =
            (i / (pow(levels[lvl].getSqNbOfTiles, j)) - 1).floor() %
                    levels[lvl].getSqNbOfTiles +
                1;
        for (int k = 0; k < j; k++) {
          if (checkPermutation[k] == checkPermutation[j]) {
            broken = true;
            break;
          }
        }
        if (broken) {
          break;
        }
      }
      if (!broken) {
        possiblePermutations.add(checkPermutation);
      }
    }
  }

  void initializeAlgoMove() {
    if (levels[lvl].getFirstPlayer == Player.algo) {
      algoTurn();
    }
  }

  void initializeUserPossibleMoves() {
    for (int i = 0; i < levels[lvl].getSqNbOfTiles; i++) {
      for (int j = 0; j < levels[lvl].getSqNbOfTiles; j++) {
        userPossibleMoveList.add(Coordinates(i + 1, j + 1));
      }
    }
  }

  /* '----------' GAME EVENT HANDLING '----------' */
  void registerLevel() async {
    await Database.registerLevel(lvl);
  }

  void reinitializeLevel() async {
    await Database.reinitializeLevel();
  }

  /* '----------' GAME EVENT HANDLING '----------' */
  void registerUserMove(Coordinates move) {
    userMoveList.add(move);
    nbUserPress++;
    canUserMove = false;

    incrementUserScore(move);
    removeMoveFromUser(move);
    updateForbiddenMoveListFromUser(move);
    preventPotentialStuckSituation();
    checkEndGame();

    notifyListeners();
  }

  void incrementUserScore(Coordinates move) {
    userScore = userScore + getMatrixElement(move);
  }

  void removeMoveFromUser(Coordinates move) {
    possiblePermutations
        .removeWhere((element) => element[move.x - 1] == move.y);
  }

  void updateForbiddenMoveListFromUser(Coordinates move) {
    userPossibleMoveList
        .removeWhere((element) => element.x == move.x && element.y == move.y);

    for (int i = 0; i < levels[lvl].getSqNbOfTiles; i++) {
      if (move.x != i + 1) {
        userPossibleMoveList.removeWhere(
            (element) => element.x == i + 1 && element.y == move.y);
      }
    }

    for (int j = 0; j < levels[lvl].getSqNbOfTiles; j++) {
      if (move.y != j + 1) {
        userPossibleMoveList.removeWhere(
            (element) => element.x == move.x && element.y == j + 1);
      }
    }
  }

  void preventPotentialStuckSituation() {
    if (nbUserPress == levels[lvl].getSqNbOfTiles - 2 &&
            levels[lvl].getFirstPlayer == Player.algo ||
        nbAlgoPress == levels[lvl].getSqNbOfTiles - 2 &&
            levels[lvl].getFirstPlayer == Player.user) {
      if (userPossibleMoveList.length == 3) {
        if ((userPossibleMoveList[0].x == userPossibleMoveList[1].x &&
                userPossibleMoveList[0].y == userPossibleMoveList[2].y) ||
            (userPossibleMoveList[0].x == userPossibleMoveList[2].x &&
                userPossibleMoveList[0].y == userPossibleMoveList[1].y)) {
          userPossibleMoveList.removeAt(0);
        } else if ((userPossibleMoveList[1].x == userPossibleMoveList[0].x &&
                userPossibleMoveList[1].y == userPossibleMoveList[2].y) ||
            (userPossibleMoveList[1].x == userPossibleMoveList[2].x &&
                userPossibleMoveList[1].y == userPossibleMoveList[0].y)) {
          userPossibleMoveList.removeAt(1);
        } else if ((userPossibleMoveList[2].x == userPossibleMoveList[0].x &&
                userPossibleMoveList[2].y == userPossibleMoveList[1].y) ||
            (userPossibleMoveList[2].x == userPossibleMoveList[1].x &&
                userPossibleMoveList[2].y == userPossibleMoveList[0].y)) {
          userPossibleMoveList.removeAt(2);
        }
      }
    }
  }

  bool isForbiddenMove(Coordinates move) {
    return !userPossibleMoveList
            .any((item) => item.x == move.x && item.y == move.y) &&
        !userMoveList.any((item) => item.x == move.x && item.y == move.y);
  }

  void algoTurn() {
    if (nbAlgoPress < levels[lvl].getSqNbOfTiles) {
      Timer(const Duration(seconds: 1), () {
        nbAlgoPress++;

        computeAlgoNextMove();
        incrementAlgoScore();
        removeMoveFromAlgo();
        updateUserPossibleMove();
        checkEndGame();
        preventPotentialStuckSituation();

        canUserMove = true;

        notifyListeners();
      });
    }
  }

  void computeAlgoNextMove() {
    int smallestPerumation = 1000;
    int greatestPermutationIndex = 0;

    for (int i = 0; i < possiblePermutations.length; i++) {
      int sum = 0;
      for (int j = 0; j < levels[lvl].getSqNbOfTiles; j++) {
        sum = sum +
            getMatrixElement(
                convertPermElementToCoordinates(possiblePermutations[i][j], j));
      }
      if (sum < smallestPerumation) {
        smallestPerumation = sum;
        greatestPermutationIndex = i;
      }
    }

    List<Coordinates> potentialNextMoves = List.empty(growable: true);
    for (int j = 0; j < levels[lvl].getSqNbOfTiles; j++) {
      Coordinates potentialNextMove = convertPermElementToCoordinates(
          possiblePermutations[greatestPermutationIndex][j], j);
      if (userPossibleMoveList.any((item) =>
              item.x == potentialNextMove.x && item.y == potentialNextMove.y) &&
          !(algoMovesList.any((item) =>
              item.x == potentialNextMove.x &&
              item.y == potentialNextMove.y))) {
        potentialNextMoves.add(potentialNextMove);
      }
    }

    int minScore = 1000;
    if (potentialNextMoves.isNotEmpty) {
      for (final i in potentialNextMoves) {
        if (getMatrixElement(i) < minScore) {
          minScore = getMatrixElement(i);
          algoNextMove = i;
        }
      }
    } else {
      int smallestElementOfPermutation = 1000;
      int greatestElementOfPermutationIndex = 0;
      for (int j = 0; j < levels[lvl].getSqNbOfTiles; j++) {
        Coordinates potentialNextMove = convertPermElementToCoordinates(
            possiblePermutations[greatestPermutationIndex][j], j);
        int elementOfPermutation = getMatrixElement(potentialNextMove);
        if (elementOfPermutation < smallestElementOfPermutation &&
            !(algoMovesList.any((item) =>
                item.x == potentialNextMove.x &&
                item.y == potentialNextMove.y))) {
          smallestElementOfPermutation = elementOfPermutation;
          greatestElementOfPermutationIndex = j;
        }
      }
      algoNextMove = convertPermElementToCoordinates(
          possiblePermutations[greatestPermutationIndex]
              [greatestElementOfPermutationIndex],
          greatestElementOfPermutationIndex);
    }

    algoMovesList.add(algoNextMove);
  }

  void incrementAlgoScore() {
    algoScore = algoScore + getMatrixElement(algoNextMove);
  }

  void removeMoveFromAlgo() {
    possiblePermutations.removeWhere(
        (element) => element[algoNextMove.x - 1] != algoNextMove.y);
  }

  Coordinates convertPermElementToCoordinates(int value, int index) {
    Coordinates computedCoordinates = Coordinates(0, 0);

    computedCoordinates.x = index + 1;
    computedCoordinates.y = value;

    return computedCoordinates;
  }

  void updateUserPossibleMove() {
    userPossibleMoveList.removeWhere((element) =>
        element.x == algoNextMove.x && element.y == algoNextMove.y);
  }

  void checkEndGame() {
    if (nbUserPress == levels[lvl].getSqNbOfTiles &&
        nbAlgoPress == levels[lvl].getSqNbOfTiles) {
      if (userScore < algoScore) {
        setWin();
      } else {
        setLose();
      }
    }
  }

  List<int> computeRow(int sqDim, int stSmallIndex, int ndSmallIndex,
      int matrixElementMaxValue, int smallMatrixElementMaxValue) {
    List<int> vector = List.filled(sqDim, 0, growable: false);
    Random random = Random();

    for (int j = 0; j < sqDim; j++) {
      if (j == stSmallIndex || j == ndSmallIndex) {
        vector[j] = random.nextInt(smallMatrixElementMaxValue) + 1;
        // vector[j] = 2;
      } else {
        vector[j] = random.nextInt(matrixElementMaxValue) + 1;
        // vector[j] = random.nextInt(2) + 1;
      }
    }

    return vector;
  }

  void computeRandomMatrix(
      int sqDim, int matrixElementMaxValue, int smallMatrixElementMaxValue) {
    List<int> stSmall = List.filled(sqDim, 0, growable: false);
    List<int> ndSmall = List.filled(sqDim, 0, growable: false);
    List<int> baseElements = List.empty(growable: true);

    for (int i = 0; i < sqDim; i++) {
      baseElements.add(i + 1);
    }

    for (int i = 0; i < sqDim; i++) {
      Random random = Random();
      int randomNbInSqDim = 0;
      randomNbInSqDim = random.nextInt(baseElements.length);
      if (i == sqDim - 1 - 1 &&
          baseElements.any((element) => element == sqDim)) {
        int indexOfGreatestBaseElement = baseElements.indexOf(sqDim);
        stSmall[i] = baseElements[indexOfGreatestBaseElement];
        baseElements[indexOfGreatestBaseElement] = 0;
      } else {
        while (randomNbInSqDim == i || baseElements[randomNbInSqDim] == 0) {
          randomNbInSqDim = random.nextInt(baseElements.length);
        }
        stSmall[i] = baseElements[randomNbInSqDim];
        baseElements[randomNbInSqDim] = 0;
      }
    }

    for (int i = 0; i < sqDim; i++) {
      ndSmall[i] = stSmall[stSmall[i] - 1];
    }

    for (int i = 0; i < sqDim; i++) {
      matrix.add(computeRow(sqDim, stSmall[i] - 1, ndSmall[i] - 1,
          matrixElementMaxValue, smallMatrixElementMaxValue));
    }
  }

  int getMatrixElement(Coordinates move) {
    return matrix.elementAt(move.x - 1).elementAt(move.y - 1);
  }

  /* '----------' GAME STATES '----------' */

  void setIsPlaying() {
    if (gameStatus == GameStatus.finish) {
      lvl = 0;
    } else if (isNewLvl) {
      lvl++;
      registerLevel();

      isNewLvl = false;
    }
    resetLevel();
    gameStatus = GameStatus.playing;
    notifyListeners();
  }

  void setWin() {
    isNewLvl = true;
    Timer(const Duration(seconds: 1), () {
      if (Database.getSoundSettingOn()) {
        playSound('wow.wav');
      }
      gameStatus = GameStatus.win;
      notifyListeners();
      Timer(const Duration(seconds: 1), () {
        if (lvl == 24) {
          gameStatus = GameStatus.finish;
          reinitializeLevel();
        } else {
          gameStatus = GameStatus.nextlevel;
        }
        notifyListeners();
      });
    });
  }

  void setLose() {
    Timer(const Duration(seconds: 1), () {
      if (Database.getSoundSettingOn()) {
        playSound('lose.wav');
      }
      gameStatus = GameStatus.lose;
      notifyListeners();
      Timer(const Duration(seconds: 1), () {
        gameStatus = GameStatus.tryagain;
        notifyListeners();
      });
    });
  }

  void resetLevel() {
    algoNextMove = Coordinates(0, 0);

    algoMovesList.clear();
    possiblePermutations.clear();
    userPossibleMoveList.clear();
    userMoveList.clear();
    matrix.clear();

    nbAlgoPress = 0;
    nbUserPress = 0;
    userScore = 0;
    algoScore = 0;

    canUserMove = levels[lvl].getFirstPlayer == Player.user;

    initializeUserPossibleMoves();
    computeAllPermutations();
    computeRandomMatrix(
        levels[lvl].getSqNbOfTiles,
        levels[lvl].getMatrixElementMaxValue,
        levels[lvl].getSmallMatrixElementMaxValue);
    initializeAlgoMove();
  }

  /* '----------' GETTERS '----------' */

  GameStatus get getGameStatus => gameStatus;
  int get getSqNbOfTiles => levels[lvl].getSqNbOfTiles;
  int get getLvl => lvl + 1;
  Coordinates get getAlgoPress => algoNextMove;
  int get getUserScore => userScore;
  int get getAlgoScore => algoScore;
  bool get getCanUserMove => canUserMove;
}
