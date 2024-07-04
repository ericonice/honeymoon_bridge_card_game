import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/components/deck_pile.dart';
import 'package:honeymoon_bridge_game/components/selection_card_list.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/providers/honeymoon_bridge_game_provider.dart';
import 'package:provider/provider.dart';

class CardSelectionArea extends StatelessWidget {
  const CardSelectionArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HoneymoonBridgeGameProvider>(
        builder: (context, model, child) {
      return Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DeckPile(
              remaining: model.currentDeck!.remaining,
            ),
            const SizedBox(width: 8),
            SelectionCardList(
              player: model.turn.currentPlayer,
              cards: model.selectionCards,
              selectedCard: model.turn.selectedCard,
              onSelected: (CardModel card) async {
                await model.selectCard(model.turn.currentPlayer, card);
              },
            ),
          ],
        ),
      );
    });
  }
}
