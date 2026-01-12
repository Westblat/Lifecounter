import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_lifecounter/functions/utlis.dart';
import 'package:the_lifecounter/state/game_state.dart';

import 'commander_damage_row.dart';
import 'life_counter.dart';
import 'player_card_buttons.dart';
import 'settings_widget.dart';

class PlayerCard extends ConsumerStatefulWidget {
  const PlayerCard({
    super.key,
    required this.playerNumber,
    this.standard = false,
  });
  final int playerNumber;
  final bool standard;

  @override
  ConsumerState<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends ConsumerState<PlayerCard>
    with SingleTickerProviderStateMixin {
  var settings = false;
  List<String> selectedButtons = ["othersMinusOne"];
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
    final player = ref.watch(playerProvider(widget.playerNumber));
    double width = MediaQuery.of(context).size.width;
    return DecoratedBox(
      decoration: getDecoration(player),
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey)),
        child: Stack(
          children: [
            if (settings)
              AnimatedBuilder(
                  animation: _animationController,
                  child: SettingsWidget(
                    selectedButtons: selectedButtons,
                    setButtons: setButtons,
                    playerNumber: player.playerNumber,
                  ),
                  builder: (context, child) => SlideTransition(
                        position: Tween(
                          begin: const Offset(0, 1),
                          end: const Offset(0, 0),
                        ).animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeInOut)),
                        child: child,
                      ))
            else
              Column(
                children: [
                  if (!widget.standard)
                    CommanderDamageRow(playerNumber: player.playerNumber),
                  Expanded(
                    child: LifeCounter(
                      player: player,
                    ),
                  ),
                  if (width > 289)
                    CustomButtonRow(
                        player: player,
                        selectedButtons: selectedButtons),
                ],
              ),
            Align(
                alignment: Alignment.bottomLeft,
                child: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: toggleSettings,
                )),
          ],
        ),
      ),
    );
  }
}
