import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';
import '../repository/card.dart'; // Import your repository files here

class BlackjackHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blackjack Game'),
      ),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          if (state is GameInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CardsDealt ||
              state is PlayerHitting ||
              state is PlayerStanding) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildDealerContainer(state),
                ),
                Expanded(
                  flex: 4,
                  child: _buildPlayersContainer(state),
                ),
                Expanded(
                  flex: 1,
                  child: _buildActionButtons(context),
                ),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_buildGameOverMessage(state)),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  String _buildGameOverMessage(GameState state) {
    // Build the game over message based on the player scores
    final winner = state.playerScores.indexWhere((score) =>
            score == state.playerScores.reduce((a, b) => a > b ? a : b)) +
        1;
    final message = StringBuffer('Game Over! Scores:\n');
    for (var i = 0; i < state.playerHands.length; i++) {
      message.writeln('Player ${i + 1}: ${state.playerScores[i]}');
    }
    if (state.playerScores.every((score) => score == state.playerScores[0])) {
      message.writeln('Draw');
    } else {
      message.writeln('Winner: Player $winner');
    }

    return message.toString();
  }

  Widget _buildDealerContainer(GameState state) {
    if (state is CardsDealt ||
        state is PlayerHitting ||
        state is PlayerStanding) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dealer Hand', style: TextStyle(fontSize: 20)),
          SizedBox(
            height: 120, // Adjust the height as per your card size and layout
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal, // Horizontal scrolling list
              itemCount: state.dealerHand.length,
              itemBuilder: (context, index) {
                final card = state.dealerHand[index];
                return _buildCard(card);
              },
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildPlayersContainer(GameState state) {
    if (state is CardsDealt ||
        state is PlayerHitting ||
        state is PlayerStanding) {
      return ListView.builder(
        itemCount: state.playerHands.length,
        itemBuilder: (context, i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Player ${i + 1} Hand', style: TextStyle(fontSize: 20)),
              SizedBox(
                height:
                    120, // Adjust the height as per your card size and layout
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Horizontal scrolling list
                  itemCount: state.playerHands[i].length,
                  itemBuilder: (context, index) {
                    final card = state.playerHands[i][index];
                    return _buildCard(card);
                  },
                ),
              ),
              SizedBox(height: 20),
              Text('Score: ${state.playerScores[i]}'),
            ],
          );
        },
      );
    } else {
      return Container();
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Column(
          children: [
            BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                return Text('Round ${state.roundsPlayed}');
              },
            ),
            BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<GameBloc>().add(PlayerHit());
                      },
                      child: Text('Hit'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<GameBloc>().add(PlayerStand());
                      },
                      child: Text('Stand'),
                    ),
                  ],
                );
              },
            ),
            BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                return Text('Current Player: ${state.currentPlayerIndex + 1}');
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(BlackjackCard card) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        children: [
          Text(rankToString(card.rank), style: TextStyle(fontSize: 20)),
          Text(suitToString(card.suit), style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
