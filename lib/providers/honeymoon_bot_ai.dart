import 'dart:math';

import 'package:collection/collection.dart';
import 'package:honeymoon_bridge_game/models/bid_model.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';

class HoneymoonBotAi {
  final PlayerModel bot;

  HoneymoonBotAi(this.bot);

  bool chooseCard(CardModel card) {
    var turnsRemaining = 12 - bot.cards.length;
    var numberOfCardsOfSameSuit =
        bot.cards.where((c) => c.suit == card.suit).length;

    switch (card.rank) {
      // Always choose A
      case 14:
        return true;

      // Choose king if at least 1 in same suit or two more turns
      case 13:
        return turnsRemaining >= 2 || numberOfCardsOfSameSuit >= 1;

      case 12:
        return turnsRemaining >= 5 || numberOfCardsOfSameSuit >= 2;

      case 11:
        return turnsRemaining >= 11 ||
            (turnsRemaining >= 7 && numberOfCardsOfSameSuit >= 2) ||
            (turnsRemaining >= 5 && numberOfCardsOfSameSuit >= 3) ||
            (numberOfCardsOfSameSuit >= 4);

      default:
        return (turnsRemaining >= 11 && numberOfCardsOfSameSuit >= 2) ||
            (turnsRemaining >= 5 && numberOfCardsOfSameSuit >= 3) ||
            (numberOfCardsOfSameSuit >= 4);
    }
  }

  BidModel chooseBid(List<BidModel> bids) {
    final lastBid = bids.lastWhereOrNull((b) => b.bidNumber != null);
    final minBidNumber = lastBid?.bidNumber ?? 1;

    final cardsBySuit = groupBy(bot.cards, (card) => card.suit);
    final rankPoints = bot.cards
        .fold(0, (sum, card) => sum + (card.rank < 11 ? 0 : (card.rank - 10)));
    final suitPoints = cardsBySuit.entries
        .fold(0, (sum, entry) => sum + max(3 - entry.value.length, 0));
    final points = rankPoints + suitPoints;

    // Determine the expected number of winners for each suit
    double expectedTricks = 0;
    Suit? trumpSuit;
    cardsBySuit.forEach((suit, cards) {
      // See if this suit is good enough to be trump
      if (cards.length >= 5) {
        if (trumpSuit == null) {
          trumpSuit = suit;
        } else if (suit.index > trumpSuit!.index) {
          trumpSuit = suit;
        }
      }

      var faceCardCount = cards.where((c) => c.rank >= 11).length;
      switch (cards.length) {
        case 1:
          expectedTricks += cards[0].rank == 14 ? 1 : 0;

        case 2:
          if (cards.where((c) => c.rank >= 13).length == 2) {
            expectedTricks += 2;
          } else if (faceCardCount == 2) {
            expectedTricks += 1;
          } else if (faceCardCount == 1) {
            expectedTricks += 0.5;
          }

        default:
          expectedTricks += (faceCardCount - 3) + cards.length;
      }
    });

    // Don't bid if no trump suit
    if (trumpSuit == null) {
      return BidModel(bot, pass: true);
    }

    // Determine the bid based on expected tricks and points
    var bidNumberViaExpectedTricks = (expectedTricks - 6);
    int bidNumberViaPoints;
    switch (points) {
      case > 35:
        bidNumberViaPoints = 6;
        break;
      case > 28:
        bidNumberViaPoints = 4;
        break;
      case > 23:
        bidNumberViaPoints = 3;
        break;
      case > 18:
        bidNumberViaPoints = 2;
        break;
      case > 13:
        bidNumberViaPoints = 1;
        break;
      default:
        bidNumberViaPoints = 0; // Or any other default value
    }

    var maxBidNumber =
        ((bidNumberViaPoints + bidNumberViaExpectedTricks) / 2).ceil();

    // print("maxBidNumber: $maxBidNumber");
    // print("trumpSuit: $trumpSuit");
    // print("rankPoints: $rankPoints");
    // print("suitPoints: $suitPoints");
    // print("expectedTricks: $expectedTricks");
    // print("minBidNumber: $minBidNumber");

    if (trumpSuit == lastBid?.suit) {
      return BidModel(bot, pass: true);
    }

    if (maxBidNumber < minBidNumber) {
      return BidModel(bot, pass: true);
    }

    return BidModel(bot, suit: trumpSuit, bidNumber: maxBidNumber);
  }
}