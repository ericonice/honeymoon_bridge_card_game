import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/components/deck_pile.dart';
import 'package:honeymoon_bridge_game/components/selection_card_list.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/providers/honeymoon_bridge_game_provider.dart';
import 'package:provider/provider.dart';

class BiddingArea extends StatefulWidget {
  const BiddingArea({super.key});

  @override
  State<BiddingArea> createState() => _BiddingAreaState();
}

class _BiddingAreaState extends State<BiddingArea> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HoneymoonBridgeGameProvider>(
        builder: (context, model, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  model.players[0].name,
                ),
                const SizedBox(width: 10),
                Text(
                  model.players[1].name,
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.amberAccent,
              child: ListView(
                primary: false,
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
                children: model.bidding!
                    .getBidRounds()
                    .map((round) => Row(
                          children: [
                            Text(
                              round.$1.toString(),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              round.$2.toString(),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: ElevatedButton(onPressed: () {}, child: const Text("PASS")),
                ),
                ...model.bidding!
                    .getAvailableBidNumbers()
                    .map((bidNumber) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Text(bidNumber.toString())),
                        )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: ElevatedButton(onPressed: () {}, child: const Text("DOUBLE")),
                ),
                ...model.bidding!
                    .getAvailableBidNumbers()
                    .map((bidNumber) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Text(bidNumber.toString())),
                        )),
              ],
            ),
          ),
        ],
      );
    });
  }
}
