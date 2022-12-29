import 'package:tightwad/src/utils/common_enums.dart';

class LevelTemplate
{
  late int    _sqNbOfTiles;
  late Player _firstPlayer;
  late int    _matrixElementMaxValue;
  late int    _smallMatrixElementMaxValue;

  LevelTemplate(int    sqNbOfTiles,
                Player firstPlayer,
                int    matrixElementMaxValue,
                int    smallMatrixElementMaxValue)
  {
    _sqNbOfTiles                = sqNbOfTiles;
    _firstPlayer                = firstPlayer;
    _matrixElementMaxValue      = matrixElementMaxValue;
    _smallMatrixElementMaxValue = smallMatrixElementMaxValue;
  }

  int    get getSqNbOfTiles                => _sqNbOfTiles;
  Player get getFirstPlayer                => _firstPlayer;
  int    get getMatrixElementMaxValue      => _matrixElementMaxValue;
  int    get getSmallMatrixElementMaxValue => _smallMatrixElementMaxValue;
}