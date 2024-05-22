import 'package:flutter/material.dart';
import 'package:the_lifecounter/utlis.dart';
import 'package:the_lifecounter/player.dart';

import 'player_card_components.dart';
import 'settings_widget.dart';


class PlayerCard extends StatefulWidget {
  const PlayerCard({
    super.key,
    required this.player,
  });

  final Player player;

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  var settings = false;
  List selectedButtons = ["othersMinusOne"];
  late Player _player = widget.player;
  
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
    return ListenableBuilder(
      listenable: _player,
      builder: (context, child) {
      return DecoratedBox(
        decoration: 
          BoxDecoration(
            image: DecorationImage(
              opacity: 0.5,
              image: AssetImage(getImage(_player.background))
            )
        ),
        child: Container(
            padding: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey)
              ),
            child: Stack(
              children: [
                if (settings) SettingsWidget(
                  selectedButtons: selectedButtons, 
                  setButtons: setButtons, 
                  player: _player,
                  ) else Column(
                    children: [
                      CommanderDamageRow(player: _player),
                      LifeCounter(widget: widget, player: _player,),
                      CustomButtonRow(widget: widget, player: _player, selectedButtons: selectedButtons),
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
    );
  }
}
