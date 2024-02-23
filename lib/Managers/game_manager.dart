import 'package:flutter/material.dart';

class GameManager extends ChangeNotifier {
  String _gamestate = 'starting';

  String get gamestate => _gamestate;

  void changeGamestate(String value) {
    _gamestate = value;
    notifyListeners();
  }
}
