import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/components/playing_card.dart';
import 'package:honeymoon_bridge_game/constants.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';

class PlayerCardList extends StatelessWidget {
  final double size;
  final PlayerModel player;
  final Function(CardModel)? onPlayCard;

  const PlayerCardList({
    super.key,
    required this.player,
    this.size = 1,
    this.onPlayCard,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CARD_HEIGHT * size,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: player.cards.length,
        itemBuilder: (context, index) {
          final card = player.cards[index];
          return PlayingCard(
            card: card,
            size: size,
            // visible: player.isHuman,
            visible: true,
            onPlayCard: onPlayCard,
          );
        },
      ),
    );
  }
}
