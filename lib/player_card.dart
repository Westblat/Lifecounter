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
