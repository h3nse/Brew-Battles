import 'dart:async';
import 'dart:math';

import 'package:brew_battles/Global/constants.dart';
import 'package:brew_battles/Global/player.dart';
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
  bool playerDead = false;
  bool opponentDead = false;

  @override
  void initState() {
    final gameManager = Provider.of<GameManager>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gameManager.setPlayerHealth(Constants.initialHealth);
      gameManager.setOpponentHealth(Constants.initialHealth);
    });

    _duelChannel = supabase.channel('update');
    _duelChannel
        .onBroadcast(
            event: 'health_update',
            callback: (payload) =>
                updateHealth(gameManager, false, payload['health']))
        .subscribe();
    _duelChannel.onBroadcast(
        event: 'potion',
        callback: (payload) => handlePotion(gameManager, payload['potionId']));
    _duelChannel.onBroadcast(
        event: 'death', callback: (payload) => wizardDied(false));
    super.initState();
  }

  void notifyHealthChange(int health) {
    _duelChannel.sendBroadcastMessage(
        event: 'health_update', payload: {'health': health});
  }

  void notifyPotionThrow(int potionId) {
    _duelChannel
        .sendBroadcastMessage(event: 'potion', payload: {'potionId': potionId});
  }

  void notifyDeath() {
    _duelChannel.sendBroadcastMessage(event: 'death', payload: {});
  }

  void updateHealth(GameManager gameManager, bool self, int health) {
    if (self) {
      final newHealth = max(
          0,
          min(Constants.initialHealth,
              health)); // Limit health between 0 and initial health
      gameManager.changePlayerHealth(newHealth);
      notifyHealthChange(newHealth);
      if (newHealth == 0) {
        wizardDied(true);
      }
    } else {
      gameManager.setOpponentHealth(health);
    }
  }

  void handlePotion(GameManager gameManager, int potion) {
    // final effects = Constants.potionEffects[potion];
    // for (var effect in effects!) {
    //   switch (effect[0]) {
    //     case 'Damage':
    //       updateHealth(gameManager, true,
    //           (gameManager.playerHealth - effect[1]).toInt());
    //       break;
    //     case 'Heal':
    //       updateHealth(gameManager, true,
    //           (gameManager.playerHealth + effect[1]).toInt());
    //       break;
    //   }
    // }
  }

  void throwPotion(int potionId) {
    // Add animation etc.
    notifyPotionThrow(potionId);
  }

  void wizardDied(bool self) {
    String winner;
    if (self) {
      notifyDeath();
      winner = Player().opponentName;
      setState(() {
        playerDead = true;
      });
    } else {
      winner = Player().name;
      setState(() {
        opponentDead = true;
      });
    }
    Provider.of<GameManager>(context, listen: false).changeWinner(winner);
    Timer(const Duration(seconds: Constants.endDurationSec), () {
      endGame();
    });
  }

  void endGame() async {
    final gameManager = Provider.of<GameManager>(context, listen: false);
    gameManager.emptyPotion();

    if (Player().isManager) {
      await supabase
          .from('duels')
          .update({'gamestate': 'ending'}).eq('id', Player().duelId);
    }
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
                      child: (!playerDead)
                          ? Column(
                              children: [
                                const Text('Left Wizard'),
                                Text('Health: ${gameManager.playerHealth}')
                              ],
                            )
                          : const Text('Dead')),
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
                      child: (!opponentDead)
                          ? Column(
                              children: [
                                const Text('Right Wizard'),
                                Text('Health: ${gameManager.opponentHealth}')
                              ],
                            )
                          : const Text('Dead')),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
