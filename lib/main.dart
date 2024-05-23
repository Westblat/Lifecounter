import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:the_lifecounter/player.dart';

import 'package:the_lifecounter/player_card.dart'; 

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
        title: 'The Lifecounter',
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
  List<Player> getOtherPlayers(Player currentPlayer) {
    List<Player> otherPlayers = List.from(players);
    otherPlayers.removeWhere((player) => player == currentPlayer);
    return otherPlayers;
  }

  late List<Player> players = [
    Player(playerNumber: 1, getOtherPlayers: getOtherPlayers),
    Player(playerNumber: 2, getOtherPlayers: getOtherPlayers),
    Player(playerNumber: 3, getOtherPlayers: getOtherPlayers),
    Player(playerNumber: 4, getOtherPlayers: getOtherPlayers),
  ];

  void restartGame() {
    for (Player player in players) {
      player.resetGame();
    }
  }

  void addPlayer() {
    players.add(Player(playerNumber: players.length + 1, getOtherPlayers: getOtherPlayers));
    for(Player player in players) {
      player.newPlayerAdded();
    }
    notifyListeners();
  }

  void removePlayer(){
    players.removeLast();
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
    var leftSide = [];
    var rigthSide = [];

    for(Player player in appState.players) {
      if(player.playerNumber % 2 == 0) {leftSide.add(player);}
      else {rigthSide.add(player);}
    }

    void showGlobalSettins() {
      setState(() {
        globalSettingsVisible = !globalSettingsVisible;
      });
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
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
                                child: PlayerCard(player: player)
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
                                child: PlayerCard(player: player)
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
