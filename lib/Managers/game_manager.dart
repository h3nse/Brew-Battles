import 'package:flutter/material.dart';

class GameManager extends ChangeNotifier {
  String _gamestate = 'starting';
  String _potionState = 'empty';
  int _mixLevel = 0;

  String get gamestate => _gamestate;
  String get potionState => _potionState;
  int get mixLevel => _mixLevel;

  void changeGamestate(String value) {
    _gamestate = value;
    notifyListeners();
  }

  void changePotionState(String value) {
    _potionState = value;
    notifyListeners();
  }

  void increaseMixLevel(int value) {
    _mixLevel += value;
    notifyListeners();
  }
}
