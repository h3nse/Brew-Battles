import 'package:brew_battles/Global/player.dart';
import 'package:brew_battles/Managers/game_manager.dart';
import 'package:brew_battles/views/game_ending_view.dart';
import 'package:brew_battles/views/game_running_view.dart';
import 'package:brew_battles/views/game_starting_view.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

final supabase = Supabase.instance.client;

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();
    subscribeToDuelsTable();
  }

  void subscribeToDuelsTable() {
    final GameManager gameManager =
        Provider.of<GameManager>(context, listen: false);
    supabase
        .channel('gamestate')
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
    await supabase
        .from('duels')
        .update({'gamestate': gamestate}).eq('id', Player().duelId);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(body: Consumer<GameManager>(
        builder: (context, gameManager, child) {
          Widget view = const Placeholder();
          switch (gameManager.gamestate) {
            case 'starting':
              view = GameStartingView(changeGamestate: changeGamestate);
              break;
            case 'running':
              view = const GameRunningView();
              break;
            case 'ending':
              view = GameEndingView(winner: gameManager.winner);
              break;
          }
          return view;
        },
      )),
    );
  }
}
