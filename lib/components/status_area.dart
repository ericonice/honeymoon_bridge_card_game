import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:honeymoon_bridge_game/models/bid_model.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';

class StatusArea extends StatelessWidget {
  final List<PlayerModel> players;
  final BidModel? contract;

  const StatusArea({
    super.key,
    required this.players,
    required this.contract,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Card(
            child: SingleChildScrollView(
              child: Table(
                children: [
                  const TableRow(
                    children: [
                      SizedBox(), // Empty cell for spacing
                      Center(
                        child: Text(
                          'Score',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(), // Empty cell for spacing
                    ],
                  ),
                  TableRow(
                    children: [
                      const SizedBox(), // Empty cell for spacing
                      TableCell(
                        child: Text(players[0].name),
                      ),
                      TableCell(
                        child: Text(players[1].name),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Text("Total"),
                      ),
                      TableCell(
                        child: Text("${players[0].score.total}"),
                      ),
                      TableCell(
                        child: Text("${players[1].score.total}"),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Text("Games"),
                      ),
                      TableCell(
                        child: Text("${players[0].score.games}"),
                      ),
                      TableCell(
                        child: Text("${players[1].score.games}"),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Text("Over"),
                      ),
                      TableCell(
                        child: Text(
                            "${players[0].score.over + players[0].score.underCompleted}"),
                      ),
                      TableCell(
                        child: Text(
                            "${players[1].score.over + players[1].score.underCompleted}"),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Text("Under"),
                      ),
                      TableCell(
                        child: Text("${players[0].score.underCurrent}"),
                      ),
                      TableCell(
                        child: Text("${players[1].score.underCurrent}"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(children: [
            Card(
              child: Table(
                children: [
                  const TableRow(
                    children: [
                      Center(
                        child: Text(
                          'Contract',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Center(
                        child: Text(
                          contract == null
                              ? ""
                              : "${contract!.player.name}: ${contract!.toString()}",
                          style: TextStyle(
                              color: CardModel.suitToColor(contract?.suit)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              child: Padding(
                // Add padding for visual spacing
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Tricks',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                        height:
                            8), // Optional: Add space between title and trick counts
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceAround, // Evenly space trick counts
                      children: [
                        Text("${players[0].name}: ${players[0].tricks}"),
                        Text("${players[1].name}: ${players[1].tricks}"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
