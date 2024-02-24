import 'package:brew_battles/views/potion_view.dart';
import 'package:brew_battles/views/wizard_view.dart';
import 'package:flutter/material.dart';

class GameRunningView extends StatelessWidget {
  const GameRunningView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Expanded(flex: 1, child: WizardView()),
          Expanded(flex: 2, child: PotionView())
        ],
      ),
    );
  }
}
