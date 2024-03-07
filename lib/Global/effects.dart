import 'dart:async';

import 'package:brew_battles/Global/constants.dart';
import 'package:brew_battles/Managers/game_manager.dart';

abstract class Effect {
  String name;
  late Timer timer;
  late GameManager gameManager;

  Effect(this.name);

  void setGameManager(GameManager gameManager) {
    this.gameManager = gameManager;
  }

  void setTimer(Timer timer) {
    this.timer = timer;
  }

  void startEffect() {}
  void endEffect() {
    timer.cancel();
  }
}

class PlaceHolderEffect extends Effect {
  PlaceHolderEffect() : super('Placeholder effect');

  @override
  void endEffect() {}
}

class Burning extends Effect {
  Burning() : super('Burning');

  @override
  void startEffect() {
    final effectValues = Constants.effectValues['Burning'];
    setTimer(gameManager.createPeriodicEffect(effectValues!['TickSpeed'], () {
      gameManager.takeDamage(effectValues['TickDamage']);
    }));

    print("Starting burn effect");
  }

  @override
  void endEffect() {
    print("Ending burn effect");
    super.endEffect();
  }
}
