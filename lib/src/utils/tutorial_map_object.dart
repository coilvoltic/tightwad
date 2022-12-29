import 'dart:math';
import 'package:tightwad/src/utils/coordinates.dart';

final List<List<int>> matrix = [[ 5,  9,  7,  4],
                                [ 3,  8,  7,  1],
                                [ 6,  4,  4,  9],
                                [ 3, 14, 12, 11]];

const int tutorialSqNbOfTiles = 4;

const List<int> mapObjectsDelay = [1000, 1500, 2000, 2500];

int getMatrixElement(Coordinates coordinates)
{
  return matrix.elementAt(coordinates.x - 1).elementAt(coordinates.y - 1);
}

class TutorialMapObjectTemplate
{
  TutorialMapObjectTemplate(this.userTiles,
                            this.algoTiles,
                            this.forbiddenTiles,);

  List<Coordinates> userTiles;
  List<Coordinates> algoTiles;
  List<Coordinates> forbiddenTiles;
}

TutorialMapObjectTemplate buildMapObject(List<Coordinates> user,
                                         List<Coordinates> algo,
                                         List<Coordinates> forbidden)
{
  return TutorialMapObjectTemplate(user, algo, forbidden);
}

List<Coordinates> computeForbiddenList(List<Coordinates> coordinatesList)
{
  List<Coordinates> forbiddenList = List.empty(growable: true);

  for (int k = 0; k < coordinatesList.length; k++)
  {
    for (int i = 0; i < tutorialSqNbOfTiles; i++)
    {
      if (i+1 != coordinatesList[k].x)
      {
        forbiddenList.add(Coordinates(i+1, coordinatesList[k].y));
      }
    }

    for (int j = 0; j < tutorialSqNbOfTiles; j++)
    {
      if (j+1 != coordinatesList[k].y)
      {
        forbiddenList.add(Coordinates(coordinatesList[k].x, j+1));
      }
    }    
  }

  return forbiddenList;
}

List<Coordinates> computeAllMatrixCoordinates()
{
  List<Coordinates> userTiles = List.filled(pow(tutorialSqNbOfTiles,2).toInt(), Coordinates(0,0), growable: false);

  for (int i = 0; i < tutorialSqNbOfTiles; i++)
  {
    for (int j = 0; j < tutorialSqNbOfTiles; j++)
    {
      userTiles[i*tutorialSqNbOfTiles+j] = Coordinates(i+1,j+1);
    }
  }
  return userTiles;
}

List<TutorialMapObjectTemplate> firstPage = [buildMapObject([],[],[]),
                                             buildMapObject([],[],[]),
                                             buildMapObject([Coordinates(3,2)], [], []),
                                             buildMapObject([Coordinates(1,4)], [], []),
                                             buildMapObject([Coordinates(3,1)], [], []),
                                             buildMapObject([Coordinates(4,3)], [], []),
                                             buildMapObject([Coordinates(2,2)], [], []),
                                             buildMapObject([Coordinates(3,4)], [], []),
                                             buildMapObject([Coordinates(2,3)], [], []),
                                             buildMapObject([Coordinates(4,1)], [], []),
                                             buildMapObject([Coordinates(1,1)], [], []),
                                             buildMapObject([Coordinates(3,3)], [], []),
                                             buildMapObject([Coordinates(1,2)], [], []),
                                             buildMapObject([Coordinates(2,1)], [], []),
                                             buildMapObject([Coordinates(4,4)], [], []),
                                             buildMapObject([Coordinates(1,3)], [], []),
                                             buildMapObject([Coordinates(2,4)], [], []),
                                             buildMapObject([Coordinates(4,2)], [], [])];

List<TutorialMapObjectTemplate> secondPage = [buildMapObject([],[],[]),
                                              buildMapObject([Coordinates(3,2)], [], computeForbiddenList([Coordinates(3,2)])),
                                              buildMapObject([Coordinates(1,4)], [], computeForbiddenList([Coordinates(1,4)])),
                                              buildMapObject([Coordinates(3,1)], [], computeForbiddenList([Coordinates(3,1)])),
                                              buildMapObject([Coordinates(4,3)], [], computeForbiddenList([Coordinates(4,3)])),
                                              buildMapObject([Coordinates(2,2)], [], computeForbiddenList([Coordinates(2,2)])),
                                              buildMapObject([Coordinates(3,4)], [], computeForbiddenList([Coordinates(3,4)])),
                                              buildMapObject([Coordinates(2,3)], [], computeForbiddenList([Coordinates(2,3)])),
                                              buildMapObject([Coordinates(4,1)], [], computeForbiddenList([Coordinates(4,1)])),
                                              buildMapObject([Coordinates(1,1)], [], computeForbiddenList([Coordinates(1,1)])),
                                              buildMapObject([Coordinates(3,3)], [], computeForbiddenList([Coordinates(3,3)])),
                                              buildMapObject([Coordinates(1,2)], [], computeForbiddenList([Coordinates(1,2)])),
                                              buildMapObject([Coordinates(2,1)], [], computeForbiddenList([Coordinates(2,1)])),
                                              buildMapObject([Coordinates(4,4)], [], computeForbiddenList([Coordinates(4,4)])),
                                              buildMapObject([Coordinates(1,3)], [], computeForbiddenList([Coordinates(1,3)])),
                                              buildMapObject([Coordinates(2,4)], [], computeForbiddenList([Coordinates(2,4)])),
                                              buildMapObject([Coordinates(4,2)], [], computeForbiddenList([Coordinates(4,2)]))];

List<TutorialMapObjectTemplate> thirdPage = [buildMapObject([],[],[]),
                                             buildMapObject([Coordinates(4,1),
                                                             Coordinates(3,2),
                                                             Coordinates(2,3),
                                                             Coordinates(1,4),
                                                             ], [], computeAllMatrixCoordinates()),
                                            buildMapObject([Coordinates(1,1),
                                                            Coordinates(3,2),
                                                            Coordinates(4,3),
                                                            Coordinates(2,4),
                                                            ], [], computeAllMatrixCoordinates()),
                                            buildMapObject([Coordinates(2,1),
                                                            Coordinates(4,2),
                                                            Coordinates(3,3),
                                                            Coordinates(1,4),
                                                            ], [], computeAllMatrixCoordinates()),
                                            buildMapObject([Coordinates(3,1),
                                                            Coordinates(1,2),
                                                            Coordinates(2,3),
                                                            Coordinates(4,4),
                                                            ], [], computeAllMatrixCoordinates())];

List<TutorialMapObjectTemplate> fourthPage = [buildMapObject([],[],[]),
                                              buildMapObject([Coordinates(2,4)],
                                                             [],
                                                             computeForbiddenList([Coordinates(2,4)])),
                                              buildMapObject([Coordinates(2,4)],
                                                             [Coordinates(1,1)],
                                                             computeForbiddenList([Coordinates(2,4)])),
                                              buildMapObject([Coordinates(2,4),
                                                              Coordinates(4,1)],
                                                             [Coordinates(1,1)],
                                                             computeForbiddenList([Coordinates(2,4),
                                                                                   Coordinates(4,1)])),
                                              buildMapObject([Coordinates(2,4),
                                                              Coordinates(4,1)],
                                                             [Coordinates(1,1),
                                                              Coordinates(3,3)],
                                                             computeForbiddenList([Coordinates(2,4),
                                                                                   Coordinates(4,1)])),
                                              buildMapObject([Coordinates(2,4),
                                                              Coordinates(4,1),
                                                              Coordinates(1,3)],
                                                             [Coordinates(1,1),
                                                              Coordinates(3,3)],
                                                             computeForbiddenList([Coordinates(2,4),
                                                                                   Coordinates(4,1),
                                                                                   Coordinates(1,3)])),
                                              buildMapObject([Coordinates(2,4),
                                                              Coordinates(4,1),
                                                              Coordinates(1,3)],
                                                             [Coordinates(1,1),
                                                              Coordinates(3,3),
                                                              Coordinates(2,2)],
                                                             computeForbiddenList([Coordinates(2,4),
                                                                                   Coordinates(4,1),
                                                                                   Coordinates(1,3)])),
                                              buildMapObject([Coordinates(2,4),
                                                              Coordinates(4,1),
                                                              Coordinates(1,3),
                                                              Coordinates(3,2)],
                                                             [Coordinates(1,1),
                                                              Coordinates(3,3),
                                                              Coordinates(2,2)],
                                                             computeForbiddenList([Coordinates(2,4),
                                                                                   Coordinates(4,1),
                                                                                   Coordinates(1,3),
                                                                                   Coordinates(3,2)])),
                                              buildMapObject([Coordinates(2,4),
                                                              Coordinates(4,1),
                                                              Coordinates(1,3),
                                                              Coordinates(3,2)],
                                                             [Coordinates(1,1),
                                                              Coordinates(3,3),
                                                              Coordinates(2,2),
                                                              Coordinates(4,4)],
                                                             computeForbiddenList([Coordinates(2,4),
                                                                                   Coordinates(4,1),
                                                                                   Coordinates(1,3),
                                                                                   Coordinates(3,2)]))];

List<List<TutorialMapObjectTemplate>> pages = [firstPage,
                                               secondPage,
                                               thirdPage,
                                               fourthPage];

