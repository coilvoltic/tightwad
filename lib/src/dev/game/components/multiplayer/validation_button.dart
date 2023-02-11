import 'package:flutter/material.dart';
import 'package:tightwad/src/utils/utils.dart';

class ValidationButton extends StatefulWidget {
  const ValidationButton({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData icon;

  @override
  State<ValidationButton> createState() => _ValidationButtonState();
}

class _ValidationButtonState extends State<ValidationButton> {

  bool _isPressedButton = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTapDown: (_) => setState(() {
        _isPressedButton = true;
      }),
      onTapUp: (_) => setState(() {
        _isPressedButton = false;
      }),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
        height: Utils.TEXT_FIELD_HEIGHT,
        width: MediaQuery.of(context).size.width *
            Utils.ROOM_LOOBY_WIDTH_LIMIT_RATIO /
            5,
        decoration: Utils.buildNeumorphismBox(15.0, 5.0, 3.0, _isPressedButton),
        child: Center(
          child: Icon(
            widget.icon,
            size: 25,
            color: widget.icon == Icons.check ? Colors.green : Colors.red,
          )
        ),
      ),
    );
  }
}
