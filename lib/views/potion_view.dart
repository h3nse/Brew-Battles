import 'package:brew_battles/Managers/game_manager.dart';
import 'package:brew_battles/views/potion_state_views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
