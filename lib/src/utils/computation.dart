import 'package:tightwad/src/utils/coordinates.dart';

/// input: 11 (index), 5 (square of matrix dimension)
/// output: x : 1, y : 3
Coordinates indexToCoordinates(int index, int sqNbOfTiles) {
  Coordinates computedCoordinates = Coordinates(0, 0);

  computedCoordinates.x = 1 + index %  sqNbOfTiles;
  computedCoordinates.y = 1 + index ~/ sqNbOfTiles;

  return computedCoordinates;
}