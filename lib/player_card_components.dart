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
          player.lifeChange != 0 
            ? Text("${player.lifeChange}", style: TextStyle(fontSize: 20)) 
            : SizedBox(height: 29,),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: IconButton(
                      iconSize: 40,
                      onPressed: () {
                        player.changeLife(1);
                      },
                      icon: Icon(Icons.add),
                      ),
                  ),
                  Text(player.lifeAsString(), style: TextStyle(fontSize: 30)),
                  Expanded(
                    child: IconButton(
                      iconSize: 50,
                      onPressed: () {
                        player.changeLife(-1);
                      },
                      icon: Icon(Icons.remove),
                      ),
                  ),
                ],
              ),
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
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var otherPlayer in player.otherPlayers)
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
      "allMinusOne" => ElevatedButton(onPressed: () {player.changeLifeAllPlayers(-1);}, child: Text("-1 /  -1")),
      "othersMinusOne" => ElevatedButton(onPressed: () {player.changeLifeOthers(-1);}, child: Text("0 / -1")),
      "othersMinusOnePlayerPlusOne" => ElevatedButton(onPressed: () {player.changeLifeOthersAndSelf(-1, 1);}, child: Text("+1 / -1")),
      "poison" => ButtonWithState(image: AssetImage("lib/background_images/phyrexian.png")),
      "experience" => ButtonWithState(image: AssetImage("lib/background_images/experience.png")),
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


class ButtonWithState extends StatefulWidget {
  const ButtonWithState({
    super.key,
    required this.image,
  });
  final AssetImage image;
  
  @override
  State<ButtonWithState> createState() => _ButtonWithStateState();
}

class _ButtonWithStateState extends State<ButtonWithState> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => {setState(() {
        counter++;
      })},
      onLongPress: () => {setState(() {
        counter -= 1;
      })},
        child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          image: DecorationImage(image: widget.image, opacity: 0.3)
        ),
        child: 
        counter != 0 ? 
        Center(
          child: Text(
            counter.toString(), 
            textAlign: TextAlign.center, 
            style: TextStyle(fontWeight: FontWeight.bold),
            ),
        )
        : null
      ),
    );
  }
}