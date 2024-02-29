import 'dart:async';
import 'package:flutter/material.dart';
import 'package:brew_battles/Global/constants.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:provider/provider.dart';
import 'package:brew_battles/Managers/game_manager.dart';
import 'package:collection/collection.dart';

class EmptyPotion extends StatefulWidget {
  const EmptyPotion({super.key});

  @override
  State<EmptyPotion> createState() => _EmptyPotionState();
}

class _EmptyPotionState extends State<EmptyPotion> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<GameManager>(context, listen: false)
            .changePotionState('mixing');
      },
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(width: 2, color: Colors.purple)),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Empty Potion'),
            Consumer<GameManager>(builder: (context, gameManager, child) {
              List<String> namedIngredients = [];
              final ingredientIds = gameManager.ingredients;
              for (var i in ingredientIds) {
                namedIngredients.add(Constants.idToIngredients[i]!);
              }
              return (!gameManager.isBlinded)
                  ? Text('Ingredients: $namedIngredients')
                  : const Text('A Hazy Fog Obscures Your potion');
            })
          ],
        )),
      ),
    );
  }
}

class MixingPotion extends StatefulWidget {
  const MixingPotion({super.key});

  @override
  State<MixingPotion> createState() => _MixingPotionState();
}

class _MixingPotionState extends State<MixingPotion> {
  late StreamSubscription accelerometerSubscription;

  @override
  void dispose() {
    accelerometerSubscription.cancel();
    super.dispose();
  }

  void createPotion() {
    final gameManager = Provider.of<GameManager>(context, listen: false);
    final ingredients = gameManager.ingredients;
    ingredients.sort();
    Function eq = const ListEquality().equals;
    int potionId = 0;
    for (var i = 0; i < Constants.potions.length; i++) {
      if (eq(Constants.potions[i][1], ingredients)) {
        potionId = Constants.potions[i][0];
        break;
      }
    }
    gameManager.changeFinishedPotionId(potionId);
  }

  @override
  void initState() {
    accelerometerSubscription = userAccelerometerEventStream(
            samplingPeriod:
                const Duration(milliseconds: Constants.msPotionShakeInterval))
        .listen((event) {
      if (event.x.abs() > Constants.potionShakeThreshold ||
          event.y.abs() > Constants.potionShakeThreshold ||
          event.z.abs() > Constants.potionShakeThreshold) {
        final gameManager = Provider.of<GameManager>(context, listen: false);
        gameManager.increaseMixLevel(1);
        if (gameManager.mixLevel >= Constants.maxMixLevel) {
          createPotion();
          gameManager.changePotionState('finished');
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<GameManager>(builder: (context, gameManager, child) {
        return Text('${gameManager.mixLevel}');
      }),
    );
  }
}

class FinishedPotion extends StatelessWidget {
  const FinishedPotion({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<GameManager>(
        builder: (context, gameManager, child) {
          return Text(Constants.idToPotions[gameManager.finishedPotion]!);
        },
      ),
    );
  }
}
