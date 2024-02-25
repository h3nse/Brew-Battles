import 'dart:math';

import 'package:brew_battles/Global/constants.dart';
import 'package:brew_battles/Managers/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WizardView extends StatefulWidget {
  const WizardView({super.key});

  @override
  State<WizardView> createState() => _WizardViewState();
}

class _WizardViewState extends State<WizardView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameManager = Provider.of<GameManager>(context, listen: false);
      gameManager.changePlayerHealth(Constants.initialHealth);
      gameManager.changeOpponentHealth(Constants.initialHealth);
    });
    super.initState();
  }

  void handlePotion(GameManager gameManager, int potion) {
    final effects = Constants.potionEffects[potion];
    for (var effect in effects!) {
      switch (effect[0]) {
        case 'Damage':
          gameManager.changePlayerHealth(
              (gameManager.playerHealth - effect[1]).toInt());
          break;
        case 'Heal':
          gameManager.changePlayerHealth(min(Constants.initialHealth,
              (gameManager.playerHealth + effect[1]).toInt()));
          break;
      }
    }
  }

  void throwPotion() {}

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
                print('Left Wizard Tapped');
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
                throwPotion();
                print('Right Wizard Tapped');
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
