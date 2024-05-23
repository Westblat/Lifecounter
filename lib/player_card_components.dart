import 'package:the_lifecounter/player_card.dart';
import 'package:the_lifecounter/utlis.dart';
import 'package:flutter/material.dart';
import 'package:the_lifecounter/player.dart';


class LifeCounter extends StatelessWidget {
  const LifeCounter({
    super.key,
    required this.widget,
    required this.player,
  });

  final PlayerCard widget;
  final Player player;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(                  
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      MaterialButton(
                        height: 40,
                        onPressed: () {
                          player.changeLife(-5);
                        },
                        child: Text("-5"),
                        ),
                      MaterialButton(
                        height: 60,
                        onPressed: () {
                          player.changeLife(-1);
                        },
                        child: Icon(Icons.remove, size: 50,),
                        ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    player.lifeChange != 0 
                    ? Text("${player.lifeChange}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)) 
                    : SizedBox(height: 36,),
                    Text(player.lifeAsString(), style: TextStyle(fontSize: 50, height: 0.7)),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      MaterialButton(
                        height: 40,
                        onPressed: () {
                          player.changeLife(5);
                        },
                        child: Text("+5"),
                        ),
                      MaterialButton(
                        height: 60,
                        onPressed: () {
                          player.changeLife(1);
                        },
                        child: Icon(Icons.add, size: 50,),
                        ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class CommanderDamageRow extends StatelessWidget {
  const CommanderDamageRow({
    super.key,
    required this.player,
  });

  final Player player;

  List<Player> getOtherPlayerOrder() {
    var otherPlayers = player.otherPlayers;
    var order = player.yourPlayerOrder();
    otherPlayers.sort((a,b) => Comparable.compare(order.indexOf(a.playerNumber), (order.indexOf(b.playerNumber))));
    return otherPlayers;
  } 
  
  @override
  Widget build(BuildContext context) {
    List<Player> order = getOtherPlayerOrder();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var otherPlayer in order)
                Expanded(
                  child: MaterialButton(
                    onPressed: () => {player.dealCommanderDamage(-1, otherPlayer)},
                    onLongPress: () => {player.dealCommanderDamage(1, otherPlayer)},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(getImage(otherPlayer.background)), opacity: 0.3)
                      ),
                      child: 
                      player.commanderDamage[otherPlayer.playerNumber] != 0 ? 
                      Center(
                        child: Text(
                          player.commanderDamage[otherPlayer.playerNumber].toString(),
                          textAlign: TextAlign.center, 
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      )
                      : null
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class CustomButtonRow extends StatelessWidget {
  const CustomButtonRow({
    super.key,
    required this.widget,
    required this.player,
    required this.selectedButtons,
  });

  final List selectedButtons;
  final PlayerCard widget;
  final Player player;


  Widget getButton(String button, Player player){
    return switch(button) {
      "allMinusOne" => ElevatedButton(
        onPressed: () {player.changeLifeAllPlayers(-1);},
        onLongPress: () {player.changeLifeAllPlayers(1);}, child: Text("-1 /  -1")),
      "othersMinusOne" => ElevatedButton(
        onPressed: () {player.changeLifeOthers(-1);}, 
        onLongPress: () {player.changeLifeOthers(1);}, child: Text("0 / -1")),
      "othersMinusOnePlayerPlusOne" => ElevatedButton(
        onPressed: () {player.changeLifeOthersAndSelf(-1, 1);}, 
        onLongPress: () {player.changeLifeOthersAndSelf(1, -1);}, child: Text("+1 / -1")),
      "poison" => PoisonButton(player: player),
      "experience" => ExperienceButton(player: player,),
      _=> throw Exception("Unrecognized button"),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (String button in selectedButtons)
          getButton(button, player),
        if(selectedButtons.isEmpty) SizedBox(height: 45,)
      ],
          
      );
  }
}

class PoisonButton extends StatelessWidget {
  PoisonButton({
    super.key,
    required this.player,
  });
  final Player player;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => {player.changePoison(1)},
      onLongPress: () => {player.changePoison(-1)},
        child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("lib/background_images/phyrexian.png"), opacity: 0.3)
        ),
        child: 
        player.poison != 0 ? 
        Center(
          child: Text(
            player.poison.toString(), 
            textAlign: TextAlign.center, 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
        )
        : null
      ),
    );
  }
}

class ExperienceButton extends StatelessWidget {
  ExperienceButton({
    super.key,
    required this.player,
  });
  final Player player;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => {player.changeExperience(1)},
      onLongPress: () => {player.changeExperience(-1)},
        child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("lib/background_images/experience.png"), opacity: 0.3)
        ),
        child: 
        player.experience != 0 ? 
        Center(
          child: Text(
            player.experience.toString(), 
            textAlign: TextAlign.center, 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
        )
        : null
      ),
    );
  }
}
