import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/components/game_board.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';
import 'package:honeymoon_bridge_game/providers/honeymoon_bridge_game_provider.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final HoneymoonBridgeGameProvider _gameProvider;

  @override
  void initState() {
    _gameProvider = Provider.of<HoneymoonBridgeGameProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Honeymoon Bridge v0.2"),
        actions: [
          TextButton(
            onPressed: () async {
              final players = [
                PlayerModel(name: "Noah", isHuman: true),
                PlayerModel(name: "Bot", isHuman: false),
              ];

              await _gameProvider.newGame(players);
            },
            child: const Text(
              "New Rubber",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: const GameBoard(),
    );
  }
}
