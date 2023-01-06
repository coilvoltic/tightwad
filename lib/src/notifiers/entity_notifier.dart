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
    } else if (entity == Entity.singleplayer) {
      registerTutorialDone(Utils.SINGLEPLAYER_ENTITY_INDEX);
    } else if (entity == Entity.multiplayer) {
      registerTutorialDone(Utils.MULTIPLAYER_ENTITY_INDEX);
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