import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/components/game_board.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';
import 'package:honeymoon_bridge_game/providers/honeymoon_bridge_game_provider.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

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
        title: const Text("Honeymoon Bridge"),
        actions: [
          TextButton(
            onPressed: () async {
              final players = [
                PlayerModel(name: "Eric", isHuman: true),
                PlayerModel(name: "Noah", isHuman: false),
              ];

              await _gameProvider.newGame(players);
            },
            child: const Text(
              "New Game",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: const GameBoard(),
    );
  }
}
