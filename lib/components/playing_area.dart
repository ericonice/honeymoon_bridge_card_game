import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/components/bidding_area.dart';
import 'package:honeymoon_bridge_game/components/card_selection_area.dart';
import 'package:honeymoon_bridge_game/providers/honeymoon_bridge_game_provider.dart';
import 'package:provider/provider.dart';

class PlayingArea extends StatelessWidget {
  const PlayingArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HoneymoonBridgeGameProvider>(
        builder: (context, model, child) {
      var phase = model.gameState[GS_PHASE];

      return phase == HoneymoonPhase.selection
          ? const CardSelectionArea()
          : phase == HoneymoonPhase.bidding
              ? const BiddingArea()
              : const Placeholder();
    });
  }
}