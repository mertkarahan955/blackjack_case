part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  final List<BlackjackCard> playerHand;
  final List<BlackjackCard> dealerHand;
  final int currentPlayerIndex;
  final List<List<BlackjackCard>> playerHands;

  final List<int> playerScores;
  final int roundsPlayed;

  GameState({
    required this.playerHands,
    required this.playerScores,
    required this.roundsPlayed,
    required this.playerHand,
    required this.dealerHand,
    required this.currentPlayerIndex,
  });

  @override
  List<Object> get props => [];
}

final class GameInitial extends GameState {
  GameInitial(
      {required super.playerHands,
      required super.playerScores,
      required super.roundsPlayed,
      required super.playerHand,
      required super.dealerHand,
      required super.currentPlayerIndex});
}

final class CardsDealt extends GameState {
  CardsDealt(
      {required super.playerHands,
      required super.playerScores,
      required super.roundsPlayed,
      required super.playerHand,
      required super.dealerHand,
      required super.currentPlayerIndex});

  @override
  List<Object> get props => [playerHands, dealerHand, currentPlayerIndex];
}

final class PlayerHitting extends GameState {
  PlayerHitting(
      {required super.playerHands,
      required super.playerScores,
      required super.roundsPlayed,
      required super.playerHand,
      required super.dealerHand,
      required super.currentPlayerIndex});

  @override
  List<Object> get props => [playerHand, dealerHand, currentPlayerIndex];
}

class PlayerStanding extends GameState {
  PlayerStanding(
      {required super.playerHands,
      required super.playerScores,
      required super.roundsPlayed,
      required super.playerHand,
      required super.dealerHand,
      required super.currentPlayerIndex});

  @override
  List<Object> get props => [playerHands, dealerHand, currentPlayerIndex];
}

class RoundEnded extends GameState {
  RoundEnded(
      {required super.playerHands,
      required super.playerScores,
      required super.roundsPlayed,
      required super.playerHand,
      required super.dealerHand,
      required super.currentPlayerIndex});

  @override
  List<Object> get props =>
      [playerHands, dealerHand, playerScores, roundsPlayed];
}

class GameOver extends GameState {
  GameOver(
      {required super.playerHands,
      required super.playerScores,
      required super.roundsPlayed,
      required super.playerHand,
      required super.dealerHand,
      required super.currentPlayerIndex});

  @override
  List<Object> get props => [playerScores, roundsPlayed, currentPlayerIndex];
}
