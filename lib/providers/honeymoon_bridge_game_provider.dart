import 'package:honeymoon_bridge_game/constants.dart';
import 'package:honeymoon_bridge_game/models/bid.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
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
        return turn.actionCount > 0;
      default:
        return false;
    }
  }

  @override
  bool canPlayCard(CardModel card) {
    bool canPlay = false;
    var phase = gameState[GS_PHASE];

    if (phase == HoneymoonPhase.selection) {
      return false;
    }

    if (gameState[GS_LAST_SUIT] == null || gameState[GS_LAST_VALUE] == null) {
      return false;
    }

    if (gameState[GS_LAST_SUIT] == card.suit) {
      canPlay = true;
    }

    if (gameState[GS_LAST_VALUE] == card.value) {
      canPlay = true;
    }

    if (card.value == "8") {
      canPlay = true;
    }

    return canPlay;
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

    switch (phase) {
      case HoneymoonPhase.selection:
        {
          var card = (selectionCards.first.getNumericValue() >= 11) ? selectionCards[0] : selectionCards[1];
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
          bid(BidModel(pass: true));
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
