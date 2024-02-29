import 'package:flutter/material.dart';

class GameManager extends ChangeNotifier {
  /// Game related
  String _gamestate = 'starting';
  String _potionState = 'empty';
  int _playerHealth = 0;
  int _opponentHealth = 0;
  String _winner = '';
  String _playerActionText = ''; // Temp until we have animations
  String _opponentActionText = ''; // Temp until we have animations
  /// Potion related
  List<int> _ingredients = [];
  double _mixLevel = 0;
  int _finishedPotionId = 0;

  /// Effect related
  final List<String> _playerActiveEffects = [];
  final List<String> _opponentActiveEffects = [];
  bool _isBlinded = false;
  double _potionShakeMultiplier = 1;
  bool _isFrozen = false;

  /// Game related
  String get gamestate => _gamestate;
  String get potionState => _potionState;
  int get playerHealth => _playerHealth;
  int get opponentHealth => _opponentHealth;
  String get winner => _winner;
  String get playerActionText =>
      _playerActionText; // Temp until we have animations
  String get opponentActionText =>
      _opponentActionText; // Temp until we have animations
  /// Potion related
  List<int> get ingredients => _ingredients;
  double get mixLevel => _mixLevel;
  int get finishedPotion => _finishedPotionId;

  /// Effect related
  List<String> get playerActiveEffects => _playerActiveEffects;
  List<String> get opponentActiveEffects => _opponentActiveEffects;
  bool get isBlinded => _isBlinded;
  double get potionShakeMultiplier => _potionShakeMultiplier;
  bool get isFrozen => _isFrozen;

  /// Game related
  void changeGamestate(String value) {
    _gamestate = value;
    notifyListeners();
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

  void changeWinner(String winner) {
    _winner = winner;
    notifyListeners();
  }

  void setPlayerActionText(String value) {
    _playerActionText = value;
    notifyListeners();
  } // Remove when we have animations

  void setOpponentActionText(String value) {
    _opponentActionText = value;
    notifyListeners();
  } // Remove when we have animations

  void resetAll() {
    emptyPotion();
    _playerActiveEffects.clear();
    _opponentActiveEffects.clear();
    setPlayerActionText(''); // Remove later
    setOpponentActionText(''); // Remove later
  }

  /// Potion related
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

  void increaseMixLevel(double value) {
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

  /// Effect related
  void addPlayerActiveEffect(String effect) {
    _playerActiveEffects.add(effect);
    notifyListeners();
  }

  void addOpponentActiveEffect(String effect) {
    _opponentActiveEffects.add(effect);
    notifyListeners();
  }

  void removePlayerActiveEffect(String effect) {
    _playerActiveEffects.removeWhere((element) => element == effect);
    notifyListeners();
  }

  void removeOpponentActiveEffect(String effect) {
    _opponentActiveEffects.removeWhere((element) => element == effect);
    notifyListeners();
  }

  void setIsBlinded(bool value) {
    _isBlinded = value;
    notifyListeners();
  }

  void setPotionShakeMultiplier(double multiplier) {
    _potionShakeMultiplier = multiplier;
    notifyListeners();
  }

  void setIsFrozen(bool value) {
    _isFrozen = value;
    notifyListeners();
  }
}
