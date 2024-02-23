import 'package:brew_battles/Global/player.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

enum GameState { starting, running, ending }

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  GameState gameState = GameState.starting;

  @override
  void initState() {
    super.initState();
    subscribeToDuelsTable();
  }

  void subscribeToDuelsTable() {}

  @override
  Widget build(BuildContext context) {
    Widget view = const Placeholder();
    switch (gameState) {
      case GameState.starting:
        break;
      case GameState.running:
        view = const GameRunningView();
      case GameState.ending:
        break;
    }
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(child: view),
      ),
    );
  }
}

class GameRunningView extends StatelessWidget {
  const GameRunningView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [Text(Player().name), Text(Player().opponentName)],
    );
  }
}
