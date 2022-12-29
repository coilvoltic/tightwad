import 'package:tightwad/src/utils/coordinates.dart';

Coordinates indexToCoordinates(int index, int sqNbOfTiles)
{
  Coordinates computedCoordinates = Coordinates(0, 0);

  computedCoordinates.x = 1 + index %  sqNbOfTiles;
  computedCoordinates.y = 1 + index ~/ sqNbOfTiles;

  return computedCoordinates;
}