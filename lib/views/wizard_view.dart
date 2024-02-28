import 'dart:async';

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
  int damageMultiplier = 1;
  int healMultiplier = 1;
  List activeEffectTimers = [];

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
                height: 200,
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
                                    : Container(),
                                Text(gameManager.playerActiveEffects.toString())
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
                height: 200,
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
                                    : Container(),
                                Text(gameManager.opponentActiveEffects
                                    .toString())
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
            applyPotion(payload['potionId']),
            Provider.of<GameManager>(context, listen: false)
                .setOpponentActionText(
                    'threw ${Constants.idToPotions[payload['potionId']]!}'),
          }
        else
          {
            Provider.of<GameManager>(context, listen: false)
                .setOpponentActionText(
                    'drank ${Constants.idToPotions[payload['potionId']]!}')
          }
      },
    );
    _duelChannel.onBroadcast(
      event: 'effect_update',
      callback: (payload) => {
        if (payload['remove'])
          {gameManager.removeOpponentActiveEffect(payload['effect'])}
        else
          {gameManager.addOpponentActiveEffect(payload['effect'])},
      },
    );
    _duelChannel.onBroadcast(
        event: 'death', callback: (payload) => wizardDied(false));
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

  void wizardDied(bool self) {
    String winner;
    if (self) {
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
    Provider.of<GameManager>(context, listen: false).resetAll();
    if (Player().isManager) {
      await supabase
          .from('duels')
          .update({'gamestate': 'ending'}).eq('id', Player().duelId);
    }
  }

  /// Notifying the other player
  void notifyPotionAction(int potionId, bool isThrown) {
    _duelChannel.sendBroadcastMessage(
        event: 'potion_update',
        payload: {'potionId': potionId, 'isThrown': isThrown});
  }

  void notifyEffect(String effect, bool remove) {
    _duelChannel.sendBroadcastMessage(
        event: 'effect_update', payload: {'effect': effect, 'remove': remove});
  }

  void notifyHealth(int health) {
    _duelChannel.sendBroadcastMessage(
        event: 'health_update', payload: {'health': health});
  }

  void notifyDeath() {
    _duelChannel.sendBroadcastMessage(event: 'death', payload: {});
  }

  /// Effects
  void takeDamage(int amount) {
    amount = amount * damageMultiplier;
    Provider.of<GameManager>(context, listen: false)
        .changePlayerHealth(-amount);
    if (Provider.of<GameManager>(context, listen: false).playerHealth <= 0) {
      Provider.of<GameManager>(context, listen: false).setPlayerHealth(0);
      wizardDied(true);
      notifyDeath();
    }
    notifyHealth(Provider.of<GameManager>(context, listen: false).playerHealth);
  }

  void heal(int amount) {
    amount = amount * healMultiplier;
    Provider.of<GameManager>(context, listen: false).changePlayerHealth(amount);
    if (Provider.of<GameManager>(context, listen: false).playerHealth > 100) {
      Provider.of<GameManager>(context, listen: false).setPlayerHealth(100);
    }
    notifyHealth(Provider.of<GameManager>(context, listen: false).playerHealth);
  }

  void createPeriodicEffect(
      String effect, int tickSpeed, int tickAmount, Function onTimeout) {
    removeActiveEffect(effect);
    int tickCount = 0;
    final timer = Timer.periodic(
      Duration(seconds: tickSpeed),
      (timer) {
        onTimeout();
        tickCount += 1;
        if (tickCount == tickAmount) {
          removeActiveEffect(effect);
          return;
        }
      },
    );
    activeEffectTimers.add([effect, timer]);
    Provider.of<GameManager>(context, listen: false)
        .addPlayerActiveEffect(effect);
    notifyEffect(effect, false);
  }

  void removeActiveEffect(String effect) {
    for (var i = 0; i < activeEffectTimers.length; i++) {
      if (activeEffectTimers[i][0] == effect) {
        activeEffectTimers[i][1].cancel();
        activeEffectTimers.removeAt(i);
        Provider.of<GameManager>(context, listen: false)
            .removePlayerActiveEffect(effect);
        notifyEffect(effect, true);
      }
    }
  }
}
