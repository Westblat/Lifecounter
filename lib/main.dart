import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:the_lifecounter/player.dart';

import 'layouts.dart'; 

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
    for(Player player in players) {
      player.playerRemoved();
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

class GlobalSettings extends StatelessWidget {
  const GlobalSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return SizedBox(
      height: 250,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: appState.restartGame, icon: Icon(Icons.restart_alt_rounded), iconSize: 50,)
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: appState.addPlayer, icon: Icon(Icons.add_circle_outline), iconSize: 50,),
                SizedBox(width: 40,),
                IconButton(onPressed: appState.removePlayer, icon: Icon(Icons.remove_circle_outline), iconSize: 50,)
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: const Color.fromARGB(255, 82, 82, 82),
                      width: 4, 
                    )
                  ),
                  child: IconButton(onPressed: () => appState.setLayout("default"), icon: Image.asset("lib/custom_icons/default_icon.png", height: 50, width: 50,), )
                  ),
                  const SizedBox(width: 5,),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        color: const Color.fromARGB(255, 82, 82, 82),
                        width: 4, 
                      )
                    ),
                  child: IconButton(onPressed: () => appState.setLayout("bothEnds"), icon: Image.asset("lib/custom_icons/both_ends_icon.png", height: 50, width: 50,), )
                  ),
                  const SizedBox(width: 5,),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        color: const Color.fromARGB(255, 82, 82, 82),
                        width: 4, 
                      )
                    ),
                  child: IconButton(onPressed: () => appState.setLayout("oneEnd"), icon: Image.asset("lib/custom_icons/one_end_icon.png", height: 50, width: 50,), )
                  ),
              ],
            ),
          ],
      ),
    );
  }
}
