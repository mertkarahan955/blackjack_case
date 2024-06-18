import 'package:blackjack_case/repository/enums.dart';

class BlackjackCard {
  final Suit suit;
  final Rank rank;
  final int value;

  BlackjackCard(this.suit, this.rank, this.value);

  @override
  String toString() {
    return '${rankToString(rank)} of ${suitToString(suit)}';
  }
}

String suitToString(Suit suit) {
  switch (suit) {
    case Suit.hearts:
      return 'Hearts';
    case Suit.diamonds:
      return 'Diamonds';
    case Suit.clubs:
      return 'Clubs';
    case Suit.spades:
      return 'Spades';
  }
}

String rankToString(Rank rank) {
  switch (rank) {
    case Rank.two:
      return '2';
    case Rank.three:
      return '3';
    case Rank.four:
      return '4';
    case Rank.five:
      return '5';
    case Rank.six:
      return '6';
    case Rank.seven:
      return '7';
    case Rank.eight:
      return '8';
    case Rank.nine:
      return '9';
    case Rank.ten:
      return '10';
    case Rank.jack:
      return 'J';
    case Rank.queen:
      return 'Q';
    case Rank.king:
      return 'K';
    case Rank.ace:
      return 'A';
  }
}
