import 'package:brew_battles/Global/player.dart';
import 'package:flutter/material.dart';

class MainChallengeView extends StatelessWidget {
  MainChallengeView({super.key, required this.challengeOpponent});
  final TextEditingController inputFieldController = TextEditingController();
  final Function challengeOpponent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Hello ${Player().name}!'),
        TextFormField(
          controller: inputFieldController,
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
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            challengeOpponent(inputFieldController.text);
          },
          child: const Text('Challenge Opponent'),
        )
      ],
    );
  }
}

class ChallengingView extends StatelessWidget {
  const ChallengingView({super.key, required this.cancelChallenge});
  final Function cancelChallenge;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Waiting for opponent to accept...'),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).colorScheme.primary),
            foregroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).colorScheme.onPrimary),
          ),
          onPressed: () async {
            cancelChallenge();
          },
          child: const Text('cancel'),
        )
      ],
    );
  }
}

class ChallengeIncomingView extends StatelessWidget {
  const ChallengeIncomingView(
      {super.key,
      required this.rejectChallenge,
      required this.acceptChallenge});
  final Function rejectChallenge;
  final Function acceptChallenge;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${Player().opponentName} has challenged you!'),
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
