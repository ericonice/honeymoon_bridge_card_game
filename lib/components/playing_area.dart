import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/components/bidding_area.dart';
import 'package:honeymoon_bridge_game/components/card_selection_area.dart';
import 'package:honeymoon_bridge_game/components/play_again.dart';
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

      return Expanded(
          child: switch (phase) {
            HoneymoonPhase.selection => const CardSelectionArea(),
            HoneymoonPhase.bidding => const BiddingArea(),
            HoneymoonPhase.play =>
              TrickArea(size: size, players: model.players),
            HoneymoonPhase.complete => PlayAgain(players: model.players),
            _ => Container(),
          });
    });
  }
}
