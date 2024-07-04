import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/components/bidding_box.dart';
import 'package:honeymoon_bridge_game/components/bidding_history.dart';
import 'package:honeymoon_bridge_game/providers/honeymoon_bridge_game_provider.dart';
import 'package:provider/provider.dart';

class BiddingArea extends StatelessWidget {
  const BiddingArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HoneymoonBridgeGameProvider>(
        builder: (context, model, child) {
      return Visibility(
        visible: model.canBid,
        child: const Column(
            //mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(fit: FlexFit.loose, child: BiddingHistory()),
              SizedBox(height: 16),
              Expanded(child: BiddingBox()),
            ]),
      );
    });
  }
}

        
//                 crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 3,
//             child: Column(
//               children: [
//                 !model.canBid
//                     ? const Spacer()
//                     : Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(4),
//                               child: Expanded(
//                                 child: ElevatedButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         _bidNumber = null;
//                                       });
//                                       model.bid(BidModel(model.turn.currentPlayer,
//                                           pass: true));
//                                     },
//                                     child: const Text("PASS")),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(4),
//                               child: Visibility(
//                                 visible: model.bidding!.canDouble(),
//                                 child: Expanded(
//                                   child: ElevatedButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           _bidNumber = null;
//                                         });
//                                         model.bid(BidModel(
//                                             model.turn.currentPlayer,
//                                             double: true));
//                                       },
//                                       child: const Text("DOUBLE")),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                 !model.canBid
//                     ? const Spacer()
//                     : Expanded(
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: SegmentedButton<int>(
//                                 emptySelectionAllowed: true,
//                                 style: ButtonStyle(
//                                   padding: WidgetStateProperty.all(
//                                       const EdgeInsets.symmetric(
//                                           horizontal: 5)),
//                                   textStyle: WidgetStateProperty.all(
//                                     const TextStyle(fontSize: 10),
//                                   ),
//                                 ),
//                                 segments: model.bidding!
//                                     .getAvailableBidNumbers()
//                                     .map((bidNumber) => ButtonSegment<int>(
//                                           value: bidNumber,
//                                           label: Text(bidNumber.toString()),
//                                         ))
//                                     .toList(),
//                                 selected: {
//                                   ...?(_bidNumber != null
//                                       ? [_bidNumber!]
//                                       : null)
//                                 },
//                                 onSelectionChanged: (Set<int> newSelection) {
//                                   setState(() {
//                                     _bidNumber = newSelection.first;
//                                   });
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(5),
//                     child: Row(
//                       children: [
//                         _bidNumber == null
//                             ? const Spacer()
//                             : Expanded(
//                               child: SegmentedButton<Suit>(
//                                   emptySelectionAllowed: true,
//                                   segments: model.bidding!
//                                       .getAvailableSuits(_bidNumber)
//                                       .map((suit) => ButtonSegment<Suit>(
//                                             value: suit,
//                                             label: Text(
//                                                 CardModel.suitToUnicode(suit),
//                                                 style: TextStyle(
//                                                   color:
//                                                       CardModel.suitToColor(suit),
//                                                 )),
//                                           ))
//                                       .toList(),
//                                   selected: {
//                                     ...?(_suit != null ? [_suit!] : null)
//                                   },
//                                   onSelectionChanged: (Set<Suit> newSelection) {
//                                     model.bid(BidModel(model.turn.currentPlayer,
//                                         suit: newSelection.first,
//                                         bidNumber: _bidNumber));
//                                     setState(() {
//                                       _bidNumber = null;
//                                     });
//                                   },
//                                 ),
//                             ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Container(
//               color: Theme.of(context).colorScheme.onSecondary,
//               child: ListView(
//                 primary: false,
//                 padding: const EdgeInsets.all(10),
//                 shrinkWrap: true,
//                 children: [
//                   // Header Row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Center(
//                         child: Text(
//                           model.players[0].name,
//                         ),
//                       ),
//                       const SizedBox(width: 5),
//                       Center(
//                         child: Text(
//                           model.players[1].name,
//                         ),
//                       )
//                     ],
//                   ),
//                   ...model.bidding!.getBidRounds().map((round) => Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Center(
//                             child: Text(round.$1.toString(),
//                                 style: TextStyle(
//                                   color: CardModel.suitToColor(round.$1?.suit),
//                                 )),
//                           ),
//                           const SizedBox(width: 5),
//                           Center(
//                             child: Text(round.$2 == null ? "" : round.$2.toString(),
//                                 style: TextStyle(
//                                   color: CardModel.suitToColor(round.$2?.suit),
//                                 )),
//                           ),
//                         ],
//                       ))
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
