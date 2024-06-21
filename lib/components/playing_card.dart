import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/components/card_back.dart';
import 'package:honeymoon_bridge_game/components/responsive_utils.dart';
import 'package:honeymoon_bridge_game/constants.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';

class PlayingCard extends StatelessWidget {
  final CardModel card;
  final double size;
  final bool visible;
  final Function(CardModel)? onPlayCard;

  const PlayingCard(
      {super.key,
      required this.card,
      this.size = 1,
      this.visible = false,
      this.onPlayCard});

  @override
  Widget build(BuildContext context) {
    var responsiveSize = context.calculateResponsiveSize();

    return GestureDetector(
      onTap: () {
        if (onPlayCard != null) onPlayCard!(card);
      },
      child: Container(
          width: cardWidth * responsiveSize,
          height: cardHeight * responsiveSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            imageUrl: visible ? card.image : backOfCardImage,
            width: cardWidth * responsiveSize,
            height: cardHeight * responsiveSize,
          )),
    );
  }
}
