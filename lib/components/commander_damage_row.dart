import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_lifecounter/functions/utlis.dart';
import 'package:the_lifecounter/state/game_state.dart';

class CommanderDamageRow extends ConsumerWidget {
  const CommanderDamageRow({
    super.key,
    required this.playerNumber,
  });

  final int playerNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameStateProvider);
    final player = state.players.firstWhere((p) => p.playerNumber == playerNumber);
    final order = orderedOpponents(state, playerNumber);

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
                    onPressed: () => ref
                        .read(gameStateProvider.notifier)
                        .dealCommanderDamage(
                            playerNumber: playerNumber,
                            fromPlayerNumber: otherPlayer.playerNumber,
                            delta: -1),
                    onLongPress: () => ref
                        .read(gameStateProvider.notifier)
                        .dealCommanderDamage(
                            playerNumber: playerNumber,
                            fromPlayerNumber: otherPlayer.playerNumber,
                            delta: 1),
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
