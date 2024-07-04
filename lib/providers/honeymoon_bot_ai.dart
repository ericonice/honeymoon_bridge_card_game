import 'dart:math';

import 'package:collection/collection.dart';
import 'package:honeymoon_bridge_game/models/bid_model.dart';
import 'package:honeymoon_bridge_game/models/bidding_model.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';

class HoneymoonBotAi {
  final PlayerModel bot;
  BidModel? contract;
  List<CardModel> cardsSortedByStrength = [];

  HoneymoonBotAi(this.bot);

  void prepareForPlay(BiddingModel bidding) {
    contract = bidding.contract()!;

    // Determine the quality of each of the suits
    final cardsBySuit = groupBy(bot.cards, (card) => card.suit);
    Map<Suit, int> suitStrength = {};
    for (var entry in cardsBySuit.entries) {
      final suit = entry.key;
      final cards = entry.value;

      // trump needs to be saved, so sort it last
      if (contract!.player.isBot && contract!.suit! == suit) {
        suitStrength[suit] = -20;
        continue;
      }

      // strength of 5 or hight is considered a strong suit
      if (cards.length > 1) {
        int strength = 0;

        if (cards[0].rank == 14 && cards[1].rank == 13) {
          strength = 10;
        } else if (cards[0].rank == 13 && cards[1].rank == 12) {
          strength = 8;
        } else if (cards[0].rank == 12 && cards[1].rank == 11) {
          strength = 6;
        }

        if (strength > 0) {
          strength += cards.length - 3;
          suitStrength[suit] = strength;
          continue;
        }
      }

      // suit not strong but let's see if it's safe, in the sense it will
      // not result in giving up a trick, like: K x x, or A Q x
      int safety = 0;
      if (cards[0].rank < 12) {
        safety = 1;
      } else if (cards[0].rank < 11) {
        safety = 2;
      } else if (cards.length == 1) {
        safety = 1;
      }
      if (safety > 0) {
        safety += max(min(2, cards.length) - 3, 0);
        suitStrength[suit] = safety;
        continue;
      }

      if (cards.length > 1) {
        int scariness = 0;
        if (cards[0].rank == 13) {
          scariness = -4;
        } else if (cards[0].rank == 12) {
          scariness = -3;
        } else if (cards[0].rank == 14 && cards[1].rank > 10) {
          scariness = -2;
        }
        if (scariness < 0) {
          scariness += max(2, cards.length - 3);
          suitStrength[suit] = scariness;
          continue;
        }
      }

      suitStrength[suit] = 0;
    }

    final suitOrder = suitStrength.keys.toList()
      ..sort((a, b) => suitStrength[b]!.compareTo(suitStrength[a]!));

    cardsSortedByStrength = List.of(bot.cards)
      ..sort((a, b) {
        int suitCompare =
            suitOrder.indexOf(a.suit).compareTo(suitOrder.indexOf(b.suit));

        if (suitCompare == 0) {
          return b.rank.compareTo(a.rank);
        }
        return suitCompare;
      });
  }

  CardModel playCard(CardModel? playedCard) {
    CardModel? cardToPlay;

    if (playedCard != null) {
      // Play consists of the following strategy (which is very, very unsophisticated):
      // 1. If have any cards of the suit that was played, then:
      //    Play the least card tha can beat the played card or lowest card if unable
      //    to beat the played card.
      // 2. Otherwise play the lowest trump, if any
      // 3. Otherwise, play the lowest card
      var suitPlayed = playedCard.suit;
      var rank = playedCard.rank;

      // get possible cards of same suit, which will be ordered in descending order
      var possibleCards = bot.cards.where((c) => c.suit == suitPlayed);

      // Handle 1
      if (possibleCards.isNotEmpty) {
        cardToPlay = possibleCards.lastWhereOrNull((c) => c.rank > rank);
        cardToPlay ??= possibleCards.lastWhere((c) => c.rank < rank);
      } else

      // Handle 2
      if (contract!.suit != Suit.NT) {
        cardToPlay = bot.cards.lastWhereOrNull((c) => c.suit == contract!.suit);
      }

      // Handle 3
      cardToPlay ??= bot.cards.reduce((a, b) => a.rank < b.rank ? a : b);
    } else {
      // Play the trump suit unless only 2 left
      if (contract!.player.isBot &&
          bot.cards.where((c) => c.suit == contract!.suit).length > 2) {
        cardToPlay = bot.cards.firstWhere((c) => c.suit == contract!.suit);
      } else {
        // - otherwise, play *strong* suit
        // - otherwise, play *safe* suit
        // - otherwise, play *scary* suit
        //
        // to help with strong, safe and scary, suits have been associated
        // with a strength.

        // The work of determining the strength of the cards has already been
        // done, so able to return the
        cardToPlay = cardsSortedByStrength[0];
      }
    }

    print("====== PLAY =========");
    print("hand: ${bot.cards.join(",")}");
    print("sorted hand: ${cardsSortedByStrength.join(",")}");
    print("opponent card: $playedCard");
    print("played card: $cardToPlay");
    print("========================");

    cardsSortedByStrength.remove(cardToPlay);
    return cardToPlay;
  }

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
    if (trumpSuit != null &&
        lastBidSuitOrDefault != null &&
        (CardModel.suitRank(trumpSuit!) <
            CardModel.suitRank(lastBidSuitOrDefault))) {
      minBidNumber++;
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
