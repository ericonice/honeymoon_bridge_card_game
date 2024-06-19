import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/components/bidding_area.dart';
import 'package:honeymoon_bridge_game/components/card_selection_area.dart';
import 'package:honeymoon_bridge_game/components/status_area.dart';
import 'package:honeymoon_bridge_game/components/trick_area.dart';
import 'package:honeymoon_bridge_game/providers/honeymoon_bridge_game_provider.dart';
import 'package:provider/provider.dart';

class PlayingArea extends StatelessWidget {
  final double size;
  const PlayingArea({super.key, this.size = 1});

  @override
  Widget build(BuildContext context) {
    return Consumer<HoneymoonBridgeGameProvider>(
        builder: (context, model, child) {
      var phase = model.gameState[gsPhase];

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: StatusArea(
              players: model.players,
              contract: model.bidding!.contract(),
            ),
          ),
          Expanded(
            flex: 3,
            child: phase == HoneymoonPhase.selection
                ? const CardSelectionArea()
                : phase == HoneymoonPhase.bidding
                    ? const BiddingArea()
                    : Expanded(child: TrickArea(size: size, players: model.players)),
          ),
        ],
      );
    });
  }
}
