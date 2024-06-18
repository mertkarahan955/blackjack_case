import 'dart:math';
import 'package:blackjack_case/repository/card.dart';
import 'enums.dart';

class Deck {
  final List<BlackjackCard> _cards = [];

  static final Deck _singleton = Deck._internal();

  factory Deck() {
    return _singleton;
  }

  Deck._internal() {
    _initializeDeck();
  }

  get cards => _cards;
  void _initializeDeck() {
    _cards.clear();

    for (var suit in Suit.values) {
      for (var rank in Rank.values) {
        _cards.add(BlackjackCard(suit, rank, _getCardValue(rank)));
      }
    }
    _shuffleDeck();
  }

  void _shuffleDeck() {
    _cards.shuffle(Random());
  }

  BlackjackCard drawCard() {
    return _cards.removeLast();
  }

  bool get isEmpty => _cards.isEmpty;

  int _getCardValue(Rank rank) {
    switch (rank) {
      case Rank.jack:
        return 10;
      case Rank.queen:
        return 10;
      case Rank.king:
        return 10;
      case Rank.ace:
        return 11;
      default:
        return rank.index + 2;
    }
  }
}
