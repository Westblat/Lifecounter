import 'package:flutter/material.dart';
import 'package:the_lifecounter/player.dart';
import 'package:the_lifecounter/utlis.dart';

class CommanderDamageRow extends StatelessWidget {
  const CommanderDamageRow({
    super.key,
    required this.player,
  });

  final Player player;

  List<Player> getOtherPlayerOrder() {
    var otherPlayers = player.otherPlayers;
    var order = player.yourPlayerOrder();
    otherPlayers.sort((a,b) => Comparable.compare(order.indexOf(a.playerNumber), (order.indexOf(b.playerNumber))));
    return otherPlayers;
  } 
  
  @override
  Widget build(BuildContext context) {
    List<Player> order = getOtherPlayerOrder();
    return ListenableBuilder(
      listenable: Listenable.merge(order),
      builder: (context, child) {

    return 
        Column(
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
                        gradient: !isMonoColor(otherPlayer.background) ? getGradient(otherPlayer.background, otherPlayer) : null,
                        color: isMonoColor(otherPlayer.background) ? getBackgroundColor(otherPlayer.background) : null,
                      ),
                      child: MaterialButton(
                        onPressed: () => {player.dealCommanderDamage(-1, otherPlayer)},
                        onLongPress: () => {player.dealCommanderDamage(1, otherPlayer)},
                        child: Container(
                          height: 48,
                          width: 30, 
                          decoration: BoxDecoration(
                              image:player.icon ?  DecorationImage(
                                opacity: 0.3,
                                image: AssetImage(getImage(otherPlayer.background)
                                ),
                              ) : null
                              ),
                          child: 
                          player.commanderDamage[otherPlayer.playerNumber] != 0 ? 
                          Center(
                            child: WhiteBorderText(
                              text: player.commanderDamage[otherPlayer.playerNumber].toString(),
                              fontSize: 20,
                              strokeWidth: 1,
                            ),
                          )
                          : null
                        ),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      );
      }
        );
  }
}
