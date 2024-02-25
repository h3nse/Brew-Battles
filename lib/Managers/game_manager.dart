import 'package:flutter/material.dart';

class GameManager extends ChangeNotifier {
  String _gamestate = 'starting';
  String _potionState = 'empty';
  List<int> _ingredients = [];
  int _mixLevel = 0;
  String _finishedPotion = '';

  String get gamestate => _gamestate;
  String get potionState => _potionState;
  List<int> get ingredients => _ingredients;
  int get mixLevel => _mixLevel;
  String get finishedPotion => _finishedPotion;

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

  void changeFinishedPotion(String value) {
    _finishedPotion = value;
    notifyListeners();
  }
}
