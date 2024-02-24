import 'dart:async';

import 'package:brew_battles/Global/constants.dart';
import 'package:brew_battles/Managers/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

class PotionView extends StatefulWidget {
  const PotionView({super.key});

  @override
  State<PotionView> createState() => _PotionViewState();
}

class _PotionViewState extends State<PotionView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Consumer<GameManager>(
            builder: (context, gameManager, child) {
              Widget potion = const Placeholder();
              switch (gameManager.potionState) {
                case 'empty':
                  potion = const EmptyPotion();
                  break;
                case 'mixing':
                  potion = const MixingPotion();
                  break;
                case 'finished':
                  potion = const Placeholder();
              }
              return potion;
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    print('Scan Ingredient Tapped');
                  },
                  child: const Text('Scan Ingredient')),
              ElevatedButton(
                  onPressed: () {
                    print('Pour Potion Out Tapped');
                  },
                  child: const Text('Pour Potion Out'))
            ],
          ),
        )
      ],
    );
  }
}

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
        child: const Center(child: Text('Potion')),
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

  @override
  void initState() {
    accelerometerSubscription = userAccelerometerEventStream(
            samplingPeriod:
                const Duration(milliseconds: Constants.msPotionShakeInterval))
        .listen((event) {
      if (event.x.abs() > Constants.potionShakeThreshold ||
          event.y.abs() > Constants.potionShakeThreshold ||
          event.z.abs() > Constants.potionShakeThreshold) {
        Provider.of<GameManager>(context, listen: false).increaseMixLevel(1);
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
