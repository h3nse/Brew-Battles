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
    return Consumer<GameManager>(
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
            potion =
                const SizedBox(height: 300, width: 300, child: Placeholder());
        }
        return Column(
          children: [
            Expanded(flex: 3, child: potion),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: (gameManager.potionState == 'empty')
                          ? ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.primary),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.onPrimary),
                            )
                          : ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.grey),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black)),
                      onPressed: () {
                        print('Scan Ingredient Tapped');
                      },
                      child: const Text('Scan Ingredient')),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.primary),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.onPrimary),
                      ),
                      onPressed: () {
                        print('Pour Potion Out Tapped');
                      },
                      child: const Text('Pour Potion Out'))
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
