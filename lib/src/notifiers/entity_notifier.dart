import 'package:flutter/material.dart';

import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/utils.dart';

class EntityNotifier extends ChangeNotifier {

  Entity entity = Entity.tutorial;
  TutorialPhase tutoPhase = TutorialPhase.welcome;
  bool _isModeChanging = false;

  void registerTutorialDone(int newGameEntity) async {
    await Database.registerTutorialDone(newGameEntity);
  }

  void changeGameEntity(Entity newGameEntity) {
    entity = newGameEntity;
    if (entity == Entity.tutorial) {
      registerTutorialDone(Utils.TUTORIAL_ENTITY_INDEX);
    } else if (entity == Entity.singleplayergame) {
      registerTutorialDone(Utils.SINGLEPLAYERGAME_ENTITY_INDEX);
    } else if (entity == Entity.multiplayergame) {
      registerTutorialDone(Utils.MULTIPLAYERGAME_ENTITY_INDEX);
    } else if (entity == Entity.singleplayerwelcome) {
      registerTutorialDone(Utils.SINGLEPLAYERWELCOME_ENTITY_INDEX);
    } else if (entity == Entity.multiplayerwelcome) {
      registerTutorialDone(Utils.MULTIPLAYERWELCOME_ENTITY_INDEX);
    }
    notifyListeners();
  }

  void setTutorialDone() {
    notifyListeners();
  }

  void changeTutorialPhase() {
    if (tutoPhase == TutorialPhase.welcome) {
      tutoPhase = TutorialPhase.learning;
    }
    notifyListeners();
  }

  void updateModeChanging() {
    _isModeChanging = !_isModeChanging;
    notifyListeners();
  }

  bool get getIsModeChanging => _isModeChanging;
  Entity get getEntity => entity;
  TutorialPhase get getTutoPhase => tutoPhase;

}
