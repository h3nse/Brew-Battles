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
  int challengedPlayerId = 0;
  bool challenging = false;
  late RealtimeChannel opponentChannel;

  @override
  void initState() {
    super.initState();
    supabase
        .channel('player')
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

  cancelChallenge(String cancellationMessage) {
    setState(() {
      challenging = false;
    });

    supabase.removeChannel(opponentChannel);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cancellationMessage),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void rejectChallenge() {}

  Future challengeOpponent(String opponentName) async {
    final challengedPlayer = await supabase
        .from('players')
        .select('id, opponent_id')
        .eq('name', opponentName)
        .single();
    if (challengedPlayer['opponent_id'] != null) {
      throw BusyOpponentException('Player already has an opponent');
    }
    setState(() {
      challenging = true;
    });
    challengedPlayerId = challengedPlayer['id'];
    await supabase
        .from('players')
        .update({'opponent_id': Player().id}).eq('name', opponentName);
    opponentChannel = supabase
        .channel('opponent')
        .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'players',
            filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'id',
                value: challengedPlayer['id']),
            callback: (payload) {
              if (payload.newRecord['opponent_id'] == null && challenging) {
                cancelChallenge('Opponent rejected your challenge');
              }
            })
        .subscribe();
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
            !challenging
                ? ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primary),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.onPrimary),
                    ),
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
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
                : const Text('Waiting for opponent to accept...'),
            challenging
                ? ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primary),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.onPrimary),
                    ),
                    onPressed: () async {
                      cancelChallenge('Challenge cancelled');
                      await supabase.from('players').update(
                          {'opponent_id': null}).eq('id', challengedPlayerId);
                    },
                    child: const Text('cancel'))
                : Container()
          ],
        ),
      ),
    );
  }
}
