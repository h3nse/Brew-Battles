import 'package:brew_battles/Global/player.dart';
import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:intl/intl.dart';

class GameStartingView extends StatefulWidget {
  const GameStartingView({super.key, required this.changeGamestate});
  final Function changeGamestate;

  @override
  State<GameStartingView> createState() => _GameStartingViewState();
}

class _GameStartingViewState extends State<GameStartingView> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Countdown(
      seconds: 3,
      build: (BuildContext context, double time) => Text(
        NumberFormat("0", "en_US").format(time).toString(),
        style: const TextStyle(fontSize: 24),
      ),
      onFinished: () {
        if (Player().isManager) {
          widget.changeGamestate('running');
        }
      },
    ));
  }
}
