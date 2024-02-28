import 'dart:async';

import 'package:brew_battles/Global/constants.dart';
import 'package:brew_battles/Managers/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class NewWizardView extends StatefulWidget {
  const NewWizardView({super.key});

  @override
  State<NewWizardView> createState() => _NewWizardViewState();
}

class _NewWizardViewState extends State<NewWizardView> {
  late final RealtimeChannel _duelChannel;
  bool playerDead = false;
  bool opponentDead = false;
  int damageMultiplier = 1;
  int healMultiplier = 1;
  List ongoingEffects = [];

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
                drinkPotion(gameManager.finishedPotion);
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
                                const Text('You'),
                                Text('Health: ${gameManager.playerHealth}'),
                                (!(gameManager.playerActionText == ''))
                                    ? Text(gameManager.playerActionText)
                                    : Container()
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
                                const Text('Opponent'),
                                Text('Health: ${gameManager.opponentHealth}'),
                                (!(gameManager.opponentActionText == ''))
                                    ? Text(gameManager.opponentActionText)
                                    : Container()
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

  @override
  void initState() {
    final gameManager = Provider.of<GameManager>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gameManager.setPlayerHealth(Constants.initialHealth);
      gameManager.setOpponentHealth(Constants.initialHealth);
    });
    _duelChannel = supabase.channel('updates').subscribe();
    _duelChannel.onBroadcast(
        event: 'health_update',
        callback: (payload) =>
            gameManager.setOpponentHealth(payload['health']));
    _duelChannel.onBroadcast(
        event: 'potion_update',
        callback: (payload) => {
              if (payload['isThrown'])
                {
                  Provider.of<GameManager>(context, listen: false)
                      .setOpponentActionText(
                          'threw ${Constants.idToPotions[payload['potionId']]!}')
                }
              else
                {
                  Provider.of<GameManager>(context, listen: false)
                      .setOpponentActionText(
                          'drank ${Constants.idToPotions[payload['potionId']]!}')
                }
            });
    super.initState();
  }

  /// Potion Application
  void drinkPotion(int potionId) {
    // Replace with animation
    Provider.of<GameManager>(context, listen: false)
        .setPlayerActionText('drank ${Constants.idToPotions[potionId]!}');

    applyPotion(potionId);
    notifyPotionAction(potionId, false);
  }

  void throwPotion(int potionId) {
    // Replace with animation
    Provider.of<GameManager>(context, listen: false)
        .setPlayerActionText('threw ${Constants.idToPotions[potionId]!}');

    notifyPotionAction(potionId, true);
  }

  void applyPotion(int potionId) {
    switch (potionId) {
      case 1:
        heal(Constants.potionEffectValues[potionId]!['Heal']!);
        break;
      case 2:
        takeDamage(Constants.potionEffectValues[potionId]!['Damage']!);
        break;
      case 3:
        createPeriodicEffect(
          'Burning',
          Constants.potionEffectValues[potionId]!['TickSpeed']!,
          Constants.potionEffectValues[potionId]!['TickAmount']!,
          () => takeDamage(
              Constants.potionEffectValues[potionId]!['TickDamage']!),
        );
        break;
    }
  }

  /// Notifying the other player
  void notifyPotionAction(int potionId, bool isThrown) {
    _duelChannel.sendBroadcastMessage(
        event: 'potion_update',
        payload: {'potionId': potionId, 'isThrown': isThrown});
  }

  void notifyEffect(effect) {}

  void notifyHealth(int health) {
    _duelChannel.sendBroadcastMessage(
        event: 'health_update', payload: {'health': health});
  }

  void notifyDeath() {}

  /// Effects
  void takeDamage(int amount) {
    amount = amount * damageMultiplier;
    Provider.of<GameManager>(context, listen: false)
        .changePlayerHealth(-amount);
    notifyHealth(Provider.of<GameManager>(context, listen: false).playerHealth);
  }

  void heal(int amount) {
    amount = amount * healMultiplier;
    Provider.of<GameManager>(context, listen: false).changePlayerHealth(amount);
    notifyHealth(Provider.of<GameManager>(context, listen: false).playerHealth);
  }

  void createPeriodicEffect(
      String effect, int tickSpeed, int tickAmount, Function onTimeout) {
    removeOngoingEffect(effect);
    int tickCount = 0;
    final timer = Timer.periodic(
      Duration(seconds: tickSpeed),
      (timer) {
        if (tickCount == tickAmount) {
          removeOngoingEffect(effect);
          return;
        }
        onTimeout();
        tickCount += 1;
      },
    );
    ongoingEffects.add([effect, timer]);
  }

  void removeOngoingEffect(String effect) {
    for (var i = 0; i < ongoingEffects.length; i++) {
      if (ongoingEffects[i][0] == effect) {
        ongoingEffects[i][1].cancel();
        ongoingEffects.removeAt(i);
      }
    }
  }
}
