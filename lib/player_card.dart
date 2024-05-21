import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
import 'package:first_app/utlis.dart';

import 'player_card_components.dart';
import 'settings_widget.dart';


class PlayerCard extends StatefulWidget {
  const PlayerCard({
    super.key,
    required this.appState,
    required this.player,
  });

  final MyAppState appState;
  final Map player;

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
            image: AssetImage(getImage(widget.player["background"]))
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
                    CommanderDamage(otherPLayers: otherPLayers, commanderDamage: commanderDamage, thisPlayerNumber: thisPlayerNumber, dealCommanderDamage: widget.appState.dealCommanderDamage,),
                    LifeCounter(widget: widget, thisPlayerNumber: thisPlayerNumber,),
                    CustomButtonRow(widget: widget, thisPlayerNumber: thisPlayerNumber, selectedButtons: selectedButtons),
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

class CustomButtonRow extends StatelessWidget {
  const CustomButtonRow({
    super.key,
    required this.widget,
    required this.thisPlayerNumber,
    required this.selectedButtons,
  });

  final List selectedButtons;
  final PlayerCard widget;
  final int thisPlayerNumber;


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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (String button in selectedButtons)
          getButton(button),
        if(selectedButtons.isEmpty) SizedBox(height: 45,)
      ],
          
      );
  }
}
