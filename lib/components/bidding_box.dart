import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/models/bid_model.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/providers/honeymoon_bridge_game_provider.dart';
import 'package:provider/provider.dart';

class BiddingBox extends StatefulWidget {
  const BiddingBox({super.key});

  @override
  State<BiddingBox> createState() => _BiddingBoxState();
}

class _BiddingBoxState extends State<BiddingBox> {
  int? _bidNumber;
  Suit? _suit;

  @override
  Widget build(BuildContext context) {
    return Consumer<HoneymoonBridgeGameProvider>(
      builder: (context, model, child) {
        return Row(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _bidNumber = null);
                      model.bid(BidModel(model.turn.currentPlayer, pass: true));
                    },
                    child: const Text("PASS"),
                  ),
                  const SizedBox(height: 16),
                  if (model.bidding?.canDouble() ?? false)
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _bidNumber = null);
                        model.bid(
                            BidModel(model.turn.currentPlayer, double: true));
                      },
                      child: const Text("DOUBLE"),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10), // Add spacing between rows
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildBidNumberSelector(model),
                  const SizedBox(height: 16),
                  if (_bidNumber != null) buildSuitSelector(model),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildBidNumberSelector(HoneymoonBridgeGameProvider model) {
    return SegmentedButton<int>(
      emptySelectionAllowed: true,
      segments: model.bidding!
          .getAvailableBidNumbers()
          .map((bidNumber) => ButtonSegment<int>(
                value: bidNumber,
                label: Text(bidNumber.toString()),
              ))
          .toList(),
      selected: _bidNumber != null ? {_bidNumber!} : {},
      onSelectionChanged: (newSelection) {
        setState(() {
          _bidNumber = newSelection.first;
          _suit = null; // Reset suit when bid number changes
        });
      },
    );
  }

  Widget buildSuitSelector(HoneymoonBridgeGameProvider model) {
    return SegmentedButton<Suit>(
      emptySelectionAllowed: true,
      segments: model.bidding!
          .getAvailableSuits(_bidNumber)
          .map((suit) => ButtonSegment<Suit>(
                value: suit,
                label: Text(
                  CardModel.suitToUnicode(suit),
                  style: TextStyle(color: CardModel.suitToColor(suit)),
                ),
              ))
          .toList(),
      selected: _suit != null ? {_suit!} : {},
      onSelectionChanged: (newSelection) {
        model.bid(BidModel(
          model.turn.currentPlayer,
          suit: newSelection.first,
          bidNumber: _bidNumber,
        ));
        setState(() {
          _bidNumber = null;
          _suit = null; // Reset both after a bid
        });
      },
    );
  }
}
