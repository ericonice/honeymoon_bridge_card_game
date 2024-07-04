import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/providers/honeymoon_bridge_game_provider.dart';
import 'package:provider/provider.dart';

class BiddingHistory extends StatelessWidget {
  const BiddingHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HoneymoonBridgeGameProvider>(
        builder: (context, model, child) {
      return Container(
        color: Theme.of(context).colorScheme.onSecondary,
        child: ListView(
          primary: false,
          padding: const EdgeInsets.all(10),
          shrinkWrap: true,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Text(
                    model.players[0].name,
                  ),
                ),
                const SizedBox(width: 5),
                Center(
                  child: Text(
                    model.players[1].name,
                  ),
                )
              ],
            ),
            ...model.bidding!.getBidRounds().map((round) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: Text(round.$1.toString(),
                          style: TextStyle(
                            color: CardModel.suitToColor(round.$1?.suit),
                          )),
                    ),
                    const SizedBox(width: 5),
                    Center(
                      child: Text(round.$2 == null ? "" : round.$2.toString(),
                          style: TextStyle(
                            color: CardModel.suitToColor(round.$2?.suit),
                          )),
                    ),
                  ],
                ))
          ],
        ),
      );
    });
  }
}
