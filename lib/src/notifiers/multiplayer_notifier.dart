import 'dart:math';

import 'package:flutter/material.dart';

class MultiplayerNotifier extends ChangeNotifier {

  static String roomId = '';

  static void generateRoomId() {
    final Random random = Random();
    roomId = random.nextInt(999999).toString();
  }

}