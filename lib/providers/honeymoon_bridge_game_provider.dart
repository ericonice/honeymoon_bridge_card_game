import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/constants.dart';
import 'package:honeymoon_bridge_game/main.dart';
import 'package:honeymoon_bridge_game/models/bid_model.dart';
import 'package:honeymoon_bridge_game/models/bidding_model.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/models/deck_model.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';
import 'package:honeymoon_bridge_game/models/turn_model.dart';
import 'package:honeymoon_bridge_game/services/deck_service.dart';

const gsPhase = 'GS_PHASE';

enum HoneymoonPhase {
  selection,
  bidding,
  play,
}

class HoneymoonBridgeGameProvider with ChangeNotifier {
  HoneymoonBridgeGameProvider() {
    _service = DeckService();
  }

  late DeckService _service;

  late Turn _turn;
  Turn get turn => _turn;

  DeckModel? _currentDeck;
  DeckModel? get currentDeck => _currentDeck;

  List<PlayerModel> _players = [];
  List<PlayerModel> get players => _players;

  List<CardModel> _selectionCards = [];
  List<CardModel> get selectionCards => _selectionCards;

  List<CardModel> _discards = [];
  List<CardModel> get discards => _discards;
  CardModel? get discardTop => _discards.isEmpty ? null : _discards.last;

  Map<String, dynamic> gameState = {};
  Widget? bottomWidget;

  BiddingModel? _bidding;
  BiddingModel? get bidding => _bidding;

  Future<void> newGame(List<PlayerModel> players) async {
    final deck = await _service.newDeck();
    _currentDeck = deck;
    _players = players;
    _discards = [];
    _turn = Turn(players: players, currentPlayer: players.first);
    _bidding =
        BiddingModel(players: players, currentPlayer: players.first, bids: []);
    setupBoard();

    notifyListeners();
  }

  Future<void> drawCardToDiscardPile({int count = 1}) async {
    final draw = await _service.drawCards(_currentDeck!, count: count);

    _currentDeck!.remaining = draw.remaining;
    _discards.addAll(draw.cards);

    notifyListeners();
  }

  void setBottomWidget(Widget? widget) {
    bottomWidget = widget;
    notifyListeners();
  }

  PlayerModel get otherPlayer {
    return players.firstWhere((p) => p != _turn.currentPlayer);
  }

  Future<void> bid(BidModel bid) async {
    if (_bidding == null) {
      return;
    }

    _bidding!.bid(_turn.currentPlayer, bid);
    _turn.actionCount++;

    // If bidding is complete, move on to the next phase
    if (bidding!.done()) {
      gameState[gsPhase] = HoneymoonPhase.play;
    }

    await endTurn();

    notifyListeners();
  }

  void setTrump(Suit suit) {
    setBottomWidget(
      Card(
        child: Text(
          CardModel.suitToUnicode(suit),
          style: TextStyle(
            fontSize: 24,
            color: CardModel.suitToColor(suit),
          ),
        ),
      ),
    );
  }

  bool get showBottomWidget {
    return true;
  }

  bool get canDrawCard {
    return turn.drawCount < 1;
  }

  Future<void> drawCards(
    PlayerModel player, {
    int count = 1,
    bool allowAnyTime = false,
  }) async {
    if (currentDeck == null) return;
    if (!allowAnyTime && !canDrawCard) return;

    final draw = await _service.drawCards(_currentDeck!, count: count);

    player.addCards(draw.cards);

    _turn.drawCount += count;

    _currentDeck!.remaining = draw.remaining;

    notifyListeners();
  }

  Future<void> drawSelectionCards({
    int count = 2,
  }) async {
    if (currentDeck == null) return;
    if (!canDrawCard) return;

    final draw = await _service.drawCards(_currentDeck!, count: count);

    _selectionCards.addAll(draw.cards);
    _turn.drawCount += count;

    _currentDeck!.remaining = draw.remaining;

    notifyListeners();
  }

  Future<void> playCard({
    required PlayerModel player,
    required CardModel card,
  }) async {
    if (!canPlayCard(player, card)) return;

    player.removeCard(card);
    player.playedCard = card;
    _turn.actionCount += 1;

    if (player.isHuman) {
      await endTurn();
    }

    // if (gameIsOver) {
    //   finishGame();
    // }

    notifyListeners();
  }

  bool canDrawCardsFromDiscardPile({int count = 1}) {
    if (!canDrawCard) return false;

    return discards.length >= count;
  }

  Future<void> selectCard(PlayerModel player, CardModel card) async {
    var phase = gameState[gsPhase];

    if (phase != HoneymoonPhase.selection) {
      return;
    }

    if (_turn.actionCount >= 1) {
      return;
    }

    // give them to player
    _turn.actionCount += 1;
    _turn.selectedCard = card;
    player.addCards([card]);
    notifyListeners();

    await Future.delayed(defaultDelay);
    await endTurn();
  }

  void drawCardsFromDiscard(PlayerModel player, {int count = 1}) {
    if (!canDrawCardsFromDiscardPile(count: count)) {
      return;
    }

    // get the first x cards
    final start = discards.length - count;
    final end = discards.length;
    final cards = discards.getRange(start, end).toList();

    discards.removeRange(start, end);

    // give them to player
    player.addCards(cards);

    // incrment the draw count
    turn.drawCount += count;

    notifyListeners();
  }

  Future<void> applyCardSideEffects(CardModel card) async {}

  Future<void> endTurn() async {
    await Future.delayed(defaultDelay);

    var phase = gameState[gsPhase];
    switch (phase) {
      case HoneymoonPhase.selection:
        _turn.nextTurn();
        _selectionCards = [];
        await drawSelectionCards();
        notifyListeners();

      case HoneymoonPhase.bidding:
        _turn.nextTurn();

      case HoneymoonPhase.play:
        // If both players played, determine the winner
        if (players.every((p) => p.playedCard != null)) {
          var suitContract = bidding!.contract();

          // Winning card is:
          // 1. The highest trump else
          // 2. The highest card of the suit that was played first
          var firstCardPlayed = _turn.otherPlayer.playedCard!;
          var secondCardPlayed = _turn.currentPlayer.playedCard!;
          PlayerModel winner;
          if (firstCardPlayed.suit == secondCardPlayed.suit) {
            winner = firstCardPlayed.rank > secondCardPlayed.rank
                ? _turn.otherPlayer
                : _turn.currentPlayer;
          } else if (secondCardPlayed.suit == suitContract!.suit) {
            winner = _turn.currentPlayer;
          } else {
            winner = _turn.otherPlayer;
          }

          winner.tricks++;

          for (var p in players) {
            p.playedCard = null;
          }

          notifyListeners();
          await Future.delayed(defaultDelay);

          // winner starts the next turn
          _turn.nextTurn(player: winner);
        } else if (_turn.currentPlayer.playedCard == null) {
          // winnder of the bridge starts
          _turn.nextTurn(player: _turn.otherPlayer);
        } else {
          // other player needs to play now
          _turn.nextTurn(player: _turn.otherPlayer);
        }
    }

    if (_turn.currentPlayer.isBot) {
      botTurn();
    }

    notifyListeners();
  }

  void skipTurn() {
    _turn.nextTurn();
    _turn.nextTurn();

    notifyListeners();
  }

  void showToast(String message, {int seconds = 3, SnackBarAction? action}) {
    rootScaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: seconds),
        action: action,
      ),
    );
  }

  Future<void> setupBoard() async {
    turn.drawCount = 0;
    turn.actionCount = 0;
    gameState[gsPhase] = HoneymoonPhase.selection;
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

    var phase = gameState[gsPhase];
    switch (phase) {
      case HoneymoonPhase.bidding:
        return turn.actionCount == 0;
      default:
        return false;
    }
  }

  bool get canEndTurn {
    var phase = gameState[gsPhase];
    switch (phase) {
      case HoneymoonPhase.selection:
      case HoneymoonPhase.bidding:
      case HoneymoonPhase.play:
        return turn.actionCount > 0;
      default:
        return false;
    }
  }

  bool canPlayCard(PlayerModel player, CardModel card) {
    if (gameIsOver) return false;
    var phase = gameState[gsPhase];

    switch (phase) {
      case HoneymoonPhase.selection:
      case HoneymoonPhase.bidding:
        return false;
      case HoneymoonPhase.play:
        return _turn.actionCount < 1 && _turn.currentPlayer == player;
      default:
        return false;
    }
  }

  bool get gameIsOver {
    var phase = gameState[gsPhase];

    switch (phase) {
      case HoneymoonPhase.selection:
        return false;
    }

    return false;
  }

  void finishGame() {
    showToast("Game over! ${turn.currentPlayer.name} WINS!");
    notifyListeners();
  }

  Future<void> botTurn() async {
    final phase = gameState[gsPhase];
    await Future.delayed(defaultDelay);
    var bot = players[1];

    switch (phase) {
      case HoneymoonPhase.selection:
        {
          var card = (selectionCards.first.rank >= 11)
              ? selectionCards[0]
              : selectionCards[1];
          selectCard(turn.currentPlayer, card);
          if (currentDeck!.remaining == 0) {
            gameState[gsPhase] = HoneymoonPhase.bidding;
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
          if (otherPlayer.playedCard != null) {
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
            if (possibleCards.isNotEmpty) {
              // Handle 1
              cardToPlay = possibleCards.lastWhereOrNull((c) => c.rank > rank);
              cardToPlay ??= possibleCards.firstWhere((c) => c.rank < rank);
            } else if (suitContract != Suit.NT) {
              // Handle 2
              cardToPlay =
                  bot.cards.lastWhereOrNull((c) => c.suit == suitContract);

              // Handle 3
              cardToPlay ??=
                  players[1].cards.reduce((a, b) => a.rank < b.rank ? a : b);
            }
          } else {
            // Bot kind of dumb, plays highest card
            cardToPlay =
                players[1].cards.reduce((a, b) => a.rank > b.rank ? a : b);
          }

          playCard(player: bot, card: cardToPlay!);
          await endTurn();
        }
    }
  }
}
