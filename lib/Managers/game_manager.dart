import 'package:flutter/material.dart';

class GameManager extends ChangeNotifier {
  String _gamestate = 'starting';
  String _potionState = 'empty';
  List<int> _ingredients = [];
  int _mixLevel = 0;
  int _finishedPotionId = 0;
  int _playerHealth = 0;
  int _opponentHealth = 0;
  List<int> _activeEffects = [];
  String _winner = '';

  // Temp until we have animations
  String _playerActionText = '';
  String _opponentActionText = '';

  String get gamestate => _gamestate;
  String get potionState => _potionState;
  List<int> get ingredients => _ingredients;
  int get mixLevel => _mixLevel;
  int get finishedPotion => _finishedPotionId;
  int get playerHealth => _playerHealth;
  int get opponentHealth => _opponentHealth;
  List<int> get activeEffects => _activeEffects;
  String get winner => _winner;

  String get playerActionText => _playerActionText;
  String get opponentActionText => _opponentActionText;

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

  void changePlayerHealth(int amount) {
    _playerHealth += amount;
    notifyListeners();
  }

  void setPlayerHealth(int health) {
    _playerHealth = health;
    notifyListeners();
  }

  void setOpponentHealth(int health) {
    _opponentHealth = health;
    notifyListeners();
  }

  void addEffect(int effect) {
    _activeEffects.add(effect);
    notifyListeners();
  }

  void removeEffect(int effect) {
    _activeEffects.removeWhere((element) => element == effect);
    notifyListeners();
  }

  void changeWinner(String winner) {
    _winner = winner;
    notifyListeners();
  }

  // Remove when we have animations
  void setPlayerActionText(String value) {
    _playerActionText = value;
    notifyListeners();
  }

  void setOpponentActionText(String value) {
    _opponentActionText = value;
    notifyListeners();
  }
}
