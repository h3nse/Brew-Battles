import 'dart:async';
import 'dart:math';

import 'package:brew_battles/Global/constants.dart';
import 'package:brew_battles/Global/effects.dart';
import 'package:brew_battles/Managers/game_manager.dart';

abstract class Potion {
  int id;
  String name;
  late GameManager gameManager;

  Potion(this.id, this.name);
  void setGameManager(GameManager gameManager) {
    this.gameManager = gameManager;
  }

  void applyPotion();
}

class DefaultPotion extends Potion {
  DefaultPotion() : super(0, "Default Potion");

  @override
  void applyPotion() {}
}

class PotionOfHealing extends Potion {
  PotionOfHealing() : super(1, "Potion of Healing");

  @override
  void applyPotion() {
    gameManager.heal(Constants.potionEffectValues[id]!['Heal']);
  }
}

class ExplodingPotion extends Potion {
  ExplodingPotion() : super(2, "Exploding Potion");

  @override
  void applyPotion() {
    gameManager.takeDamage(Constants.potionEffectValues[id]!['Damage']);
  }
}

class PotionOfStoneskin extends Potion {
  PotionOfStoneskin() : super(3, "Potion of Stoneskin");

  @override
  void applyPotion() {
    final stoneskinEffect = Stoneskin();

    stoneskinEffect.setGameManager(gameManager);
    gameManager.addPlayerEffect(stoneskinEffect);
  }
}

class PotionOfExplodingHealth extends Potion {
  PotionOfExplodingHealth() : super(9, "Potion of Exploding Health");

  @override
  void applyPotion() {
    final variation = Constants.potionEffectValues[id]!['Variation'];
    final random = Random();
    final zeroOrOne = random.nextInt(2);
    final amount = 1 + random.nextInt(variation - 1);
    if (zeroOrOne == 0) {
      gameManager.heal(amount.toDouble());
    } else {
      gameManager.takeDamage(-amount.toDouble());
    }
  }
}

class PotionOfRegeneration extends Potion {
  PotionOfRegeneration() : super(10, "Potion of Regeneration");

  @override
  void applyPotion() {
    final regenEffect = Regenerating();

    final regenDuration = Constants.potionEffectValues[id]!['Duration'];
    final durationTimer = Timer(Duration(seconds: regenDuration + 1),
        () => gameManager.removePlayerEffect(regenEffect.name));

    regenEffect.setGameManager(gameManager);
    regenEffect.setDurationTimer(durationTimer);
    gameManager.addPlayerEffect(regenEffect);
  }
}

class PotionOfDelayedExplosion extends Potion {
  PotionOfDelayedExplosion() : super(11, "Potion of Delayed Explosion");

  @override
  void applyPotion() {
    final aboutToExplodeEffect = AboutToExplode();
    final explosionDelay = Constants.potionEffectValues[id]!['ExplosionDelay'];
    final damage = Constants.potionEffectValues[id]!['Damage'];

    final timer = Timer(Duration(seconds: explosionDelay), () {
      gameManager.takeDamage(damage);
      gameManager.removePlayerEffect(aboutToExplodeEffect.name);
    });

    aboutToExplodeEffect.setDurationTimer(timer);
    gameManager.addPlayerEffect(aboutToExplodeEffect);
  }
}

class PotionOfFlames extends Potion {
  PotionOfFlames() : super(12, "Potion of Flames");

  @override
  void applyPotion() {
    final burningEffect = Burning();

    final burnDuration = Constants.potionEffectValues[id]!['Duration'];
    final durationTimer = Timer(Duration(seconds: burnDuration + 1),
        () => gameManager.removePlayerEffect(burningEffect.name));

    burningEffect.setGameManager(gameManager);
    burningEffect.setDurationTimer(durationTimer);
    gameManager.addPlayerEffect(burningEffect);
  }
}
