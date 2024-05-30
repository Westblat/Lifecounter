import 'package:the_lifecounter/player_card.dart';
import 'package:the_lifecounter/utlis.dart';
import 'package:flutter/material.dart';
import 'package:the_lifecounter/player.dart';


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
