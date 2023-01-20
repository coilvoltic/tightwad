import 'package:flutter/material.dart';
import 'package:tightwad/src/utils/utils.dart';

class ValidationButton extends StatefulWidget {
  const ValidationButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;

  @override
  State<ValidationButton> createState() => _ValidationButtonState();
}

class _ValidationButtonState extends State<ValidationButton> {

  bool _isPressedButton = false;
  bool _isReversed = false;

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
            2,
        decoration: Utils.buildNeumorphismBox(25.0, 5.0, 5.0, _isPressedButton),
        child: Center(
          child: TweenAnimationBuilder<double>(
            onEnd: () => setState(() {
              _isReversed = !_isReversed;
            }),
            duration: const Duration(milliseconds: 300),
            tween: Tween<double>(begin: 0.0, end: _isReversed ? -2.5 : 2.5),
            builder: (context, double statementPosition, _) {
              return Transform.translate(
                offset: Offset(0.0, statementPosition),
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    decoration: TextDecoration.none,
                    fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 10),
                    fontWeight: FontWeight.bold,
                    color: Utils.getPassedColorFromTheme(),
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
