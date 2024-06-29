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

    var keep = false;
    switch (card.rank) {
      // Always choose A
      case 14:
        keep = true;

      // Choose king if at least 1 in same suit or two more turns
      case 13:
        keep = turnsRemaining >= 2 || numberOfCardsOfSameSuit >= 1;

      case 12:
        keep = turnsRemaining >= 5 || numberOfCardsOfSameSuit >= 2;

      case 11:
        keep = turnsRemaining >= 11 ||
            (turnsRemaining >= 7 && numberOfCardsOfSameSuit >= 2) ||
            (turnsRemaining >= 5 && numberOfCardsOfSameSuit >= 3) ||
            (numberOfCardsOfSameSuit >= 4);

      default:
        keep = (turnsRemaining >= 10 && numberOfCardsOfSameSuit >= 1) ||
            (turnsRemaining >= 7 && numberOfCardsOfSameSuit >= 2) ||
            (turnsRemaining >= 5 && numberOfCardsOfSameSuit >= 3) ||
            (numberOfCardsOfSameSuit >= 4);
    }

    print("====== CHOOSE =========");
    print("hand: ${bot.cards.join(",")}");
    print("card: $card");
    print("turns remaining: $turnsRemaining");
    print("same suit: $numberOfCardsOfSameSuit");
    print("keep: $keep");
    print("========================");

    return keep;
  }

  BidModel chooseBid(List<BidModel> bids) {
    // Let's not get into redoubling yet
    if (bids.lastOrNull?.double == true) {
      return BidModel(bot, pass: true);
    }

    final lastBid = bids.lastWhereOrNull((b) => b.bidNumber != null);
    final lastBidNumberOrDefault = lastBid?.bidNumber ?? 1;
    final lastBidSuitOrDefault = lastBid?.suit;

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

    // Optimistically choose the best option
    var maxBidNumber =
        max(bidNumberViaPoints, bidNumberViaExpectedTricks.ceil());

    // Need to bid one more if opponent suit better than bots
    var minBidNumber = lastBidNumberOrDefault;
    if (lastBidSuitOrDefault != null) {
      if (CardModel.suitRank(trumpSuit!) < CardModel.suitRank(lastBidSuitOrDefault)) {
        minBidNumber++;
      }
    }

    print("======  BID     =========");
    print("hand: ${bot.cards.join(",")}");
    print("maxBidNumber: $maxBidNumber");
    print("trumpSuit: $trumpSuit");
    print("rankPoints: $rankPoints");
    print("suitPoints: $suitPoints");
    print("expectedTricks: $expectedTricks");
    print("minBidNumber: $minBidNumber");
    print("========================");

    // For now, just pass if doubled
    // TODO: Consider redouble
    if (lastBid?.double == true) {
      return BidModel(bot, pass: true);
    }

    // Don't bid if no biddable suit
    // TODO: Incorparate bidding NT
    if (trumpSuit == null) {
      return BidModel(bot, pass: true);
    }

    // If bot suit is same as opponent, double
    if (trumpSuit == lastBidSuitOrDefault) {
      if (lastBidNumberOrDefault > 2) {
        return BidModel(bot, double: true);
      }

      return BidModel(bot, pass: true);
    }

    // Be aggressive if competing with opponent
    if (maxBidNumber + 1 == minBidNumber) {
      maxBidNumber++;
    }
    if (maxBidNumber >= minBidNumber) {
      return BidModel(bot, suit: trumpSuit, bidNumber: maxBidNumber);
    }

    return BidModel(bot, pass: true);
  }
}
