import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/components/playing_card.dart';
import 'package:honeymoon_bridge_game/constants.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';

class SelectionCardList extends StatelessWidget {
  final PlayerModel player;
  final List<CardModel> cards;
  final bool selected;
  final double size;
  final Function(CardModel)? onSelected;

  const SelectionCardList({
    super.key,
    required this.player,
    required this.cards,
    required this.selected,
    this.size = 1,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: CARD_HEIGHT * size,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return PlayingCard(
              card: card,
              size: size,
              visible: index == 0 || selected,
              onPlayCard: onSelected,
            );
          },
        ),
      ),
    );
  }
}
