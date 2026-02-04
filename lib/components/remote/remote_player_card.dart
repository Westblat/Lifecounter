import 'package:flutter/material.dart';
import 'package:the_lifecounter/components/common/commander_damage_row.dart';
import 'package:the_lifecounter/components/common/life_counter.dart';
import 'package:the_lifecounter/components/common/player_card_buttons.dart';
import 'package:the_lifecounter/components/common/settings_widget.dart';
import 'package:the_lifecounter/functions/player.dart';
import 'package:the_lifecounter/functions/utlis.dart';
import 'package:the_lifecounter/state/game_state.dart';

class RemotePlayerCard extends StatefulWidget {
  const RemotePlayerCard({
    super.key,
    required this.player,
    required this.state,
    required this.send,
    required this.onDisconnect,
  });

  final Player player;
  final GameState state;
  final void Function(String action, Map<String, dynamic> payload) send;
  final VoidCallback onDisconnect;

  @override
  State<RemotePlayerCard> createState() => _RemotePlayerCardState();
}

class _RemotePlayerCardState extends State<RemotePlayerCard>
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
    if (settings) {
      _animationController.reverse();
      Future.delayed(const Duration(milliseconds: 300), () {
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
      if (selectedButtons.contains(button)) {
        selectedButtons.remove(button);
      } else {
        selectedButtons.add(button);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    final state = widget.state;
    double width = MediaQuery.of(context).size.width;
    return DecoratedBox(
      decoration: getDecoration(player),
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey)),
        child: Stack(
          children: [
            if (settings)
              AnimatedBuilder(
                  animation: _animationController,
                  child: SettingsWidget(
                    selectedButtons: selectedButtons,
                    setButtons: setButtons,
                    player: player,
                    onChangeBackground: (bg) => widget.send(
                        'changeBackground',
                        {'player': player.playerNumber, 'background': bg}),
                    onToggleIcon: () => widget
                        .send('toggleIcon', {'player': player.playerNumber}),
                    onToggleBlur: () => widget
                        .send('toggleBlur', {'player': player.playerNumber}),
                    extraActions: [
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Disconnect'),
                        onTap: widget.onDisconnect,
                      ),
                    ],
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
                  if (state.gameMode == 'commander')
                    CommanderDamageRow(
                      player: player,
                      state: state,
                      onDealDamage: (from, delta) => widget.send(
                        'dealCommanderDamage',
                        {
                          'player': player.playerNumber,
                          'from': from,
                          'delta': delta
                        },
                      ),
                    ),
                  Expanded(
                    child: LifeCounter(
                      player: player,
                      onChangeLife: (delta) => widget.send('changeLife',
                          {'player': player.playerNumber, 'delta': delta}),
                    ),
                  ),
                  if (width > 289)
                    CustomButtonRow(
                        player: player,
                        selectedButtons: selectedButtons,
                        onChangeLife: (delta) => widget.send('changeLife',
                            {'player': player.playerNumber, 'delta': delta}),
                        onChangeLifeAllPlayers: (delta) =>
                            widget.send('changeLifeAllPlayers', {'delta': delta}),
                        onChangeLifeOthers: (delta) => widget.send(
                            'changeLifeOthers',
                            {'player': player.playerNumber, 'delta': delta}),
                        onChangeLifeOthersAndSelf: (othersDelta, selfDelta) =>
                            widget.send('changeLifeOthersAndSelf', {
                              'player': player.playerNumber,
                              'othersDelta': othersDelta,
                              'selfDelta': selfDelta
                            }),
                        onChangePoison: (delta) => widget.send('changePoison',
                            {'player': player.playerNumber, 'delta': delta}),
                        onChangeExperience: (delta) => widget.send(
                            'changeExperience',
                            {'player': player.playerNumber, 'delta': delta})),
                ],
              ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: toggleSettings,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
