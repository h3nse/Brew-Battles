import 'dart:async';

import 'package:brew_battles/Global/constants.dart';
import 'package:brew_battles/Global/player.dart';
import 'package:brew_battles/Global/potions.dart';
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
  late final GameManager gameManager;
  bool playerDead = false;
  bool opponentDead = false;
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
                if (gameManager.potionState != 'finished' ||
                    gameManager.isFrozen) {
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
                if (gameManager.potionState != 'finished' ||
                    gameManager.isFrozen) {
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
    gameManager = Provider.of<GameManager>(context, listen: false);
    _duelChannel = supabase.channel('updates').subscribe();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gameManager.setPlayerHealth(Constants.initialHealth);
      gameManager.setOpponentHealth(Constants.initialHealth);
      gameManager.setBroadcastChannel(_duelChannel);
      gameManager.setOnDeathCallback(wizardDied);
    });
    _duelChannel.onBroadcast(
        event: 'health_update',
        callback: (payload) =>
            gameManager.setOpponentHealth(payload['health']));
    _duelChannel.onBroadcast(
      event: 'potion_update',
      callback: (payload) {
        print(payload);
        if (payload['isThrown']) {
          final potion = Constants.idToPotions[payload['potionId']]!;
          potion.setGameManager(gameManager);
          applyPotion(potion);
          gameManager.setOpponentActionText(
              'threw ${Constants.idToPotions[payload['potionId']]!.name}');
        } else {
          gameManager.setOpponentActionText(
              'drank ${Constants.idToPotions[payload['potionId']]!.name}');
        }
      },
    );
    _duelChannel.onBroadcast(
      event: 'effect_update',
      callback: (payload) {
        if (payload['remove']) {
          gameManager.removeOpponentActiveEffect(payload['effect']);
        } else {
          gameManager.addOpponentActiveEffect(payload['effect']);
        }
      },
    );
    _duelChannel.onBroadcast(
        event: 'death', callback: (payload) => wizardDied(false));
    super.initState();
  }

  /// Potion Application
  void drinkPotion(Potion potion) {
    // Replace with animation
    gameManager.setPlayerActionText('drank ${potion.name}');

    applyPotion(potion);
    gameManager.notifyPotionAction(potion.id, false);
  }

  void throwPotion(Potion potion) {
    // Replace with animation
    gameManager.setPlayerActionText('threw ${potion.name}');

    gameManager.notifyPotionAction(potion.id, true);
  }

  /// where each potions effect is programmed
  void applyPotion(Potion potion) {
    if (gameManager.hasShield) {
      gameManager.setHasShield(false);
      gameManager.removePlayerActiveEffect('Shielded');
      gameManager.notifyEffect('Shielded', true);
      return;
    }
    potion.applyPotion();
    // switch (potionId) {
    //   case 1:
    //     // Healing potion
    //     heal(Constants.potionEffectValues[potionId]!['Heal']!);
    //     break;
    //   case 2:
    //     // Explosion potion
    //     takeDamage(Constants.potionEffectValues[potionId]!['Damage']!);
    //     break;
    //   case 3:
    //     // Fire potion
    //     createPeriodicEffect(
    //       'Burning',
    //       Constants.potionEffectValues[potionId]!['TickSpeed']!,
    //       Constants.potionEffectValues[potionId]!['TickAmount']!,
    //       () => takeDamage(
    //           Constants.potionEffectValues[potionId]!['TickDamage']!),
    //     );
    //     break;
    //   case 4:
    //     // Potion of blindness
    //     gameManager.setIsBlinded(true);
    //     createTimedEffect(
    //         'Blinded', Constants.potionEffectValues[potionId]!['Duration']!,
    //         () {
    //       gameManager.setIsBlinded(false);
    //     });
    //     break;
    //   case 5:
    //     // Haste potion
    //     gameManager.setPotionShakeMultiplier(
    //         Constants.potionEffectValues[potionId]!['Multiplier']);
    //     createTimedEffect(
    //         'Hasted', Constants.potionEffectValues[potionId]!['Duration'], () {
    //       gameManager.setPotionShakeMultiplier(1);
    //     });
    //     break;
    //   case 6:
    //     // Slowness potion
    //     gameManager.setPotionShakeMultiplier(
    //         Constants.potionEffectValues[potionId]!['Multiplier']);
    //     createTimedEffect(
    //         'Slowed', Constants.potionEffectValues[potionId]!['Duration'], () {
    //       gameManager.setPotionShakeMultiplier(1);
    //     });
    //   case 7:
    //     // Freezing potion
    //     gameManager.setIsFrozen(true);
    //     createTimedEffect(
    //         'Frozen', Constants.potionEffectValues[potionId]!['Duration']!, () {
    //       gameManager.setIsFrozen(false);
    //     });
    //     break;
    //   case 8:
    //     // Shield potion
    //     gameManager.setHasShield(true);
    //     gameManager.addPlayerActiveEffect('Shielded');
    //     notifyEffect('Shielded', false);
    //   case 9:
    //     // Potion of vulnerability
    //     gameManager.setDamageMultiplier(
    //         Constants.potionEffectValues[potionId]!['Multiplier']);
    //     createTimedEffect(
    //         'Vulnerable', Constants.potionEffectValues[potionId]!['Duration'],
    //         () {
    //       gameManager.setDamageMultiplier(1);
    //     });
    //     break;
    //   case 10:
    //     // Potion of toughness
    //     gameManager.setDamageMultiplier(
    //         Constants.potionEffectValues[potionId]!['Multiplier']);
    //     createTimedEffect(
    //         'Vulnerable', Constants.potionEffectValues[potionId]!['Duration'],
    //         () {
    //       gameManager.setDamageMultiplier(1);
    //     });
    //     break;
    //   case 11:
    //     // Potion of clumsiness
    //     final ingredients = gameManager.ingredients;
    //     final random = Random();
    //     final ingredient = ingredients[random.nextInt(ingredients.length)];
    //     gameManager.removeIngredient(ingredient);
    //   case 12:
    //     // Potion of purity
    //     final effects = gameManager.playerActiveEffects;
    //     final random = Random();
    //     final effect =
    //         gameManager.playerActiveEffects[random.nextInt(effects.length)];
    //     removeActiveEffect(effect);
    // }
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
    gameManager.changeWinner(winner);
    Timer(const Duration(seconds: Constants.endDurationSec), () {
      endGame();
    });
  }

  void endGame() async {
    gameManager.resetAll();
    if (Player().isManager) {
      await supabase
          .from('duels')
          .update({'gamestate': 'ending'}).eq('id', Player().duelId);
    }
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
        }
      },
    );
    activeEffectTimers.add([effect, timer]);
    gameManager.addPlayerActiveEffect(effect);
    gameManager.notifyEffect(effect, false);
  }

  void createTimedEffect(String effect, int duration, Function onTimeout) {
    removeActiveEffect(effect);
    final timer = Timer(Duration(seconds: duration), () {
      onTimeout();
      removeActiveEffect(effect);
    });
    activeEffectTimers.add([effect, timer]);
    gameManager.addPlayerActiveEffect(effect);
    gameManager.notifyEffect(effect, false);
  }

  void removeActiveEffect(String effect) {
    for (var i = 0; i < activeEffectTimers.length; i++) {
      if (activeEffectTimers[i][0] == effect) {
        activeEffectTimers[i][1].cancel();
        activeEffectTimers.removeAt(i);
        gameManager.removePlayerActiveEffect(effect);
        gameManager.notifyEffect(effect, true);
      }
    }
  }
}
