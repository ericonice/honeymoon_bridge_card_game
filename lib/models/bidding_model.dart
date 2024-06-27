import 'package:honeymoon_bridge_game/models/bid_model.dart';
import 'package:honeymoon_bridge_game/models/card_model.dart';
import 'package:honeymoon_bridge_game/models/player_model.dart';
import 'package:collection/collection.dart';

const suitBidOrder = [
  Suit.Clubs,
  Suit.Diamonds,
  Suit.Hearts,
  Suit.Spades,
  Suit.NT
];

class BiddingModel {
  final List<PlayerModel> players;
  List<BidModel> bids = [];
  int index;
  PlayerModel currentPlayer;

  BiddingModel({
    required this.players,
    required this.currentPlayer,
    required this.bids,
    this.index = 0,
  });

  bool canBid() {
    return bids.length < 2 || bids.last.pass != true;
  }

  bool canDouble() {
    return bids.lastOrNull?.pass == false;
  }

  BidModel? contract() {
    var lastBid = bids.lastWhereOrNull((b) => b.bidNumber != null);

    return (lastBid == null)
        ? null
        : BidModel(lastBid.player,
            suit: lastBid.suit,
            bidNumber: lastBid.bidNumber,
            double: bids[bids.length - 2].double);
  }

  bool doubled() {
    if (bids.length < 2) {
      return false;
    }

    return bids[bids.length - 2].double;
  }

  void bid(PlayerModel player, BidModel bid) {
    index += 1;
    bids.add(bid);
  }

  bool done() {
    if (bids.length < 2) {
      return false;
    }

    return bids.last.pass == true;
  }

  List<(BidModel?, BidModel?)> getBidRounds() {
    List<(BidModel?, BidModel?)> rounds = [];
    for (int i = 0; i < bids.length; i += 2) {
      final currentBid = bids[i];
      final nextBid = (i + 1 < bids.length) ? bids[i + 1] : null;
      rounds.add((currentBid, nextBid));
    }
    return rounds;
  }

  List<int> getAvailableBidNumbers() {
    var bidNumbers = [1, 2, 3, 4, 5, 6, 7];

    var lastBid = bids.lastWhereOrNull((b) => b.bidNumber != null);

    if (lastBid == null) {
      return bidNumbers;
    }

    var lastBidNumber =
        (lastBid.suit == Suit.NT) ? lastBid.bidNumber! + 1 : lastBid.bidNumber!;
    return bidNumbers.where((n) => n >= lastBidNumber).toList();
  }

  List<Suit> getAvailableSuits(int? bidNumber) {
    if (bidNumber == null) {
      return [];
    }
    var lastBid = bids.lastWhereOrNull((b) => b.bidNumber != null);

    if (lastBid == null || bidNumber > lastBid.bidNumber!) {
      return suitBidOrder;
    }

    return suitBidOrder
        .where((s) => CardModel.suitRank(s) > CardModel.suitRank(lastBid.suit!))
        .toList();
  }

  PlayerModel get otherPlayer {
    return players.firstWhere((p) => p != currentPlayer);
  }
}
