import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/constants.dart';

class CardBack extends StatelessWidget {
  final double size;
  final Widget? child;
  final bool visible;

  const CardBack({super.key, this.size = 1, this.visible = true, this.child});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        width: cardWidth * size,
        height: cardHeight * size,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: child ?? Container(),
      ),
    );
  }
}
