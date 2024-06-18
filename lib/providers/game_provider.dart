import 'package:flutter/material.dart';
import 'package:honeymoon_bridge_game/constants.dart';
import 'package:honeymoon_bridge_game/main.dart';
import 'package:honeymoon_bridge_game/models/bid.dart';
import 'package:honeymoon_bridge_game/models/bidding_model.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/models/deck_model.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';
import 'package:honeymoon_bridge_game/models/turn_model.dart';
import 'package:honeymoon_bridge_game/providers/honeymoon_bridge_game_provider.dart';
import 'package:honeymoon_bridge_game/services/deck_service.dart';

class ActionButton {
  final String label;
  final bool enabled;
  final Function() onPressed;

  ActionButton({
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });
}

abstract class GameProvider with ChangeNotifier {
  GameProvider() {
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

  List<ActionButton> additionalButtons = [];

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

  Future<void> setupBoard() async {}

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
      gameState[GS_PHASE] = HoneymoonPhase.play;
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

  void setLastPlayed(CardModel card) {
    gameState[GS_LAST_SUIT] = card.suit;
    gameState[GS_LAST_VALUE] = card.value;

    setTrump(card.suit);

    notifyListeners();
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

  bool canPlayCard(PlayerModel player, CardModel card) {
    if (gameIsOver) return false;
    return _turn.actionCount < 1 && _turn.currentPlayer == player;
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
    var phase = gameState[GS_PHASE];

    if (phase != HoneymoonPhase.selection) {
      return;
    }

    if (_turn.actionCount > 1) {
      return;
    }

    if (_turn.actionCount == 1) {
      await endTurn();
      return;
    }

    // give them to player
    _turn.actionCount += 1;
    player.addCards([card]);

    notifyListeners();
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

  bool get canEndTurn {
    var phase = gameState[GS_PHASE];
    switch (phase) {
      case HoneymoonPhase.selection:
        return turn.actionCount > 0;
      default:
        return false;
    }
  }

  Future<void> endTurn() async {
    await Future.delayed(const Duration(milliseconds: 500));

    var phase = gameState[GS_PHASE];
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
          await Future.delayed(const Duration(milliseconds: 2000));

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

  bool get gameIsOver {
    return currentDeck!.remaining < 1;
  }

  void finishGame() {
    showToast("Game over!");
    notifyListeners();
  }

  Future<void> botTurn() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await drawCards(_turn.currentPlayer);
    await Future.delayed(const Duration(milliseconds: 500));

    if (_turn.currentPlayer.cards.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 1000));

      await playCard(
        player: _turn.currentPlayer,
        card: _turn.currentPlayer.cards.first,
      );
    }

    if (canEndTurn) {
      endTurn();
    }
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
}
