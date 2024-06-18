enum Suit {
  hearts,
  diamonds,
  clubs,
  spades,
}

enum Rank {
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
  ace,
}

// extension SuitExtension on Suit {
//   String get name {
//     switch (this) {
//       case Suit.hearts:
//         return 'hearts';
//       case Suit.diamonds:
//         return 'diamonds';
//       case Suit.clubs:
//         return 'clubs';
//       case Suit.spades:
//         return 'spades';
//     }
//   }
// }