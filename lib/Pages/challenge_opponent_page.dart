import 'dart:math';

import 'package:brew_battles/Global/exceptions.dart';
import 'package:brew_battles/Global/player.dart';
import 'package:brew_battles/Pages/game_page.dart';
import 'package:brew_battles/views/challenge_opponent_views.dart';
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
  String challengedPlayerName = '';
  bool isChallenging = false;
  late RealtimeChannel opponentChannel;
  String challengerName = '';
  int challengerId = 0;

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
            callback: (payload) async {
              final data = payload.newRecord;

              // If your duelId gets changed while you're challenging, call challenge accepted
              if (data['duel_id'] != null && isChallenging) {
                challengeAccepted();
              }
              // If your duelId gets changed while you're not challenging, switch screen to game_page
              if (data['duel_id'] != null) {
                changeToGamePage();
              }
              // If your opponentID gets set to null, set challengerName to an empty string
              if (data['opponent_id'] == null) {
                setState(() {
                  challengerName = '';
                });
                return;
              }
              // If your opponentID gets changed while not challenging, set challengerName and Id to the name and Id of the opponent
              else if (!isChallenging) {
                final challengerMap = await supabase
                    .from('players')
                    .select('id, name')
                    .eq('id', data['opponent_id'])
                    .single();
                challengerId = challengerMap['id'];
                setState(() {
                  challengerName = challengerMap['name'];
                });
              }
              // If your opponentID gets changed while challenging, deny the challenge by setting your opponentId to null
              else {
                await denyIncomingChallenge();
              }
            })
        .subscribe();
  }

  void changeToGamePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const GamePage()));
  }

  Future<void> denyIncomingChallenge() async {
    await supabase
        .from('players')
        .update({'opponent_id': null}).eq('id', Player().id);
  }

  @override
  void dispose() {
    super.dispose();
    opponentInputController.dispose();
  }

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
      isChallenging = true;
    });
    challengedPlayerId = challengedPlayer['id'];
    challengedPlayerName = opponentName;
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
              if (payload.newRecord['opponent_id'] == null && isChallenging) {
                cancelChallenge('Opponent rejected your challenge');
              }
            })
        .subscribe();
  }

  void cancelChallenge(String cancellationMessage) {
    setState(() {
      isChallenging = false;
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

  void rejectChallenge() async {
    await supabase
        .from('players')
        .update({'opponent_id': null}).eq('id', Player().id);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Challenge rejected'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void acceptChallenge() async {
    final random = Random();
    final duelId = random.nextInt(10000);

    Player().opponentId = challengerId;
    Player().opponentName = challengerName;
    Player().duelId = duelId;

    await supabase.from('duels').insert({'id': duelId});

    await supabase
        .from('players')
        .update({'duel_id': duelId}).eq('id', Player().id);

    await supabase.from('players').update(
        {'opponent_id': Player().id, 'duel_id': duelId}).eq('id', challengerId);
  }

  void challengeAccepted() async {
    Player().opponentId = challengedPlayerId;
    Player().opponentName = challengedPlayerName;

    if (context.mounted) {
      changeToGamePage();
    }
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
          child: (challengerName == '')
              ? MainView(
                  opponentInputController: opponentInputController,
                  isChallenging: isChallenging,
                  challengeOpponent: challengeOpponent,
                  cancelChallenge: cancelChallenge,
                  challengedPlayerId: challengedPlayerId)
              : IncomingChallengeView(
                  challengerName: challengerName,
                  rejectChallenge: rejectChallenge,
                  acceptChallenge: acceptChallenge)),
    );
  }
}
