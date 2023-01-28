import 'dart:math';

import 'package:tightwad/src/utils/coordinates.dart';

abstract class GameUtils {

  // ignore: constant_identifier_names
  static const int MULTIPLAYER_SQ_DIM_MIN = 3;
  // ignore: constant_identifier_names
  static const int MULTIPLAYER_SQ_DIM_MAX = 8;

  static List<int> computeRow(int sqDim, int stSmallIndex, int ndSmallIndex,
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

  static List<List<int>> computeRandomMatrix(int sqDim, { int matrixElementMaxValue = 50, int smallMatrixElementMaxValue = 5 }) {

    List<List<int>> matrix = List.empty(growable: true);

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

    return matrix;

  }

  static bool areCoordinatesEqual(final Coordinates coord1, final Coordinates coord2) {
    return coord1.x == coord2.x && coord1.y == coord2.y;
  }

}