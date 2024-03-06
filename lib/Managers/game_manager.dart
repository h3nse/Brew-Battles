import 'package:brew_battles/Global/potions.dart';
import 'package:flutter/material.dart';

class GameManager extends ChangeNotifier {
  /// Game
  String _gamestate = 'starting';
  String _winner = '';

  String get gamestate => _gamestate;
  String get winner => _winner;

  void changeGamestate(String value) {
    _gamestate = value;
    notifyListeners();
  }

  void changeWinner(String winner) {
    _winner = winner;
    notifyListeners();
  }

  /// Player
  double _playerHealth = 0;
  double _opponentHealth = 0;
  String _playerActionText = ''; // Temp until we have animations
  String _opponentActionText = ''; // Temp until we have animations
  List<String> _playerActiveEffects = [];
  List<String> _opponentActiveEffects = [];
  bool _isBlinded = false;
  bool _isFrozen = false;
  bool _hasShield = false;
  double _damageMultiplier = 1;
  double _healMultiplier = 1;

  double get playerHealth => _playerHealth;
  double get opponentHealth => _opponentHealth;
  String get playerActionText =>
      _playerActionText; // Temp until we have animations
  String get opponentActionText =>
      _opponentActionText; // Temp until we have animations
  List<String> get playerActiveEffects => _playerActiveEffects;
  List<String> get opponentActiveEffects => _opponentActiveEffects;
  bool get isBlinded => _isBlinded;
  bool get isFrozen => _isFrozen;
  bool get hasShield => _hasShield;
  double get damageMultiplier => _damageMultiplier;
  double get healMultiplier => _healMultiplier;

  void changePlayerHealth(double amount) {
    _playerHealth += amount;
    notifyListeners();
  }

  void setPlayerHealth(double health) {
    _playerHealth = health;
    notifyListeners();
  }

  void setOpponentHealth(double health) {
    _opponentHealth = health;
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

  void setIsFrozen(bool value) {
    _isFrozen = value;
    notifyListeners();
  }

  void setHasShield(bool value) {
    _hasShield = value;
    notifyListeners();
  }

  void setDamageMultiplier(double multiplier) {
    _damageMultiplier = multiplier;
    notifyListeners();
  }

  void setHealMultiplier(double multiplier) {
    _healMultiplier = multiplier;
    notifyListeners();
  }

  /// Potion
  String _potionState = 'empty';
  List<int> _ingredients = [];
  double _mixLevel = 0;
  Potion _finishedPotion = DefaultPotion();
  double _potionShakeMultiplier = 1;

  String get potionState => _potionState;
  List<int> get ingredients => _ingredients;
  double get mixLevel => _mixLevel;
  Potion get finishedPotion => _finishedPotion;
  double get potionShakeMultiplier => _potionShakeMultiplier;

  void changePotionState(String value) {
    _potionState = value;
    notifyListeners();
  }

  void addIngredient(int ingredient) {
    _ingredients.add(ingredient);
    notifyListeners();
  }

  void removeIngredient(int ingredient) {
    _playerActiveEffects
        .removeWhere((element) => element == ingredient.toString());
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

  void changeFinishedPotionId(Potion potion) {
    _finishedPotion = potion;
    notifyListeners();
  }

  void setPotionShakeMultiplier(double multiplier) {
    _potionShakeMultiplier = multiplier;
    notifyListeners();
  }

  void emptyPotion() {
    changePotionState('empty');
    emptyIngredients();
    resetMixLevel();
    changeFinishedPotionId(DefaultPotion());
  }

  void resetAll() {
    emptyPotion();
    _playerActiveEffects = [];
    _opponentActiveEffects = [];
    setPlayerActionText(''); // Remove later
    setOpponentActionText(''); // Remove later
  }
}
