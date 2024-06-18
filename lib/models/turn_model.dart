import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';

class Turn {
  final List<PlayerModel> players;
  int index;
  PlayerModel currentPlayer;
  CardModel? selectedCard;
  int drawCount;
  int actionCount;

  Turn({
    required this.players,
    required this.currentPlayer,
    this.index = 0,
    this.drawCount = 0,
    this.actionCount = 0,
  });

  void nextTurn({PlayerModel? player }) {
    index += 1;
    currentPlayer = (player == null) ? index % 2 == 0 ? players[0] : players[1] : player;
    drawCount = 0;
    actionCount = 0;
    selectedCard = null;
  }

  PlayerModel get otherPlayer {
    return players.firstWhere((p) => p != currentPlayer);
  }
}
