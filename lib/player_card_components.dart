import 'package:first_app/player_card.dart';
import 'package:first_app/utlis.dart';
import 'package:flutter/material.dart';

class LifeCounter extends StatelessWidget {
  const LifeCounter({
    super.key,
    required this.widget,
    required this.thisPlayerNumber,
  });

  final PlayerCard widget;
  final int thisPlayerNumber;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.player["lifeChange"] != 0 
            ? Text("${widget.player["lifeChange"]}", style: TextStyle(fontSize: 20)) 
            : SizedBox(height: 29,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: IconButton(
                    iconSize: 40,
                    onPressed: () {
                      widget.appState.changeLife(thisPlayerNumber, 1);
                    },
                    icon: Icon(Icons.add),
                    ),
                ),
                Text(widget.player["lifetotal"].toString(), style: TextStyle(fontSize: 30)),
                Expanded(
                  child: IconButton(
                    iconSize: 50,
                    onPressed: () {
                      widget.appState.changeLife(thisPlayerNumber, -1);
                    },
                    icon: Icon(Icons.remove),
                    ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class CommanderDamage extends StatelessWidget {
  const CommanderDamage({
    super.key,
    required this.otherPLayers,
    required this.commanderDamage,
    required this.thisPlayerNumber,
    required this.dealCommanderDamage,
  });

  final Map otherPLayers;
  final Map commanderDamage;
  final int thisPlayerNumber;
  final Function(int, int, int) dealCommanderDamage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var player in otherPLayers.values)
                Expanded(
                  child: MaterialButton(
                    onPressed: () => {dealCommanderDamage(thisPlayerNumber, player["player"], -1)},
                    onLongPress: () => {dealCommanderDamage(thisPlayerNumber, player["player"], -1)},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(getImage(player["background"])), opacity: 0.3)
                      ),
                      child: 
                      commanderDamage[thisPlayerNumber][player["player"]] != 0 ? 
                      Center(
                        child: Text(
                          commanderDamage[thisPlayerNumber][player["player"].toString()], 
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