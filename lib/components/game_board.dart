import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/components/player_card_list.dart';
import 'package:honeymoon_bridge_game/components/player_info.dart';
import 'package:honeymoon_bridge_game/components/playing_area.dart';
import 'package:honeymoon_bridge_game/components/status_area.dart';
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
          ? SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PlayerInfo(turn: model.turn),
                    Expanded(
                      flex: 2,
                      child: StatusArea(
                        players: model.players,
                        contract: model.bidding!.contract(),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: PlayerCardList(
                        player: model.players[1],
                      ),
                    ),
                    const Expanded(
                        flex: 3, child: PlayingArea()),
                    Expanded(
                      flex: 1,
                      child: PlayerCardList(
                        player: model.players[0],
                        onPlayCard: (CardModel card) async {
                          await model.playCard(
                              player: model.players[0], card: card);
                        },
                      ),
                    ),
                    // Expanded(
                    //   flex: 1,
                    //   child: Stack(
                    //     children: [
                    //       Align(
                    //         alignment: Alignment.bottomCenter,
                    //         child: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: (model.turn.currentPlayer ==
                    //                       model.players[0])
                    //                   ? Row(
                    //                       mainAxisAlignment: MainAxisAlignment.end,
                    //                       children: [
                    //                         ElevatedButton(
                    //                             onPressed: model.canEndTurn
                    //                                 ? () {
                    //                                     model.endTurn();
                    //                                   }
                    //                                 : null,
                    //                             child: const Text("End Turn"))
                    //                       ],
                    //                     )
                    //                   : Container(),
                    //             ),
                    //             PlayerCardList(
                    //               player: model.players[0],
                    //               onPlayCard: (CardModel card) async {
                    //                 await model.playCard(
                    //                     player: model.players[0], card: card);
                    //               },
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          : Center(
              child: TextButton(
                child: const Text("New Game?"),
                onPressed: () {
                  final players = [
                    PlayerModel(name: "Noah", isHuman: true),
                    PlayerModel(name: "Bot", isHuman: false),
                  ];
                  model.newGame(players);
                },
              ),
            );
    });
  }
}
