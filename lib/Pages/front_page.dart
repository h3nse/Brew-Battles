import 'dart:math';

import 'package:brew_battles/Global/constants.dart';
import 'package:brew_battles/Pages/challenge_opponent_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class FrontPage extends StatelessWidget {
  const FrontPage({
    super.key,
  });

  String _generateName() {
    Random random = Random();
    final firstWordList = Constants.randomWords['first words'];
    final secondWordList = Constants.randomWords['second words'];
    final name =
        '${firstWordList![random.nextInt(firstWordList.length)]}${secondWordList![random.nextInt(secondWordList.length)]}';
    return name;
  }

  void _addPlayer() async {
    final name = _generateName();
    await supabase.from('players').insert({'name': name});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Front Page'),
      ),
      body: Center(
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primary),
              foregroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.onPrimary),
            ),
            onPressed: () {
              _addPlayer();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChallengeOpponentPage()));
            },
            child: const Text('Play')),
      ),
    );
  }
}
