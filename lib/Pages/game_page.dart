import 'package:brew_battles/Global/player.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String gameState = 'starting';

  @override
  void initState() {
    super.initState();
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

            if (data['gamestate'] != gameState) {
              setState(() {
                gameState = data['gamestate'];
              });
            }
          },
        )
        .subscribe();
  }

  @override
  Widget build(BuildContext context) {
    Widget view = const Placeholder();
    switch (gameState) {
      case 'starting':
        break;
      case 'running':
        view = const GameRunningView();
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
