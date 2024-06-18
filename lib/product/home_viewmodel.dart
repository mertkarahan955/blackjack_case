// import 'package:flutter/material.dart';

// import '../logic/game.dart';
// import 'home_view.dart';

// abstract class HomeViewModel extends State<BlackjackHomePage> {
//   BlackjackGame game = BlackjackGame(2);

//   @override
//   void initState() {
//     super.initState();
//   }

//   void playerHit() {
//     setState(() {
//       game.playerHit();
//       if (game.calculateHandValue(game.playerHands[game.currentPlayerIndex]) >
//           21) {
//         playerStand();
//       }
//     });
//   }

//   void playerStand() {
//     setState(() {
//       game.playerStand();

//       if (!game.isGameOver) {
//         game.resetForNextRound();
//       }
//     });
//   }

//   void endRound() {
//     game.determineWinner();
//     if (!game.isGameOver) {
//       game.dealInitialCards();
//     }
//   }
// }
