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

class _PlayerCardState extends State<PlayerCard> with SingleTickerProviderStateMixin {

  var settings = false;
  List selectedButtons = ["othersMinusOne"];
  late Player _player = widget.player;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleSettings() {
    if(settings) {
      _animationController.reverse();
      Future.delayed(Duration(milliseconds: 300), (){
        setState(() {
          settings = !settings;
        });
      });
    } else {
      setState(() {
      settings = !settings;
      _animationController.forward();
    });
    }
    
  }

  void setButtons(String button) {
    setState(() {
      if (selectedButtons.contains(button)) {selectedButtons.remove(button);}
      else {selectedButtons.add(button);}
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                if (settings) AnimatedBuilder(
                  animation: _animationController,
                  child: SettingsWidget(
                    selectedButtons: selectedButtons, 
                    setButtons: setButtons, 
                    player: _player,
                    ),
                    builder: (context, child) => SlideTransition(
                      position: 
                      Tween(
                        begin: const Offset(0, 1), 
                        end: const Offset(0, 0)
                      ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)), 
                  child: child,)
                ) else Column(
                    children: [
                      CommanderDamageRow(player: _player),
                      LifeCounter(widget: widget, player: _player,),
                      if(width > 289) CustomButtonRow(widget: widget, player: _player, selectedButtons: selectedButtons),
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
