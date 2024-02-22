import 'package:flutter/material.dart';

class ChallengeOpponentPage extends StatefulWidget {
  const ChallengeOpponentPage({super.key});

  @override
  State<ChallengeOpponentPage> createState() => _ChallengeOpponentPageState();
}

class _ChallengeOpponentPageState extends State<ChallengeOpponentPage> {
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
            const Text('Your name:'),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.primary),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.onPrimary),
              ),
              onPressed: () {},
              child: const Text('Challenge Opponent'),
            )
          ],
        ),
      ),
    );
  }
}
