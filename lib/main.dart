import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/game_bloc.dart';
import 'product/home_view.dart';

void main() {
  runApp(const BlackjackApp());
}

class BlackjackApp extends StatelessWidget {
  const BlackjackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blackjack Simulator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => GameBloc()..add(GameStarted()),
        child: BlackjackHomePage(),
      ),
    );
  }
}
