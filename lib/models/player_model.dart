import 'package:honeymoon_bridge_game/models/card_model.dart';

class PlayerModel {
  final String name;
  final bool isHuman;
  List<CardModel> cards;
  int score;

  PlayerModel({
    required this.name,
    this.cards = const [],
    this.isHuman = false,
    this.score = 0,
  });

  addCards(List<CardModel> newCards) {
    cards = [...cards, ...newCards];
    cards.sort((a, b) {
      int suitCompare = a.suit.index.compareTo(b.suit.index);
      if (suitCompare == 0) {
        return b.getNumericValue().compareTo(a.getNumericValue()); 
      }
      return suitCompare;
    });
  }

  removeCard(CardModel card) {
    cards.removeWhere((c) => c.value == card.value && c.suit == card.suit);
  }

  bool get isBot {
    return !isHuman;
  }
}