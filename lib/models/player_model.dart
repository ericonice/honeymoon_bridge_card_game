import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/models/score_model.dart';

class PlayerModel {
  final String name;
  final bool isHuman;
  List<CardModel> cards;
  int tricks;
  CardModel? playedCard;
  ScoreModel score = ScoreModel();

  PlayerModel(
      {required this.name,
      this.cards = const [],
      this.tricks = 0,
      this.isHuman = false});

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

  sortCardsByTrump(Suit trump) {
    // sort cards with trump first
    List<Suit> suitOrder = [];
    switch (trump) {
      case Suit.Spades:
      case Suit.NT:
        suitOrder = [Suit.Spades, Suit.Hearts, Suit.Clubs, Suit.Diamonds];
      case Suit.Hearts:
        suitOrder = [Suit.Hearts, Suit.Spades, Suit.Diamonds, Suit.Clubs];
      case Suit.Diamonds:
        suitOrder = [Suit.Diamonds, Suit.Clubs, Suit.Hearts, Suit.Spades];
      case Suit.Clubs:
        suitOrder = [Suit.Clubs, Suit.Diamonds, Suit.Spades, Suit.Hearts];
    }

    cards.sort((a, b) {
      int suitCompare =
          suitOrder.indexOf(a.suit).compareTo(suitOrder.indexOf(b.suit));

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

  void resetForNewGame({bool resetScore = false}) {
    tricks = 0;
    playedCard = null;
    cards = [];
    if (resetScore) {
      score = ScoreModel();
    }
  }
}
