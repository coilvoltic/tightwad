import 'package:flutter/material.dart';
import 'package:tightwad/src/utils/utils.dart';

class RoomLobby extends StatelessWidget {
  const RoomLobby({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('KL rebuilttt');
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 50,
          width: 400,
          decoration: Utils.buildNeumorphismBox(50.0, 2.0, 5.0, true),
        ),
      ),
    );
  }
}