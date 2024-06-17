import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/models/bid.dart';
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
                      child: Text(players[0].score.toString()),
                    ),
                    TableCell(
                      child: Text(players[1].score.toString()),
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
                      child: Text(players[0].tricks.length.toString()),
                    ),
                    TableCell(
                      child: Text(players[1].tricks.length.toString()),
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
