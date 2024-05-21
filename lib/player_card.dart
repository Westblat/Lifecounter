import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
import 'package:first_app/utlis.dart';
import 'package:flutter/widgets.dart';

import 'settings_widget.dart';


class PlayerCard extends StatefulWidget {
  const PlayerCard({
    super.key,
    required this.appState,
    required this.player,
  });

  final MyAppState appState;
  final player;

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  var settings = false;
  List selectedButtons = ["othersMinusOne"];
  late int thisPlayerNumber = widget.player["number"];
  


  String getLife(player) {
      return player["lifetotal"].toString();
  }
  
  void toggleSettings() {
    setState(() {
      settings = !settings;
    });
  }

  Widget getButton(String button){
    return switch(button) {
      "allMinusOne" => ElevatedButton(onPressed: () {widget.appState.changeLifeAllPlayers(-1);}, child: Text("-1 /  -1")),
      "othersMinusOne" => ElevatedButton(onPressed: () {widget.appState.changeLifeNotOne(-1, thisPlayerNumber);}, child: Text("0 / -1")),
      "othersMinusOnePlayerPlusOne" => ElevatedButton(onPressed: () {widget.appState.changeLifeAllOneDifferent(-1, thisPlayerNumber, 1);}, child: Text("+1 / -1")),
      "poison" => ButtonWithState(image: AssetImage("lib/background_images/phyrexian.png")),
      "experience" => ButtonWithState(image: AssetImage("lib/background_images/experience.png")),
      _=> throw Exception("Unrecognized button"),
    };
  }

  void setButtons(String button) {
    setState(() {
      if (selectedButtons.contains(button)) {selectedButtons.remove(button);}
      else {selectedButtons.add(button);}
    });
  }
  

  @override
  Widget build(BuildContext context) {
    var otherPLayers = widget.appState.getOtherPlayers(thisPlayerNumber);
    var commanderDamage = widget.appState.commanderDamage;
    return DecoratedBox(
      decoration: 
        BoxDecoration(
          image: DecorationImage(
            opacity: 0.5,
            image: AssetImage(getImage(widget.player?["background"]))
          )
      ),
      child: Container(
          padding: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey)
            ),
          child: Stack(
            children: [
              if (settings) SettingsWidget(
                selectedButtons: selectedButtons, 
                setButtons: setButtons, 
                changeBackground: widget.appState.changeBackground, 
                playerNumber: thisPlayerNumber,
                ) else Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (var player in otherPLayers.values)
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: () => {widget.appState.dealCommanderDamage(thisPlayerNumber, player["player"], -1)},
                                    onLongPress: () => {widget.appState.dealCommanderDamage(thisPlayerNumber, player["player"], -1)},
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
                                          commanderDamage[thisPlayerNumber][player["player"]].toString(), 
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
                    ),
                    Expanded(
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
                                Text(getLife(widget.player), style: TextStyle(fontSize: 30)),
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
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (String button in selectedButtons)
                          getButton(button),
                        if(selectedButtons.isEmpty) SizedBox(height: 45,)
                      ],
                          
                      ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(icon: Icon(Icons.more_vert), onPressed: toggleSettings,)
                ),
            ],
          ),
      ),
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