import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tightwad/src/database/database.dart';

class MultiplayerNotifier extends ChangeNotifier {

  static void generateAndSetRoomId() async {
    final Random random = Random();
    final String roomId = random.nextInt(999999).toString();
    setRoomId(roomId);
  }

  static void setRoomId(String roomId) async {
    await Database.registerRoomId(roomId);
  }

}