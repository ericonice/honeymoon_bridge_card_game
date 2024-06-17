import 'package:honeymoon_bridge_game/models/card_model.dart';

class BidModel {
  final Suit? suit;
  final int? bidNumber;
  final bool? double;
  final bool? pass;

  BidModel({
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

    return "$bidNumber${suit.toString()}";

  }
}