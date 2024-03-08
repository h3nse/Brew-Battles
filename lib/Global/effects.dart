import 'dart:async';
import 'dart:math';

import 'package:brew_battles/Global/constants.dart';
import 'package:brew_battles/Managers/game_manager.dart';

abstract class Effect {
  String name;
  late Timer durationTimer;
  late GameManager gameManager;

  Effect(this.name);

  void setGameManager(GameManager gameManager) {
    this.gameManager = gameManager;
  }

  void setDurationTimer(Timer timer) {
    durationTimer = timer;
  }

  void startEffect() {}
  void endEffect() {}
}

class PlaceHolderEffect extends Effect {
  PlaceHolderEffect() : super("Placeholder effect");

  @override
  void endEffect() {}
}

class Stoneskin extends Effect {
  Stoneskin() : super("Stoneskin");

  @override
  void startEffect() {
    gameManager.addOnDamage(0, onDamage);
  }

  double onDamage(double damageMultiplier) {
    final damageReduction = damageMultiplier -
        Constants.effectValues['Stoneskin']!['DamageReduction'];
    damageMultiplier =
        max(damageMultiplier - damageReduction, 1 - damageReduction);
    gameManager.removePlayerEffect(name);
    return damageMultiplier;
  }

  @override
  void endEffect() {
    gameManager.removeOnDamage(0);
    super.endEffect();
  }
}

class Regenerating extends Effect {
  late Timer periodicTimer;
  Regenerating() : super("Regenerating");

  @override
  void startEffect() {
    final effectValues = Constants.effectValues['Regenerating'];
    periodicTimer =
        gameManager.createPeriodicEffect(effectValues!['TickSpeed'], () {
      gameManager.heal(effectValues['TickRegen']);
    });
  }

  @override
  void endEffect() {
    periodicTimer.cancel();
    durationTimer.cancel();
  }
}

class AboutToExplode extends Effect {
  AboutToExplode() : super("About to Explode");

  @override
  void endEffect() {
    durationTimer.cancel();
  }
}

class Burning extends Effect {
  late Timer periodicTimer;
  Burning() : super("Burning");

  @override
  void startEffect() {
    final effectValues = Constants.effectValues['Burning'];
    periodicTimer =
        gameManager.createPeriodicEffect(effectValues!['TickSpeed'], () {
      gameManager.takeDamage(effectValues['TickDamage']);
    });
  }

  @override
  void endEffect() {
    periodicTimer.cancel();
    durationTimer.cancel();
  }
}
