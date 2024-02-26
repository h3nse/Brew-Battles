import 'dart:math';

import 'package:brew_battles/Global/constants.dart';
import 'package:brew_battles/Managers/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class WizardView extends StatefulWidget {
  const WizardView({super.key});

  @override
  State<WizardView> createState() => _WizardViewState();
}

class _WizardViewState extends State<WizardView> {
  late final RealtimeChannel _duelChannel;

  @override
  void initState() {
    final gameManager = Provider.of<GameManager>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gameManager.changePlayerHealth(Constants.initialHealth);
      gameManager.changeOpponentHealth(Constants.initialHealth);
    });

    _duelChannel = supabase.channel('duel');
    _duelChannel
        .onBroadcast(
            event: 'health_update',
            callback: (payload) =>
                updateHealth(gameManager, false, payload['amount']))
        .subscribe();
    _duelChannel.onBroadcast(
        event: 'potion',
        callback: (payload) => handlePotion(gameManager, payload['potionId']));
    super.initState();
  }

  void notifyHealthChange(int amount) {
    _duelChannel.sendBroadcastMessage(
        event: 'health_update', payload: {'amount': amount});
  }

  void notifyPotionThrow(int potionId) {
    _duelChannel
        .sendBroadcastMessage(event: 'potion', payload: {'potionId': potionId});
  }

  void updateHealth(GameManager gameManager, bool self, int amount) {
    if (self) {
      gameManager.changePlayerHealth(
          min(Constants.initialHealth, gameManager.playerHealth + amount));
      notifyHealthChange(amount);
    } else {
      gameManager.changeOpponentHealth(gameManager.opponentHealth + amount);
    }
  }

  void handlePotion(GameManager gameManager, int potion) {
    final effects = Constants.potionEffects[potion];
    for (var effect in effects!) {
      switch (effect[0]) {
        case 'Damage':
          updateHealth(gameManager, true, -effect[1]);
          break;
        case 'Heal':
          updateHealth(gameManager, true, effect[1]);
          break;
      }
    }
  }

  void throwPotion(int potionId) {
    // Add animation etc.
    notifyPotionThrow(potionId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameManager>(
      builder: (context, gameManager, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                if (gameManager.potionState != 'finished') {
                  return;
                }
                handlePotion(gameManager, gameManager.finishedPotion);
                gameManager.emptyPotion();
              },
              child: SizedBox(
                height: 100,
                width: 100,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.purple)),
                  child: Center(
                      child: Column(
                    children: [
                      const Text('Left Wizard'),
                      Text('Health: ${gameManager.playerHealth}')
                    ],
                  )),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (gameManager.potionState != 'finished') {
                  return;
                }
                throwPotion(gameManager.finishedPotion);
                gameManager.emptyPotion();
              },
              child: SizedBox(
                height: 100,
                width: 100,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.purple)),
                  child: Center(
                      child: Column(
                    children: [
                      const Text('Right Wizard'),
                      Text('Health: ${gameManager.opponentHealth}')
                    ],
                  )),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
