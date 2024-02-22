import 'package:brew_battles/Global/exceptions.dart';
import 'package:brew_battles/Global/player.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ChallengeOpponentPage extends StatefulWidget {
  const ChallengeOpponentPage({super.key});

  @override
  State<ChallengeOpponentPage> createState() => _ChallengeOpponentPageState();
}

class _ChallengeOpponentPageState extends State<ChallengeOpponentPage> {
  final opponentInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    supabase
        .channel('public:players')
        .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'players',
            filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'id',
                value: Player().id),
            callback: (payload) {})
        .subscribe();
  }

  @override
  void dispose() {
    super.dispose();
    opponentInputController.dispose();
  }

  Future challengeOpponent(String opponentName) async {
    final playersOpponentId = await supabase
        .from('players')
        .select('opponent_id')
        .eq('name', opponentName)
        .single();

    if (playersOpponentId['opponent_id'] != null) {
      throw BusyOpponentException('Player already has an opponent');
    }

    await supabase
        .from('players')
        .update({'opponent_id': Player().id}).eq('name', opponentName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Challenge Opponent Page'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Hello ${Player().name}!'),
            TextFormField(
              controller: opponentInputController,
              decoration:
                  const InputDecoration(labelText: ("Enter an opponents name")),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.primary),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.onPrimary),
              ),
              onPressed: () async {
                String attemptedOpponent = opponentInputController.text;
                try {
                  await challengeOpponent(attemptedOpponent);
                } on BusyOpponentException {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Player already has an opponent or is being challenged by another player"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Couldn't find your opponent"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              child: const Text('Challenge Opponent'),
            )
          ],
        ),
      ),
    );
  }
}
