import 'package:flutter/material.dart';
import 'package:the_lifecounter/utlis.dart';
import 'dart:async';

class Player with ChangeNotifier {
  Player({
    required this.playerNumber,
    required this.getOtherPlayers,
  });

  final int playerNumber;
  final Function getOtherPlayers;

  int life = 40;
  late String background = allBackgrounds[playerNumber % allBackgrounds.length];
  int lifeChange = 0;
  Timer? timer;
  late List<Player> otherPlayers = getOtherPlayers(this);
  late Map commanderDamage = initCommanderDamage(); 

  Map initCommanderDamage() {
    Map emptyCommanderDamages = {};
    for (Player player in otherPlayers) {
        emptyCommanderDamages[player.playerNumber] = 0;
    }
    return emptyCommanderDamages;
  }
  
  void setTimer() {
    if (timer != null) timer?.cancel();
    timer = Timer(Duration(seconds: 3), () {
        lifeChange = 0;
        notifyListeners();
      });
  }

  void changeLife(int damage) {
      life += damage;
      lifeChange += damage;
      notifyListeners();
      setTimer();
  }

  void changeBackground(String newBackground) {
    background = newBackground;
    notifyListeners();
  }

  void resetLife() {
    life = 40;
    notifyListeners();
  }

  String lifeAsString () {
    return life.toString();
  }

  void dealCommanderDamage(int damage, Player targetPlayer) {
    targetPlayer.changeLife(damage);
    commanderDamage[targetPlayer.playerNumber] = commanderDamage[targetPlayer.playerNumber] + -damage;
    notifyListeners();
  }

  void changeLifeAllPlayers(life) {
    changeLife(life);
    for (Player player in otherPlayers) {
      player.changeLife(life);
    }
  }

  void changeLifeOthers(int life) {
    for (Player player in otherPlayers) {
      player.changeLife(life);
    }
  }

  void changeLifeOthersAndSelf(int othersLife, int selfLife) {
    changeLife(selfLife);
    for (Player player in otherPlayers) {
      player.changeLife(othersLife);
    }
  }

  void newPlayerAdded() {
    otherPlayers = getOtherPlayers(this);
    commanderDamage[otherPlayers.last.playerNumber] = 0;
    notifyListeners();
  }
}