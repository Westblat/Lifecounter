import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
import 'package:first_app/utlis.dart';

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
      "othersMinusOnePlayerPlusOne" => ElevatedButton(onPressed: () {widget.appState.changeLifeAllOneDifferent(-1, thisPlayerNumber, 1);}, child: Text("+1 / -")),
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
    return DecoratedBox(
      decoration: 
        BoxDecoration(
          image: DecorationImage(
            opacity: 0.5,
            image: AssetImage(getImage(widget.player?["background"]))
          )
      ),
      child: settings 
      ? SettingsWidget(
        toggleSettings: toggleSettings, 
        selectedButtons: selectedButtons, 
        setButtons: setButtons, 
        changeBackground: widget.appState.changeBackground, 
        playerNumber: thisPlayerNumber,
        ) 
      :  Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(icon: Icon(Icons.more_horiz), onPressed: toggleSettings,)
                ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.player["lifeChange"] != 0 ? Text("${widget.player["lifeChange"]}", style: TextStyle(fontSize: 20)) : SizedBox(height: 29,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                iconSize: 20,
                                onPressed: () {
                                  widget.appState.changeLife(thisPlayerNumber, 1);
                                },
                                icon: Icon(Icons.add),
                                ),
                              Text(getLife(widget.player), style: TextStyle(fontSize: 30)),
                              IconButton(
                                onPressed: () {
                                  widget.appState.changeLife(thisPlayerNumber, -1);
                                },
                                icon: Icon(Icons.remove),
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
                              getButton(button)
                          ],
                      ),
                      SizedBox(height: 30,)
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }
}
