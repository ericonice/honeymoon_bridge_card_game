import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/models/score_model.dart';

class PlayerModel {
  final String name;
  final bool isHuman;
  List<CardModel> cards;
  int tricks;
  CardModel? playedCard;
  ScoreModel score = ScoreModel();

  PlayerModel({
    required this.name,
    this.cards = const [],
    this.tricks = 0,
    this.isHuman = false
  });

  addCards(List<CardModel> newCards) {
    cards = [...cards, ...newCards];
    cards.sort((a, b) {
      int suitCompare = a.suit.index.compareTo(b.suit.index);
      if (suitCompare == 0) {
        return b.rank.compareTo(a.rank); 
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

  void resetForNewGame()
  {
    tricks = 0;
    playedCard = null;
  }
}
