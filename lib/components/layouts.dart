import 'package:flutter/material.dart';
import 'package:the_lifecounter/main.dart';
import 'package:the_lifecounter/functions/player.dart';
import 'package:the_lifecounter/components/player_card.dart';
import 'package:provider/provider.dart';

class HorizontalPlayerCards extends StatelessWidget {
  HorizontalPlayerCards({
    super.key,
    required this.leftSide,
    required this.rigthSide,
    this.standard = false,
  });

  final List<Player> leftSide;
  final List<Player> rigthSide;
  final bool standard;
  // Locations only support 4 people, with 0s it doesn't crash with more people
  final List<double> alignmentPoints = [-0.5, 0.5, 0,0,0,0,0,0];

  @override
  Widget build(BuildContext context) {    
    var appState = context.watch<MyAppState>();

    return Stack(
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
                          child: PlayerCard(player: player, standard: standard,)
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
                            child: PlayerCard(player: player, standard: standard,)
                          ),
                        ),
                ],
              ),
            ),
        ]
      ),
      if(standard)
      for(int restart = 0; restart < leftSide.length; restart++ )
        Align(
          alignment: Alignment(0, alignmentPoints[restart]),
          child: IconButton(onPressed: () => appState.resetStandard(leftSide[restart]), icon: Icon(Icons.restart_alt_rounded), iconSize: 50,),
        )
    ]
    );
  }
}



class DefaultLayout extends StatelessWidget {
  const DefaultLayout({
    super.key,
    required this.players,
  });
  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    List<Player> leftSide = [];
    List<Player> rigthSide = [];

    for(Player player in players) {
      if(player.playerNumber % 2 == 0) {leftSide.add(player);}
      else {rigthSide.add(player);}
    }
    return HorizontalPlayerCards(leftSide: leftSide, rigthSide: rigthSide);
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
    double height = (MediaQuery.of(context).size.height - 34) / verticalPlayerCount;

    List<Player> leftSide = [];
    List<Player> rigthSide = [];
    
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
          child: HorizontalPlayerCards(leftSide: leftSide, rigthSide: rigthSide),
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

    List<Player> leftSide = [];
    List<Player> rigthSide = [];

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
          child: HorizontalPlayerCards(leftSide: leftSide, rigthSide: rigthSide),
        ),
      ],
    );
  }
}


class StandardLayout extends StatelessWidget {
  const StandardLayout({
    super.key,
    required this.players,
  });
  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    List<Player> leftSide = [];
    List<Player> rigthSide = [];
    double height = (MediaQuery.of(context).size.height - 34) / 2;

    for(Player player in players) {
      if(player.playerNumber % 2 == 0) {leftSide.add(player);}
      else {rigthSide.add(player);}
    }

    if (players.length == 2) {
      return Column(
        children: [
          SizedBox(
            height: height, 
            child: 
              RotatedBox(
                quarterTurns: 2,
                child: PlayerCard(player: players[0], standard: true,)
              ),
            ),
          SizedBox(
            height: height,
            child: 
              PlayerCard(player: players[1], standard: true,)
          ),
        ],
      );
    }
    return HorizontalPlayerCards(leftSide: leftSide, rigthSide: rigthSide, standard: true);
  }
}

