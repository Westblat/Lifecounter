import 'package:the_lifecounter/player_card.dart';
import 'package:the_lifecounter/utlis.dart';
import 'package:flutter/material.dart';
import 'package:the_lifecounter/player.dart';


class LifeCounter extends StatelessWidget {
  const LifeCounter({
    super.key,
    required this.widget,
    required this.player,
  });

  final PlayerCard widget;
  final Player player;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(                  
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      if(width > 412)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MaterialButton(
                              height: 40,
                              onPressed: () {
                                player.changeLife(-5);
                              },
                              child: WhiteBorderText(text: "- 5", strokeWidth: 2,),
                              ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if(width < 412 && height > 567)
                            MaterialButton(
                              minWidth: 10,
                              height: 40,
                              onPressed: () {
                                player.changeLife(-5);
                              },
                              child: WhiteBorderText(text: "- 5", strokeWidth: 2),
                          ),
                          MaterialButton(
                            height: 60,
                            onPressed: () {
                              player.changeLife(-1);
                            },
                            child: WhiteBorderText(text: "–", fontSize: 50,),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    player.lifeChange != 0 
                    ? WhiteBorderText(text: "${player.lifeChange}", fontSize: 25) 
                    : SizedBox(height: 36,),
                    FittedBox(fit: BoxFit.fitHeight, child: WhiteBorderText(text: player.lifeAsString(), fontSize: 50, height: 0.7,)
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      if(width > 412)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MaterialButton(
                              height: 40,
                              onPressed: () {
                                player.changeLife(5);
                              },
                              child: WhiteBorderText(text: "+ 5", strokeWidth: 2),
                              ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MaterialButton(
                            height: 60,
                            onPressed: () {
                              player.changeLife(1);
                            },
                            child: WhiteBorderText(text: "+", fontSize: 50,),
                            ),
                            if(width < 412 && height > 567)
                                MaterialButton(
                                  height: 40,
                                  minWidth: 10,
                                  onPressed: () {
                                    player.changeLife(5);
                                  },
                                  child: WhiteBorderText(text: "+ 5", strokeWidth: 2),
                                  ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class WhiteBorderText extends StatelessWidget {
  WhiteBorderText({
    super.key,
    required this.text,
    this.fontSize,
    this.height,
    this.strokeWidth = 3,
  });
  final String text;
  double? fontSize;
  double? height;
  double strokeWidth;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(text, style: TextStyle(fontSize: fontSize, height: height,
                                    foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = strokeWidth
                                    ..color = Colors.white,)),
        Text(text, style: TextStyle(fontSize: fontSize, height: height)),
        ]
    
    );
  }
}

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


class CustomButtonRow extends StatelessWidget {
  const CustomButtonRow({
    super.key,
    required this.widget,
    required this.player,
    required this.selectedButtons,
  });

  final List selectedButtons;
  final PlayerCard widget;
  final Player player;


  Widget getButton(String button, Player player){
    return switch(button) {
      "allMinusOne" => MaterialButton(
        minWidth: 10,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0), side: BorderSide(color: Colors.black,) ),
        onPressed: () {player.changeLifeAllPlayers(-1);},
        onLongPress: () {player.changeLifeAllPlayers(1);}, child: WhiteBorderText(text: "- 1 / - 1", strokeWidth: 1,)),
      "othersMinusOne" => MaterialButton(
        minWidth: 10,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0), side: BorderSide(color: Colors.black,) ),
        onPressed: () {player.changeLifeOthers(-1);}, 
        onLongPress: () {player.changeLifeOthers(1);}, child: WhiteBorderText(text: "0 /- 1", strokeWidth: 1,)),
      "othersMinusOnePlayerPlusOne" => MaterialButton(
        minWidth: 10,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0), side: BorderSide(color: Colors.black,) ),
        onPressed: () {player.changeLifeOthersAndSelf(-1, 1);}, 
        onLongPress: () {player.changeLifeOthersAndSelf(1, -1);}, child: WhiteBorderText(text: "+ 1/ - 1",strokeWidth: 1,)),
      "poison" => PoisonButton(player: player),
      "experience" => ExperienceButton(player: player,),
      _=> throw Exception("Unrecognized button"),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (String button in selectedButtons)
          getButton(button, player),
        if(selectedButtons.isEmpty) SizedBox(height: 45,)
      ],
          
      );
  }
}

class PoisonButton extends StatelessWidget {
  PoisonButton({
    super.key,
    required this.player,
  });
  final Player player;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 10,
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
      onPressed: () => {player.changePoison(1)},
      onLongPress: () => {player.changePoison(-1)},
        child: 
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("lib/background_images/phyrexian_icon.png"), opacity: 0.3)
          ),
        child: 
        player.poison != 0 ? 
        Center(
          child: WhiteBorderText(
            text: player.poison.toString(), 
            fontSize: 20,
            ),
        )
        : null
      ),
    );
  }
}

class ExperienceButton extends StatelessWidget {
  ExperienceButton({
    super.key,
    required this.player,
  });
  final Player player;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => {player.changeExperience(1)},
      onLongPress: () => {player.changeExperience(-1)},
      minWidth: 10,
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
        child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("lib/background_images/experience_icon.png"), opacity: 0.3)
        ),
        child: 
        player.experience != 0 ? 
        Center(
          child: WhiteBorderText(
            text: player.experience.toString(), 
            fontSize: 20,
            ),
        )
        : null
      ),
    );
  }
}
