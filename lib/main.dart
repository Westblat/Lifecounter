import 'dart:async';

import 'package:flutter/material.dart';
 import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:first_app/player_card.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}


class MyAppState extends ChangeNotifier {
  var players = {
    1: {"player": 1, "lifetotal": 40, "background": "monored", "lifeChange": 0},
    2: {"player": 2, "lifetotal": 40, "background": "monogreen", "lifeChange": 0},
    3: {"player": 3, "lifetotal": 40, "background": "monowhite", "lifeChange": 0},
    4: {"player": 4, "lifetotal": 40, "background": "monoblack", "lifeChange": 0},
  };

  void func(int playerNumber, Map emptyCommanderDamages) {
      var otherPlayers = getOtherPlayers(playerNumber);
      for (var other in otherPlayers.values) {
        emptyCommanderDamages[playerNumber] = {
          ...emptyCommanderDamages[playerNumber],
          other["player"]: 0
        };
      }
  }
  
  Map initializeCommanderDamage() {
    Map emptyCommanderDamages = {};
    for (var number in players.keys ) {
      emptyCommanderDamages[number]= {};
    }
    players.forEach((playerNumber, _) => func(playerNumber, emptyCommanderDamages));
    return emptyCommanderDamages;
  }

  late var commanderDamage = initializeCommanderDamage();
  var timer;
  
  void changeLife(player, int life) {
    var oldValue = players[player] ?? {"player": "", "lifetotal": 0};
    var oldLife = oldValue["lifetotal"] as int;
    var lifeChange = oldValue["lifeChange"] as int;
    players[player] = {...oldValue, "lifetotal": oldLife + life, "lifeChange": lifeChange + life};
    notifyListeners();
    if (timer != null) timer.cancel();
    timer = Timer(Duration(seconds: 3), () {
      players.forEach((player, _) {
        var playerData = players[player]  ?? {"player": "", "lifetotal": 0};
        players[player] = {...playerData, "lifeChange": 0};
      });
      notifyListeners();
      });
  }

  void changeLifeAllPlayers(life) {
    players.forEach((playerNumber, _) {
      changeLife(playerNumber, life);
    });
  }

  void changeLifeNotOne(life, player) {
    players.forEach((playerNumber, _) {
      if (playerNumber != player) changeLife(playerNumber, life);
    });
  }

  void changeLifeAllOneDifferent(multiplePeopleLife, player, singlePersonLife) {
    players.forEach((playerNumber, _) {
      if (playerNumber != player) changeLife(playerNumber, multiplePeopleLife);
      if (playerNumber == player) changeLife(player, singlePersonLife);
    });
  }

  void changeBackground(playerNumber, newBackground) {
    var oldValue = players[playerNumber] ?? {"player": "", "lifetotal": 0};
    players[playerNumber] = {...oldValue, "background": newBackground};
    notifyListeners();  
  }

  void restartGame() {
    players.forEach((playerNumber, player) {
        var oldValue = player;
        players[playerNumber] = {...oldValue, "lifetotal": 40};
    });
    notifyListeners();
  }

  void dealCommanderDamage(int activePlayer, int targetPlayer, int damage) {
    changeLife(targetPlayer, damage);
    var oldCommanderDamage = commanderDamage[activePlayer] ?? {targetPlayer: 0};
    if(oldCommanderDamage[targetPlayer] != null) {
      commanderDamage[activePlayer] = {...oldCommanderDamage, targetPlayer: oldCommanderDamage[targetPlayer] + -damage};
    }
    else {
      commanderDamage[activePlayer] = {...oldCommanderDamage, targetPlayer: 1};
    }
    notifyListeners();
  }

  Map getOtherPlayers(yourPlayerNumber) {
    var newPlayerList = Map.from(players);
    newPlayerList.removeWhere((player, _) => player == yourPlayerNumber);
    return newPlayerList;
  }

  void addPlayer() {
    var newPlayerCount = players.length + 1;
    players[newPlayerCount] = {"player": newPlayerCount, "lifetotal": 40, "background": "monogreen", "lifeChange": 0};
    commanderDamage = initializeCommanderDamage();
    notifyListeners();
  }

  void removePlayer(){
    players.remove(players.length);
    notifyListeners();
  }

}


class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var globalSettingsVisible = false;
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    int index = 0;
    var leftSide = [];
    var rigthSide = [];
    index = 0;
    appState.players.forEach((playerNumber, player) {
      if (index % 2 == 0) {
        leftSide.add({...player, "number": playerNumber});
      } else {
        rigthSide.add({...player, "number": playerNumber});
      }
      index++;
    });

    void showGlobalSettins() {
      setState(() {
        globalSettingsVisible = !globalSettingsVisible;
      });
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            title: Center(child: Text("The new lifecounter app")),
          ),
          body: Stack(
            children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                        for (var player in leftSide)
                          Expanded(
                            child: 
                                RotatedBox(
                                  quarterTurns: 1,
                                  child: PlayerCard(appState: appState, player: player)
                                  ),
                              ),
                    ],
                          ),
                ),
                
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      for (var player in rigthSide)
                          Expanded(
                            child: 
                                RotatedBox(
                                  quarterTurns: 3,
                                  child: PlayerCard(appState: appState, player: player)
                                  ),
                              ),
                  ],
                  ),
                ),
              ]
            ),
            Align(
              alignment: Alignment.center,
              child: IconButton(onPressed: showGlobalSettins, icon: Icon(Icons.settings)),
            ),
            if(globalSettingsVisible) Align(
              alignment: Alignment.center,
              child: GlobalSettings(),
            )
            ],
          ),        
        );
      }
    );
  }
}

class GlobalSettings extends StatelessWidget {
  const GlobalSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: appState.restartGame, icon: Icon(Icons.restart_alt_rounded), iconSize: 50,)
            ],
          ),
          SizedBox(height: 50,),
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: appState.addPlayer, icon: Icon(Icons.add_circle_outline), iconSize: 50,),
            IconButton(onPressed: appState.removePlayer, icon: Icon(Icons.remove_circle_outline), iconSize: 50,)
          ],
          ),
        ],
    );
  }
}
