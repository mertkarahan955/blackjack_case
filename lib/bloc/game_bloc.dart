import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../repository/card.dart';
import '../repository/deck.dart';
import '../repository/enums.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  Deck deck = Deck();
  List<List<BlackjackCard>> playerHands = [];
  List<BlackjackCard> dealerHand = [];
  List<int> playerScores = [];
  int dealerScore = 0;
  List<bool> playerStandStates = [];
  int roundsPlayed = 0;
  int currentPlayerIndex = 0;
  bool roundOver = false;
  int numberOfPlayers = 2;

  GameBloc()
      : super(GameInitial(
          playerHands: const [],
          playerScores: const [],
          roundsPlayed: 0,
          playerHand: const [],
          dealerHand: const [],
          currentPlayerIndex: 0,
        )) {
    on<GameStarted>(_onGameStarted);
    on<PlayerHit>(_onPlayerHit);
    on<PlayerStand>(_onPlayerStand);
    on<EndRound>(_onEndRound);
    on<EndGame>(_onEndGame);
  }

  void _onGameStarted(GameStarted event, Emitter<GameState> emit) {
    if (deck.isEmpty || deck.cards.length < 8) {
      emit(GameOver(
          playerHands: playerHands,
          playerScores: playerScores,
          roundsPlayed: roundsPlayed,
          playerHand: playerHands[currentPlayerIndex],
          dealerHand: dealerHand,
          currentPlayerIndex: currentPlayerIndex));
    }
    print(event);
    _startNewRound(emit);

    if (calculateHandValue(dealerHand) == 21) {
      emit(RoundEnded(
          playerHands: playerHands,
          playerScores: playerScores,
          roundsPlayed: roundsPlayed,
          playerHand: playerHands[currentPlayerIndex],
          dealerHand: dealerHand,
          currentPlayerIndex: currentPlayerIndex));
    }
  }

  void _onPlayerHit(PlayerHit event, Emitter<GameState> emit) {
    playerHit();
    print(event);
    print(
        ' ${currentPlayerIndex + 1} ${playerHands[currentPlayerIndex].toString()}');

    while (calculateHandValue(playerHands[currentPlayerIndex]) < 21) {
      emit(PlayerHitting(
        playerHand: playerHands[currentPlayerIndex],
        dealerHand: dealerHand,
        roundsPlayed: roundsPlayed,
        playerScores: playerScores,
        playerHands: playerHands,
        currentPlayerIndex: currentPlayerIndex,
      ));
      break;
    }
  }

  void _onPlayerStand(PlayerStand event, Emitter<GameState> emit) {
    playerStand();

    if (allPlayersStand()) {
      dealerHit();
      determineWinner();
      emit(RoundEnded(
        playerHands: playerHands,
        playerScores: playerScores,
        roundsPlayed: roundsPlayed,
        playerHand: playerHands[currentPlayerIndex],
        dealerHand: dealerHand,
        currentPlayerIndex: currentPlayerIndex,
      ));
      _startNewRound(emit);
    } else {
      emit(PlayerStanding(
        playerHand: playerHands[currentPlayerIndex],
        dealerHand: dealerHand,
        roundsPlayed: roundsPlayed,
        playerScores: playerScores,
        playerHands: playerHands,
        currentPlayerIndex: currentPlayerIndex,
      ));
    }
  }

  void _onEndRound(EndRound event, Emitter<GameState> emit) {
    print(event);
    emit(RoundEnded(
      currentPlayerIndex: currentPlayerIndex,
      playerHand: playerHands[currentPlayerIndex],
      dealerHand: dealerHand,
      playerHands: playerHands,
      playerScores: playerScores,
      roundsPlayed: roundsPlayed,
    ));

    _startNewRound(emit);
    print(emit);
  }

  void _onEndGame(EndGame event, Emitter<GameState> emit) {
    emit(GameOver(
      currentPlayerIndex: currentPlayerIndex,
      playerHands: playerHands,
      dealerHand: dealerHand,
      playerHand: playerHands[currentPlayerIndex],
      playerScores: playerScores,
      roundsPlayed: roundsPlayed,
    ));
  }

  void _startNewRound(Emitter<GameState> emit) {
    print(deck.cards.length);
    if (deck.isEmpty) {
      emit(GameOver(
        currentPlayerIndex: currentPlayerIndex,
        playerHands: playerHands,
        dealerHand: dealerHand,
        playerHand: playerHands[currentPlayerIndex],
        playerScores: playerScores,
        roundsPlayed: roundsPlayed,
      ));
    } else {
      playerHands.clear();

      playerStandStates.clear();
      dealerHand.clear();
      roundsPlayed++;
      currentPlayerIndex = 0;
      roundOver = false;

      for (int i = 0; i < numberOfPlayers; i++) {
        playerHands.add([]);
        playerScores.add(0);
        playerStandStates.add(false);
      }

      dealInitialCards();

      emit(CardsDealt(
        playerHands: playerHands,
        dealerHand: dealerHand,
        currentPlayerIndex: currentPlayerIndex,
        playerScores: playerScores,
        roundsPlayed: roundsPlayed,
        playerHand: playerHands[currentPlayerIndex],
      ));
    }
  }

  void dealInitialCards() {
    for (int i = 0; i < playerHands.length; i++) {
      playerHands[i] = [deck.drawCard(), deck.drawCard()];
    }
    dealerHand = [deck.drawCard(), deck.drawCard()];
  }

  void playerHit() {
    playerHands[currentPlayerIndex].add(deck.drawCard());
  }

  void dealerHit() {
    while (calculateHandValue(dealerHand) < 17) {
      dealerHand.add(deck.drawCard());
      print(dealerHand.toString());
    }
  }

  void playerStand() {
    playerStandStates[currentPlayerIndex] = true;
    if (currentPlayerIndex < playerHands.length - 1) {
      currentPlayerIndex++;
    }
  }

  bool allPlayersStand() {
    return playerStandStates.every((stand) => stand);
  }

  void determineWinner() {
    int dealerValue = calculateHandValue(dealerHand);

    for (int i = 0; i < playerHands.length; i++) {
      int playerValue = calculateHandValue(playerHands[i]);
      if (playerValue <= 21 && playerValue > dealerValue) {
        playerScores[i]++;
      } else if (dealerValue < 21 &&
          playerValue <= 21 &&
          playerValue > dealerValue) {
        playerScores[i]++;
      } else {
        if (playerValue <= 21 && playerHands[i].length < dealerHand.length) {
          playerScores[i]++;
        } else {
          dealerScore++;
        }
      }

      print('Player ${i + 1} score: ${playerScores[i]}');
    }
  }

  int calculateHandValue(List<BlackjackCard> hand) {
    int value = 0;
    int acesCount = 0;

    for (var card in hand) {
      if (card.rank == Rank.ace) {
        acesCount++;
        value += 11;
      } else {
        value += card.value;
      }
    }

    while (value > 21 && acesCount > 0) {
      value -= 10;
      acesCount--;
    }

    return value;
  }
}
