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
  void applyPotion() {}
}

class ExplodingPotion extends Potion {
  ExplodingPotion() : super(2, "Exploding Potion");

  @override
  void applyPotion() {
    print('Applied exploding potion');
  }
}

class PotionOfFire extends Potion {
  PotionOfFire() : super(3, "Potion of Fire");

  @override
  void applyPotion() {}
}
