import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/components/playing_card.dart';
import 'package:honeymoon_bridge_game/components/responsive_utils.dart';
import 'package:honeymoon_bridge_game/constants.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';

class SelectionCardList extends StatelessWidget {
  final PlayerModel player;
  final List<CardModel> cards;
  final CardModel? selectedCard;
  final double size;
  final Function(CardModel)? onSelected;

  const SelectionCardList({
    super.key,
    required this.player,
    required this.cards,
    required this.selectedCard,
    this.size = 1,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    var responsiveSize = context.calculateResponsiveSize();

    return Expanded(
      child: SizedBox(
        height: cardHeight * responsiveSize,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return Container(
              decoration: BoxDecoration(
                border: selectedCard == card
                    ? Border.all(color: Colors.yellow, width: 3)
                    : null, // Apply border only if selected
              ),
              child: PlayingCard(
                card: card,
                size: size,
                visible: player.isHuman && (index == 0 || selectedCard != null),
                onPlayCard: onSelected,
              ),
            );
          },
        ),
      ),
    );
  }
}
