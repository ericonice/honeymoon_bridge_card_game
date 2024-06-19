import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';
import 'package:honeymoon_bridge_game/providers/honeymoon_bridge_game_provider.dart';
import 'package:provider/provider.dart';

class PlayAgain extends StatelessWidget {
  final List<PlayerModel> players;
  const PlayAgain({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Consumer<HoneymoonBridgeGameProvider>(
        builder: (context, model, child) {
      return Center(
        child: TextButton(
          onPressed: () async {
            model.newGame(players);
          },
          child: const Text(
            "Another Game?",
            style: TextStyle(color: Colors.amber),
          ),
        ),
      );
    });
  }
}
