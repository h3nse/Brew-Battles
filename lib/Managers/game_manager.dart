import 'package:flutter/material.dart';

class GameManager extends ChangeNotifier {
  String _gamestate = 'starting';
  String _potionState = 'empty';
  List<int> _ingredients = [];
  int _mixLevel = 0;
  int _finishedPotionId = 0;
  int _playerHealth = 0;
  int _opponentHealth = 0;

  String get gamestate => _gamestate;
  String get potionState => _potionState;
  List<int> get ingredients => _ingredients;
  int get mixLevel => _mixLevel;
  int get finishedPotion => _finishedPotionId;
  int get playerHealth => _playerHealth;
  int get opponentHealth => _opponentHealth;

  void changeGamestate(String value) {
    _gamestate = value;
    notifyListeners();
  }

  void changePotionState(String value) {
    _potionState = value;
    notifyListeners();
  }

  void addIngredient(int ingredient) {
    _ingredients.add(ingredient);
    notifyListeners();
  }

  void emptyIngredients() {
    _ingredients = [];
    notifyListeners();
  }

  void increaseMixLevel(int value) {
    _mixLevel += value;
    notifyListeners();
  }

  void resetMixLevel() {
    _mixLevel = 0;
    notifyListeners();
  }

  void changeFinishedPotionId(int value) {
    _finishedPotionId = value;
    notifyListeners();
  }

  void emptyPotion() {
    changePotionState('empty');
    emptyIngredients();
    resetMixLevel();
    changeFinishedPotionId(0);
  }

  void changePlayerHealth(int health) {
    _playerHealth = health;
    notifyListeners();
  }

  void changeOpponentHealth(int health) {
    _opponentHealth = health;
    notifyListeners();
  }
}
