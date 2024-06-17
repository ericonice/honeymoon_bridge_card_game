import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/components/player_card_list.dart';
import 'package:honeymoon_bridge_game/components/player_info.dart';
import 'package:honeymoon_bridge_game/components/playing_area.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';
import 'package:honeymoon_bridge_game/providers/honeymoon_bridge_game_provider.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HoneymoonBridgeGameProvider>(
        builder: (context, model, child) {
      return model.currentDeck != null
          ? Column(
              children: [
                PlayerInfo(turn: model.turn),
                PlayerCardList(
                  player: model.players[1],
                ),
                const Expanded(child: PlayingArea()),
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: (model.turn.currentPlayer ==
                                      model.players[0])
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ...model.additionalButtons
                                            .map((button) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 4),
                                                  child: ElevatedButton(
                                                      onPressed: button.enabled
                                                          ? button.onPressed
                                                          : null,
                                                      child:
                                                          Text(button.label)),
                                                )),
                                        ElevatedButton(
                                            onPressed: model.canEndTurn
                                                ? () {
                                                    model.endTurn();
                                                  }
                                                : null,
                                            child: const Text("End Turn"))
                                      ],
                                    )
                                  : Container(),
                            ),
                            PlayerCardList(
                              player: model.players[0],
                              onPlayCard: (CardModel card) {
                                model.playCard(
                                    player: model.players[0], card: card);
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: TextButton(
                child: const Text("New Game?"),
                onPressed: () {
                  final players = [
                    PlayerModel(name: "Eric", isHuman: true),
                    PlayerModel(name: "Noah", isHuman: false),
                  ];
                  model.newGame(players);
                },
              ),
            );
    });
  }
}
