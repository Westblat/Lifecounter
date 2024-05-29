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
  late String background = monoBackgrounds[playerNumber % monoBackgrounds.length];
  int lifeChange = 0;
  Timer? timer;
  late List<Player> otherPlayers = getOtherPlayers(this);
  late Map commanderDamage = initCommanderDamage();
  int poison = 0;
  int experience = 0;
  bool icon = true;

  @override
  String toString() {
    return "Player number $playerNumber $background";
  }


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

  void resetGame() {
    life = 40;
    poison = 0;
    experience = 0;
    commanderDamage = initCommanderDamage();
    notifyListeners();
  }

  String lifeAsString () {
    return life.toString();
  }

  void dealCommanderDamage(int damage, Player targetPlayer) {
    changeLife(damage);
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

  List<Player> getAllPlayers() {
    List<Player> allPlayers = List.from(otherPlayers);
    allPlayers.add(this);
    allPlayers.sort((a, b) => Comparable.compare(a.playerNumber, b.playerNumber));
    return allPlayers;
  }

  List<int> getPlayerOrder() {
    List<int> evenPlayers = [];
    List<int> oddPLayers = [];

    for (Player player in getAllPlayers()) {
      if(player.playerNumber % 2 == 0) {
        evenPlayers.add(player.playerNumber);
      } else {
        oddPLayers.add(player.playerNumber);
      }
    }
    return oddPLayers + evenPlayers.reversed.toList();
  }

  List<int> yourPlayerOrder() {
    var order = getPlayerOrder();
    int yourPlace = order.indexOf(playerNumber);
    return order.sublist(yourPlace + 1) + order.sublist(0,yourPlace);
  }

  void changePoison(int newPoison) {
    poison += newPoison;
    notifyListeners();
  }
  
  void changeExperience(int newExperience) {
    experience += newExperience;
    notifyListeners();
  }

  void toggleIcon() {
    icon = !icon;
    notifyListeners();
  }
}
