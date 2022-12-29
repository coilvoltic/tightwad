import 'package:flutter/material.dart';

import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/utils/common_enums.dart';

class EntityNotifier extends ChangeNotifier {

  Entity entity = Entity.tutorial;
  TutorialPhase tutoPhase = TutorialPhase.welcome;

  void registerTutorialDone() async {
    await Database.registerTutorialDone();
  }

  void setTutorialDone()
  {
    registerTutorialDone();
    notifyListeners();
  }

  void changeTutorialPhase()
  {
    if (tutoPhase == TutorialPhase.welcome)
    {
      tutoPhase = TutorialPhase.learning;
    }
    notifyListeners();
  }

  Entity get getEntity => entity;
  TutorialPhase get getTutoPhase => tutoPhase;

}