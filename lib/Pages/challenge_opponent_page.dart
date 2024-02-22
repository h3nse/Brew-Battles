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
  static const snackBar = SnackBar(
    content: Text("Couldn't find your opponent"),
  );

  @override
  void dispose() {
    super.dispose();
    opponentInputController.dispose();
  }

  Future challengeOpponent(String opponentName) async {
    await supabase
        .from('players')
        .select('name')
        .eq('name', opponentName)
        .single();
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
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
