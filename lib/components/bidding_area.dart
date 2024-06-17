import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/models/bid.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/providers/honeymoon_bridge_game_provider.dart';
import 'package:provider/provider.dart';

class BiddingArea extends StatefulWidget {
  const BiddingArea({super.key});

  @override
  State<BiddingArea> createState() => _BiddingAreaState();
}

class _BiddingAreaState extends State<BiddingArea> {
  int? _bidNumber;
  Suit? _suit;

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
                            Text(round.$1.toString(),
                                style: TextStyle(
                                  color: CardModel.suitToColor(round.$1?.suit),
                                )),
                            const SizedBox(width: 10),
                            Text(round.$2 == null ? "" : round.$2.toString(),
                                style: TextStyle(
                                  color: CardModel.suitToColor(round.$2?.suit),
                                )),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ),
          !model.canBid
              ? const Spacer()
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _bidNumber = null;
                              });
                              model.bid(BidModel(pass: true));
                            },
                            child: const Text("PASS")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Visibility(
                          visible: model.bidding!.canDouble(),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _bidNumber = null;
                                });
                                model.bid(BidModel(double: true));
                              },
                              child: const Text("DOUBLE")),
                        ),
                      ),
                    ],
                  ),
                ),
          !model.canBid
              ? const Spacer()
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SegmentedButton<int>(
                        emptySelectionAllowed: true,
                        segments: model.bidding!
                            .getAvailableBidNumbers()
                            .map((bidNumber) => ButtonSegment<int>(
                                  value: bidNumber,
                                  label: Text(bidNumber.toString()),
                                ))
                            .toList(),
                        selected: {
                          ...?(_bidNumber != null ? [_bidNumber!] : null)
                        },
                        onSelectionChanged: (Set<int> newSelection) {
                          setState(() {
                            _bidNumber = newSelection.first;
                          });
                        },
                      ),
                    ],
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                _bidNumber == null
                    ? const Spacer()
                    : SegmentedButton<Suit>(
                        emptySelectionAllowed: true,
                        segments: model.bidding!
                            .getAvailableSuits(_bidNumber)
                            .map((suit) => ButtonSegment<Suit>(
                                  value: suit,
                                  label: Text(CardModel.suitToUnicode(suit),
                                      style: TextStyle(
                                        color: CardModel.suitToColor(suit),
                                      )),
                                ))
                            .toList(),
                        selected: {
                          ...?(_suit != null ? [_suit!] : null)
                        },
                        onSelectionChanged: (Set<Suit> newSelection) {
                          model.bid(BidModel(
                              suit: newSelection.first, bidNumber: _bidNumber));
                          setState(() {
                            _bidNumber = null;
                          });
                        },
                      ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
