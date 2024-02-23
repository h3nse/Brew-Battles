import 'package:brew_battles/Global/player.dart';
import 'package:brew_battles/Managers/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

final supabase = Supabase.instance.client;

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final GameManager gameManager;

  @override
  void initState() {
    super.initState();
    gameManager = Provider.of<GameManager>(context, listen: false);
    subscribeToDuelsTable();
  }

  void subscribeToDuelsTable() {
    supabase
        .channel('duel')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'duels',
          filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'id',
              value: Player().duelId),
          callback: (payload) {
            final data = payload.newRecord;

            if (data['gamestate'] != gameManager.gamestate) {
              gameManager.changeGamestate(data['gamestate']);
            }
          },
        )
        .subscribe();
  }

  void changeGamestate(String gamestate) async {
    gameManager.changeGamestate(gamestate);
    await supabase
        .from('duels')
        .update({'gamestate': gamestate}).eq('id', Player().duelId);
  }

  @override
  Widget build(BuildContext context) {
    Widget view = const Placeholder();
    switch (gameManager.gamestate) {
      case 'starting':
        view = GameStartingView(changeGamestate: changeGamestate);
        break;
      case 'running':
        view = const GameRunningView();
        break;
      case 'ending':
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

class GameStartingView extends StatefulWidget {
  const GameStartingView({super.key, required this.changeGamestate});
  final Function changeGamestate;

  @override
  State<GameStartingView> createState() => _GameStartingViewState();
}

class _GameStartingViewState extends State<GameStartingView> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Countdown(
      seconds: 3,
      build: (BuildContext context, double time) => Text(
        NumberFormat("0", "en_US").format(time).toString(),
        style: const TextStyle(fontSize: 24),
      ),
      onFinished: () {
        widget.changeGamestate('Running');
      },
    ));
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
