class Player {
  static final Player _instance = Player._internal(0, '', 0, '', 0);
  int id;
  String name;
  int opponentId;
  String opponentName;
  int duelId;

  factory Player() {
    return _instance;
  }

  Player._internal(
      this.id, this.name, this.opponentId, this.opponentName, this.duelId);
}
