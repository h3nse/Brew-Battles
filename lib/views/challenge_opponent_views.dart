import 'package:brew_battles/Global/exceptions.dart';
import 'package:brew_battles/Global/player.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class MainView extends StatelessWidget {
  const MainView(
      {super.key,
      required this.opponentInputController,
      required this.isChallenging,
      required this.challengeOpponent,
      required this.cancelChallenge,
      required this.challengedPlayerId});
  final TextEditingController opponentInputController;
  final bool isChallenging;
  final Function challengeOpponent;
  final Function cancelChallenge;
  final int challengedPlayerId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Hello ${Player().name}!'),
        TextFormField(
          controller: opponentInputController,
          decoration:
              const InputDecoration(labelText: ("Enter an opponents name")),
        ),
        !isChallenging
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
        isChallenging
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
    );
  }
}

class IncomingChallengeView extends StatelessWidget {
  const IncomingChallengeView(
      {super.key,
      required this.challengerName,
      required this.rejectChallenge,
      required this.acceptChallenge});
  final String challengerName;
  final Function rejectChallenge;
  final Function acceptChallenge;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$challengerName has challenged you!'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.onPrimary),
                ),
                onPressed: () {
                  rejectChallenge();
                },
                child: const Text('Reject')),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.onPrimary),
                ),
                onPressed: () {
                  acceptChallenge();
                },
                child: const Text('Accept'))
          ],
        )
      ],
    );
  }
}
