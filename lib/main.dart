import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:the_lifecounter/components/global_settings.dart';
import 'package:the_lifecounter/functions/player.dart';

import 'components/layouts.dart'; 

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
  String layout = "default";
  void setLayout(String newLayout) {
      layout = newLayout;
      notifyListeners();
  }
  String gameMode = 'commander';

  List<Player> getOtherPlayers(Player currentPlayer) {
    if (gameMode == 'standard') return getOtherPlayersStandard(currentPlayer);
    return getOtherPlayersCommander(currentPlayer);
  }


  List<Player> getOtherPlayersCommander(Player currentPlayer) {
    List<Player> otherPlayers = List.from(players);
    otherPlayers.removeWhere((player) => player == currentPlayer);
    return otherPlayers;
  }

  List<Player> getOtherPlayersStandard(Player currentPlayer) {
    // Players are paired as 1 and 2, meaning that numbers modulo 2 that are 0 are pared with the lower person 
    List<Player> otherPlayers;
    if(currentPlayer.playerNumber % 2 == 0){
      otherPlayers = players.where((player) => player.playerNumber == currentPlayer.playerNumber - 1).toList();
    } else {
      otherPlayers = players.where((player) => player.playerNumber == currentPlayer.playerNumber + 1).toList();
    }
    return otherPlayers;
  }


  late List<Player> players = [
    Player(playerNumber: 1, getOtherPlayers: getOtherPlayers),
    Player(playerNumber: 2, getOtherPlayers: getOtherPlayers),
    Player(playerNumber: 3, getOtherPlayers: getOtherPlayers),
    Player(playerNumber: 4, getOtherPlayers: getOtherPlayers),
  ];

  void setGameMode(String newGameMode){
    gameMode = newGameMode;
    for (Player player in players) {
      player.setGameMode(newGameMode);
      player.resetGame();
    }
  }

  void restartGame() {
    for (Player player in players) {
      player.resetGame();
    }
  }

  void resetStandard(Player resetPlayer) {
    final resetPlayers = players.where((player) => player.playerNumber == resetPlayer.playerNumber || player.playerNumber == resetPlayer.playerNumber - 1);
    print(resetPlayer);
    print(resetPlayers);
    for (var player in resetPlayers) {
      player.resetGame();
    }
  }

  void addPlayer() {
    if (gameMode == "standard") {
      // Standard is two player game, has to add two people at the time
      players.add(Player(playerNumber: players.length + 1, getOtherPlayers: getOtherPlayers, gameMode: 'standard'));
      for(Player player in players) {
        player.newPlayerAdded();
      }
      players.add(Player(playerNumber: players.length + 1, getOtherPlayers: getOtherPlayers, gameMode: 'standard'));
      for(Player player in players) {
        player.newPlayerAdded();
      }
    } else {
      players.add(Player(playerNumber: players.length + 1, getOtherPlayers: getOtherPlayers));
      for(Player player in players) {
        player.newPlayerAdded();
      }
    }
    notifyListeners();
  }

  void removePlayer(){
    if(gameMode == 'standard') {
      players.removeLast();
      for(Player player in players) {
        player.playerRemoved();
      }
      players.removeLast();
      for(Player player in players) {
        player.playerRemoved();
      }
    }else {
      players.removeLast();
      for(Player player in players) {
        player.playerRemoved();
      }
    }
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

    void showGlobalSettings() {
      setState(() {
        globalSettingsVisible = !globalSettingsVisible;
      });
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                switch (appState.layout) {
                    "default" => DefaultLayout(players: appState.players),
                    "bothEnds" => PlayersBothEndLayout(players: appState.players),
                    "oneEnd" => PlayersOneEndLayout(players: appState.players,),
                    "standard" => StandardLayout(players: appState.players),
                    String() => throw UnimplementedError(),
                  },
              Align(
                alignment: Alignment.center,
                child: IconButton(onPressed: showGlobalSettings, icon: Icon(Icons.settings)),
              ),
              if(globalSettingsVisible) Align(
                alignment: Alignment.center,
                child: GlobalSettings(),
              )
              ],
            ),
          ),        
        );
      }
    );
  }
}
