import 'package:collection/collection.dart';
import 'package:honeymoon_bridge_game/constants.dart';
import 'package:honeymoon_bridge_game/models/bid.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';
import 'package:honeymoon_bridge_game/providers/game_provider.dart';

const GS_PHASE = 'GS_PHASE';

enum HoneymoonPhase {
  selection,
  bidding,
  play,
}

class HoneymoonBridgeGameProvider extends GameProvider {

  @override
  Future<void> setupBoard() async {
    turn.drawCount = 0;
    turn.actionCount = 0;
    gameState[GS_PHASE] = HoneymoonPhase.selection;
    await drawSelectionCards(); 

    //temporary
    // gameState[GS_PHASE] = HoneymoonPhase.play;
    // bidding!.bid(players[0], BidModel(players[0], suit: Suit.Spades, bidNumber: 2));
    // await drawCards(players[0], count: 13, allowAnyTime: true);
    // await drawCards(players[1], count: 13, allowAnyTime: true);    
    // await endTurn();
 }

  bool get canBid {
    if (turn.currentPlayer.isBot) return false;

    var phase = gameState[GS_PHASE];
    switch (phase) {
      case HoneymoonPhase.bidding:
        return turn.actionCount == 0;
      default:
        return false;
    }
  }

  @override
  bool get canEndTurn {
    var phase = gameState[GS_PHASE];
    switch (phase) {
      case HoneymoonPhase.selection:
      case HoneymoonPhase.bidding:
      case HoneymoonPhase.play:
        return turn.actionCount > 0;
      default:
        return false;
    }
  }

  @override
  bool canPlayCard(PlayerModel player, CardModel card) {
    var phase = gameState[GS_PHASE];

    switch (phase)
    {
      case HoneymoonPhase.selection:
      case HoneymoonPhase.bidding:
        return false;
      case HoneymoonPhase.play:
        return turn.actionCount == 0;
      default:
        return false;

    }
  }

  @override
  bool get gameIsOver {
    var phase = gameState[GS_PHASE];

    switch (phase) {
      case HoneymoonPhase.selection:
        return false;
    }

    return false;
  }

  @override
  void finishGame() {
    showToast("Game over! ${turn.currentPlayer.name} WINS!");
    notifyListeners();
  }

  @override
  Future<void> botTurn() async {
    final phase = gameState[GS_PHASE];
    await Future.delayed(const Duration(milliseconds: 500));
    var bot = players[1];

    switch (phase) {
      case HoneymoonPhase.selection:
        {
          var card = (selectionCards.first.rank >= 11) ? selectionCards[0] : selectionCards[1];
          selectCard(turn.currentPlayer, card);
          await endTurn();
          if (currentDeck!.remaining == 0)
          {
            gameState[GS_PHASE] = HoneymoonPhase.bidding;
          }
        }

      case HoneymoonPhase.bidding:
        {
          // Bot kind of dumb, only Passes
          bid(BidModel(bot, pass: true));
        }

      case HoneymoonPhase.play:
        {
          // Determine if a card has already been played
          CardModel? cardToPlay;
          if (otherPlayer.playedCard != null)
          {
            // Play consists of the following strategy (which is very, very unsophisticated):
            // 1. If have any cards of the suit that was played, then:
            //    Play the least card tha can beat the played card or lowest card if unable
            //    to beat the played card.
            // 2. Otherwise play the lowest trump, if any
            // 3. Otherwise, play the lowest card
            var suitPlayed = otherPlayer.playedCard!.suit;
            var rank = otherPlayer.playedCard!.rank;
            var suitContract = bidding!.contract()!.suit!;

            // get possible cards of same suit, which will be ordered in descending order
            var possibleCards = bot.cards.where((c) => c.suit == suitPlayed);
            if (possibleCards.isNotEmpty)
            {
              // Handle 1
              cardToPlay = possibleCards.lastWhereOrNull((c) => c.rank > rank);
              cardToPlay ??= possibleCards.firstWhere((c) => c.rank < rank);
            }
            else if (suitContract != Suit.NT)
            {
              // Handle 2
              cardToPlay = bot.cards.lastWhereOrNull((c) => c.suit == suitContract);

              // Handle 3
              cardToPlay ??= players[1].cards.reduce((a, b) => a.rank < b.rank ? a : b);
            } 
          } 
          else
          {
            // Bot kind of dumb, plays highest card
            cardToPlay = players[1].cards.reduce((a, b) => a.rank > b.rank ? a : b);
          }
          
          playCard(player: bot, card: cardToPlay!);
          await endTurn();
        }
    }
    
    // for (final c in p.cards) {
    //   if (canPlayCard(c)) {
    //     await playCard(player: p, card: c);
    //     endTurn();
    //     return;
    //   }
    // }

    // await Future.delayed(const Duration(milliseconds: 500));
    // await drawCards(p);
    // await Future.delayed(const Duration(milliseconds: 500));

    // if (canPlayCard(p.cards.last)) {
    //   await playCard(player: p, card: p.cards.last);
    // }

    // endTurn();
  }
}
