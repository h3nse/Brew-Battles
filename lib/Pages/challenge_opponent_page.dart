import 'dart:math';

import 'package:brew_battles/Global/player.dart';
import 'package:brew_battles/Pages/game_page.dart';
import 'package:brew_battles/views/challenge_opponent_views.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  bool isChallenging = false;
  late RealtimeChannel _duelChannel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Challenge Page'),
      ),
      body: Center(
          child: (!isChallenging)
              ? (Player().opponentName == '')
                  ? MainChallengeView(
                      challengeOpponent: challengeOpponent,
                    )
                  : ChallengeIncomingView(
                      rejectChallenge: rejectChallenge,
                      acceptChallenge: acceptChallenge,
                    )
              : ChallengingView(
                  cancelChallenge: cancelChallenge,
                )),
    );
  }

  @override
  void initState() {
    subscribeToPlayers();
    super.initState();
  }

  void subscribeToPlayers() {
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
            callback: (payload) async {
              final duelId = payload.newRecord['duel_id'];

              // Duel Id only gets set to something other than null if a challenge is incoming.
              // If it gets set to null while you are challenging, that means the opponent has rejected your challenge.
              if (duelId != null) {
                handleIncomingChallenge(duelId);
              } else if (isChallenging) {
                challengeRejected();
              } else {
                challengeCancelled();
              }
            })
        .subscribe();
  }

  void challengeOpponent(String opponentName) async {
    // Check if opponent already has a duel
    final challengedOpponentMap = await supabase
        .from('players')
        .select('id, name, duel_id')
        .eq('name', opponentName)
        .single();

    if (challengedOpponentMap['duel_id'] != null) {
      displaySnackBar('Player already has an opponent', 3);
      return;
    }

    // Challenge
    setState(() {
      isChallenging = true;
    });
    Player().opponentId = challengedOpponentMap['id'];
    Player().opponentName = challengedOpponentMap['name'];

    // Generate duel_id
    final random = Random();
    Player().duelId = random.nextInt(10000);

    // Insert new duel
    await supabase
        .from('duels')
        .insert({'id': Player().duelId, 'gamestate': 'pending'});

    // Set duel_id for both players
    await supabase
        .from('players')
        .update({'duel_id': Player().duelId})
        .eq('id', Player().id)
        .eq('id', Player().opponentId);

    // Subscribe to duels to see if they accept
    subscribeToDuels();
  }

  void subscribeToDuels() {
    _duelChannel = supabase
        .channel('duels')
        .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'duels',
            filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'id',
                value: Player().duelId),
            callback: (payload) async {
              if (payload.newRecord['gamestate'] == 'starting') {
                Player().isManager = true;
                startGame();
              }
            })
        .subscribe();
  }

  void cancelChallenge() async {
    // Delete duel
    await supabase.from('duels').delete().eq('id', Player().duelId);

    // Reset player
    setState(() {
      isChallenging = false;
      Player().opponentName = '';
    });

    // Remove subscription to duel channel
    supabase.removeChannel(_duelChannel);
  }

  void challengeCancelled() {
    displaySnackBar('Challenge has been cancelled', 3);

    Player().opponentId = 0;
    Player().duelId = 0;
    setState(() {
      Player().opponentName = '';
    });
  }

  void handleIncomingChallenge(int duelId) async {
    // Get details of challenger
    final challengerMap = await supabase
        .from('players')
        .select('id, name')
        .eq('duel_id', duelId)
        .neq('id', Player().id)
        .single();
    Player().opponentId = challengerMap['id'];
    Player().duelId = duelId;
    setState(() {
      Player().opponentName = challengerMap['name'];
    });
  }

  void rejectChallenge() async {
    // Delete duel record which sets each player's duel_id to null automatically
    await supabase.from('duels').delete().eq('id', Player().duelId);

    // Reset player
    Player().opponentId = 0;
    Player().duelId = 0;
    setState(() {
      Player().opponentName = '';
    });
  }

  void challengeRejected() {
    displaySnackBar('${Player().opponentName} rejected your challenge', 3);

    // Reset player
    setState(() {
      isChallenging = false;
    });
    Player().opponentId = 0;
    Player().duelId = 0;
    Player().opponentName = '';

    // Remove subscription to duel channel
    supabase.removeChannel(_duelChannel);
  }

  void acceptChallenge() async {
    // set duel state to starting and start game
    await supabase
        .from('duels')
        .update({'gamestate': 'starting'}).eq('id', Player().duelId);
    startGame();
  }

  void startGame() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const GamePage()));
  }

  void displaySnackBar(String message, int seconds) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: seconds),
      ),
    );
  }
}
