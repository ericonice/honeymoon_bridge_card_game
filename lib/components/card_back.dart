import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/constants.dart';

class CardBack extends StatelessWidget {
  final double size;
  final Widget? child;

  const CardBack({super.key, this.size = 1, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth * size,
      height: cardHeight * size,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: child ?? Container(),
    );
  }
}
