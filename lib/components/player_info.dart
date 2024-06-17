import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/models/turn_model.dart';

class PlayerInfo extends StatelessWidget {
  final Turn turn;
  const PlayerInfo({super.key, required this.turn});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: turn.players.map((p) {
            final isCurrent = turn.currentPlayer == p;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: isCurrent ? Colors.white : Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "${p.name} (${p.cards.length})",
                  style: TextStyle(
                      color: isCurrent ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
