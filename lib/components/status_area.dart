import 'package:flutter/material.dart';
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
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Table(
              defaultVerticalAlignment:
                  TableCellVerticalAlignment.middle, // Center text vertically
              children: [
                const TableRow(
                  children: [
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
                    TableCell(
                      child: Text("Games: ${players[0].score.games}"),
                    ),
                    TableCell(
                      child: Text("Games: ${players[1].score.games}"),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text("Over: ${players[0].score.over}"),
                    ),
                    TableCell(
                      child: Text("Over: ${players[1].score.over}"),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text("Completer Under: ${players[0].score.underCompleted}"),
                    ),
                    TableCell(
                      child: Text("Completed Under: ${players[1].score.underCompleted}"),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text("Under: ${players[0].score.underCurrent}"),
                    ),
                    TableCell(
                      child: Text("Under: ${players[1].score.underCurrent}"),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text("Total: ${players[0].score.total}"),
                    ),
                    TableCell(
                      child: Text("Total: ${players[1].score.total}"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Table(
              defaultVerticalAlignment:
                  TableCellVerticalAlignment.middle, // Center text vertically
              children: [
                const TableRow(
                  children: [
                    Center(
                      child: Text(
                        'Contract',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(), // Empty cell for spacing
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
                    const SizedBox(), // Empty cell for spacing
                  ],
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Table(
              defaultVerticalAlignment:
                  TableCellVerticalAlignment.middle, // Center text vertically
              children: [
                const TableRow(
                  children: [
                    Center(
                      child: Text(
                        'Tricks',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(), // Empty cell for spacing
                  ],
                ),
                TableRow(
                  children: [
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
                    TableCell(
                      child: Text(players[0].tricks.toString()),
                    ),
                    TableCell(
                      child: Text(players[1].tricks.toString()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
