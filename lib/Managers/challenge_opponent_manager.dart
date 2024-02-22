import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChallengeOpponentManager extends ChangeNotifier {
  bool _isChallenging = false;
  String _challengerName = '';
  String _challengedPlayerName = '';
  late RealtimeChannel _opponentChannel;

  bool get isChallenging => _isChallenging;
  String get challengerName => _challengerName;
  String get challengedPlayerName => _challengedPlayerName;
  RealtimeChannel get opponentChannel => _opponentChannel;

  void changeIsChallenging(bool value) {
    _isChallenging = value;
    notifyListeners();
  }

  void changeChallengerName(String value) {
    _challengerName = value;
    notifyListeners();
  }

  void changechallengedPlayerName(String value) {
    _challengedPlayerName = value;
    notifyListeners();
  }

  void changeopponentChannel(RealtimeChannel value) {
    _opponentChannel = value;
    notifyListeners();
  }
}
