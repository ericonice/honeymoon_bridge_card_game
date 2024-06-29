// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum Suit {
  Spades,
  Hearts,
  Clubs,
  Diamonds,
  NT,
}

class CardModel {
  final String image;
  final Suit suit;
  final String value;
  late int rank;

  CardModel({
    required this.image,
    required this.suit,
    required this.value,
  })
  {
    rank = _getNumericValue();
  }

  int _getNumericValue() {
    switch (value) {
      case "2":
        return 2;
      case "3":
        return 3;
      case "4":
        return 4;
      case "5":
        return 5;
      case "6":
        return 6;
      case "7":
        return 7;
      case "8":
        return 8;
      case "9":
        return 9;
      case "10":
        return 10;
      case "JACK":
        return 11;
      case "QUEEN":
        return 12;
      case "KING":
        return 13;
      case "ACE":
        return 14;
      default:
        throw Exception("unknown card value");
    }
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      image: json['image'],
      suit: stringToSuit(json['suit']),
      value: json['value'],
    );
  }

  static Suit stringToSuit(String suit) {
    switch (suit.toUpperCase().trim()) {
      case "HEARTS":
        return Suit.Hearts;
      case "CLUBS":
        return Suit.Clubs;
      case "DIAMONDS":
        return Suit.Diamonds;
      case "SPADES":
        return Suit.Spades;
      default:
        return Suit.NT;
    }
  }

  static String suitToString(Suit suit) {
    switch (suit) {
      case Suit.Hearts:
        return "Hearts";
      case Suit.Clubs:
        return "Clubs";
      case Suit.Diamonds:
        return "Diamonds";
      case Suit.Spades:
        return "Spades";
      case Suit.NT:
        return "NT";
    }
  }

  static String suitToUnicode(Suit suit) {
    switch (suit) {
      case Suit.Hearts:
        return "\u2665";
      case Suit.Clubs:
        return "\u2663";
      case Suit.Diamonds:
        return "\u2666";
      case Suit.Spades:
        return "\u2660";
      case Suit.NT:
        return "NT";
    }
  }

  static Color suitToColor(Suit? suit) {
    switch (suit) {
      case Suit.Hearts:
      case Suit.Diamonds:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

    static int suitRank(Suit suit) {
    switch (suit) {
      case Suit.Clubs:
        return 1;
      case Suit.Diamonds:
        return 2;
      case Suit.Hearts:
        return 3;
      case Suit.Spades:
        return 4;
      case Suit.NT:
        return 5;
    }
  }

    @override
  String toString() {
    return "$value${suitToUnicode(suit)}";
  }


}
