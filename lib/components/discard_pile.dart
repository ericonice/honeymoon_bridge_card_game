import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/components/playing_card.dart';
import 'package:honeymoon_bridge_game/components/responsive_utils.dart';
import 'package:honeymoon_bridge_game/constants.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';

class DiscardPile extends StatelessWidget {
  final List<CardModel> cards;
  final double size;
  final Function(CardModel)? onPressed;

  const DiscardPile({
    super.key,
    required this.cards,
    this.size = 1,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var responsiveSize = context.calculateResponsiveSize();

    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed!(cards.last);
        }
      },
      child: Container(
        width: cardWidth * responsiveSize,
        height: cardHeight * responsiveSize,
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black45, width: 2)),
        child: IgnorePointer(
          ignoring: true,
          child: Stack(
            children: cards
                .map((card) => PlayingCard(
                      card: card,
                      visible: true,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
