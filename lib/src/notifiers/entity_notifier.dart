import 'package:flutter/material.dart';

import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/utils.dart';

class EntityNotifier extends ChangeNotifier {

  Entity entity = Entity.tutorial;
  TutorialPhase tutoPhase = TutorialPhase.welcome;
  bool _isModeChanging = false;

  void registerGameEntity(int newGameEntity) async {
    await Database.registerGameEntity(newGameEntity);
  }

  void changeGameEntity(Entity newGameEntity) {
    entity = newGameEntity;
    if (entity == Entity.tutorial) {
      registerGameEntity(Utils.TUTORIAL_ENTITY_INDEX);
    } else if (entity == Entity.singleplayergame) {
      registerGameEntity(Utils.SINGLEPLAYERGAME_ENTITY_INDEX);
    } else if (entity == Entity.lobby) {
      registerGameEntity(Utils.LOBBY_ENTITY_INDEX);
    } else if (entity == Entity.singleplayerwelcome) {
      registerGameEntity(Utils.SINGLEPLAYERWELCOME_ENTITY_INDEX);
    } else if (entity == Entity.multiplayerwelcome) {
      registerGameEntity(Utils.MULTIPLAYERWELCOME_ENTITY_INDEX);
    } else if (entity == Entity.multiplayergame) {
      registerGameEntity(Utils.MULTIPLAYERGAME_ENTITY_INDEX);
    } else if (entity == Entity.waitingopponent) {
      registerGameEntity(Utils.WAITINGOPPONENT_ENTITY_INDEX);
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
