class Player {
  static final Player _instance = Player._internal(0, '', 0);
  int id;
  String name;
  int opponentId;

  factory Player() {
    return _instance;
  }

  Player._internal(this.id, this.name, this.opponentId);
}
