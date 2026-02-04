import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_lifecounter/components/common/commander_damage_row.dart';
import 'package:the_lifecounter/components/common/life_counter.dart';
import 'package:the_lifecounter/components/common/player_card_buttons.dart';
import 'package:the_lifecounter/components/common/settings_widget.dart';
import 'package:the_lifecounter/functions/utlis.dart';
import 'package:the_lifecounter/state/game_state.dart';

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
    final state = ref.watch(gameStateProvider);
    final player = state.players.firstWhere(
        (p) => p.playerNumber == widget.playerNumber,
        orElse: () => state.players.first);
    final controller = ref.read(gameStateProvider.notifier);
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
                    onChangeBackground: (bg) =>
                        controller.changeBackground(player.playerNumber, bg),
                    onToggleIcon: () =>
                        controller.toggleIcon(player.playerNumber),
                    onToggleBlur: () =>
                        controller.toggleBlur(player.playerNumber),
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
                    CommanderDamageRow(
                      player: player,
                      state: state,
                      onDealDamage: (from, delta) => controller
                          .dealCommanderDamage(
                              playerNumber: player.playerNumber,
                              fromPlayerNumber: from,
                              delta: delta),
                    ),
                  Expanded(
                    child: LifeCounter(
                      player: player,
                      onChangeLife: (delta) =>
                          controller.changeLife(player.playerNumber, delta),
                    ),
                  ),
                  if (width > 289)
                    CustomButtonRow(
                        player: player,
                        selectedButtons: selectedButtons,
                        onChangeLife: (delta) =>
                            controller.changeLife(player.playerNumber, delta),
                        onChangeLifeAllPlayers: (delta) =>
                            controller.changeLifeAllPlayers(delta),
                        onChangeLifeOthers: (delta) =>
                            controller.changeLifeOthers(
                                player.playerNumber, delta),
                        onChangeLifeOthersAndSelf: (othersDelta, selfDelta) =>
                            controller.changeLifeOthersAndSelf(
                                playerNumber: player.playerNumber,
                                othersDelta: othersDelta,
                                selfDelta: selfDelta),
                        onChangePoison: (delta) =>
                            controller.changePoison(player.playerNumber, delta),
                        onChangeExperience: (delta) => controller
                            .changeExperience(player.playerNumber, delta)),
                ],
              ),
            Align(
                alignment: Alignment.bottomLeft,
                child: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: toggleSettings,
                )),
          ],
        ),
      ),
    );
  }
}
