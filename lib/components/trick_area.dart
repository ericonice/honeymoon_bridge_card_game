import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/components/card_back.dart';
import 'package:honeymoon_bridge_game/components/playing_card.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';

class TrickArea extends StatelessWidget {
  final double size;
  final List<PlayerModel> players;

  const TrickArea({super.key, required this.players, this.size = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        players[1].playedCard == null
            ? CardBack(size: size, visible: false)
            : PlayingCard(
                card: players[1].playedCard!,
                size: size,
                visible: true,
              ),
        players[0].playedCard == null
            ? CardBack(size: size, visible: false)
            : PlayingCard(
                card: players[0].playedCard!,
                size: size,
                visible: true,
              ),
      ],
    );
  }
}
