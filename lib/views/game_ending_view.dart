import 'package:brew_battles/Global/player.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class GameEndingView extends StatelessWidget {
  const GameEndingView({super.key, required this.winner});

  final String winner;

  void fullReset() async {
    await supabase.from('duels').delete().eq('id', Player().duelId);
    Player().opponentId = 0;
    Player().opponentName = '';
    Player().duelId = 0;
    Player().isManager = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('$winner Won!'),
          ElevatedButton(
              onPressed: () async {
                await supabase.from('duels').update(
                    {'gamestate': 'starting'}).eq('id', Player().duelId);
              },
              child: const Text('Play Again')),
          ElevatedButton(
              onPressed: () {
                fullReset();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Back to Menu'))
        ]),
      ),
    );
  }
}
