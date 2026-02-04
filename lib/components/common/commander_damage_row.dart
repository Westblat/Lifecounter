import 'package:flutter/material.dart';
import 'package:the_lifecounter/functions/utlis.dart';
import 'package:the_lifecounter/state/game_state.dart';
import 'package:the_lifecounter/functions/player.dart';

class CommanderDamageRow extends StatelessWidget {
  const CommanderDamageRow({
    super.key,
    required this.player,
    required this.state,
    required this.onDealDamage,
  });

  final Player player;
  final GameState state;
  final void Function(int fromPlayer, int delta) onDealDamage;

  @override
  Widget build(BuildContext context) {
    final order = orderedOpponents(state, player.playerNumber);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var otherPlayer in order)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey),
                    gradient: !isMonoColor(otherPlayer.background)
                        ? getGradient(otherPlayer.background, otherPlayer)
                        : null,
                    color: isMonoColor(otherPlayer.background)
                        ? getBackgroundColor(otherPlayer.background)
                        : null,
                  ),
                  child: MaterialButton(
                    onPressed: () =>
                        onDealDamage(otherPlayer.playerNumber, -1),
                    onLongPress: () =>
                        onDealDamage(otherPlayer.playerNumber, 1),
                    child: Container(
                        height: 48,
                        width: 40,
                        decoration: BoxDecoration(
                            image: player.icon
                                ? DecorationImage(
                                    opacity: 0.3,
                                    image:
                                        AssetImage(getImage(otherPlayer.background)),
                                  )
                                : null),
                        child: player.commanderDamage[otherPlayer.playerNumber] != 0
                            ? Center(
                                child: WhiteBorderText(
                                  text: player
                                      .commanderDamage[otherPlayer.playerNumber]
                                      .toString(),
                                  fontSize: 35,
                                  strokeWidth: 1,
                                ),
                              )
                            : null),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
