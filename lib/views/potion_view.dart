import 'package:brew_battles/Global/constants.dart';
import 'package:brew_battles/Managers/game_manager.dart';
import 'package:brew_battles/Pages/Scanner/barcode_scanner.dart';
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
            potion = const FinishedPotion();
            break;
        }
        return Column(
          children: [
            Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    (gameManager.isFrozen)
                        ? const Positioned(
                            top: 100, child: Text('You have been frozen'))
                        : Container(),
                    potion
                  ],
                )),
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
                      onPressed: () async {
                        if (gameManager.isFrozen) {
                          return;
                        }
                        String? result =
                            await Navigator.of(context).push<String>(
                          MaterialPageRoute(
                            builder: (context) =>
                                const BarcodeScannerWithoutController(),
                          ),
                        );
                        if (result != null) {
                          final ingredientId = int.tryParse(result);
                          if (ingredientId != null &&
                              ingredientId <=
                                  Constants.idToIngredients.length) {
                            gameManager.addIngredient(ingredientId);
                          }
                        }
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
                        if (gameManager.isFrozen) {
                          return;
                        }
                        gameManager.emptyPotion();
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
