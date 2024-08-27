import 'package:flutter/material.dart';
import 'package:the_lifecounter/player.dart';
import 'package:the_lifecounter/player_card.dart';


class DefaultLayout extends StatelessWidget {
  const DefaultLayout({
    super.key,
    required this.players,
  });
  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    var leftSide = [];
    var rigthSide = [];

    for(Player player in players) {
      if(player.playerNumber % 2 == 0) {leftSide.add(player);}
      else {rigthSide.add(player);}
    }
    return Row(
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
    );
  }
}

class PlayersBothEndLayout extends StatelessWidget {
  const PlayersBothEndLayout({
    super.key,
    required this.players,
  });
  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    int verticalPlayerCount = (((players.length -2 ) / 2)).ceil() + 2;
    double height = MediaQuery.of(context).size.height / verticalPlayerCount;

    var leftSide = [];
    var rigthSide = [];
    
    for(Player player in players) {
      if(player.playerNumber == 1 || player.playerNumber == 2) {}
      else if(player.playerNumber % 2 == 0) {leftSide.add(player);}
      else {rigthSide.add(player);}
    }
    return Column(
      children: [
        SizedBox(
          height: height,
          child: 
            RotatedBox(
              quarterTurns: 2,
              child: PlayerCard(player: players[0])
            ),
          ),
        Expanded(
          child: Row(
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
        ),
        SizedBox(
          height: height,
          child: 
            PlayerCard(player: players[1])
        ),

      ],
    );
  }
}

class PlayersOneEndLayout extends StatelessWidget {
  const PlayersOneEndLayout({
    super.key,
    required this.players,
  });
  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    int verticalPlayerCount = (((players.length - 1 ) / 2)).ceil() + 2;
    double height = MediaQuery.of(context).size.height / verticalPlayerCount;

    var leftSide = [];
    var rigthSide = [];

    for(Player player in players) {
      if(player.playerNumber == 1 ) {}
      else if(player.playerNumber % 2 == 0) {leftSide.add(player);}
      else {rigthSide.add(player);}
    }

    return Column(
      children: [
        SizedBox(
          height: height,
          child: 
            RotatedBox(
              quarterTurns: 2,
              child: PlayerCard(player: players[0])
            ),
          ),
        Expanded(
          child: Row(
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
        ),
      ],
    );
  }
}