import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';

class BidModel {
  final PlayerModel player;
  final Suit? suit;
  final int? bidNumber;
  final bool? double;
  final bool? pass;

  BidModel(this.player, {
    this.suit,
    this.bidNumber,
    this.double,
    this.pass
  });

  @override
  String toString()
  {
    if (pass == true) return "Pass";
    if (double == true) return "Double";

    return "$bidNumber${CardModel.suitToUnicode(suit!)}";

  }
}