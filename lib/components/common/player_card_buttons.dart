import 'package:flutter/material.dart';
import 'package:the_lifecounter/functions/player.dart';
import 'package:the_lifecounter/functions/utlis.dart';

class CustomButtonRow extends StatelessWidget {
  const CustomButtonRow({
    super.key,
    required this.player,
    required this.selectedButtons,
    required this.onChangeLife,
    required this.onChangeLifeAllPlayers,
    required this.onChangeLifeOthers,
    required this.onChangeLifeOthersAndSelf,
    required this.onChangePoison,
    required this.onChangeExperience,
  });

  final List<String> selectedButtons;
  final Player player;
  final void Function(int delta) onChangeLife;
  final void Function(int delta) onChangeLifeAllPlayers;
  final void Function(int delta) onChangeLifeOthers;
  final void Function(int othersDelta, int selfDelta) onChangeLifeOthersAndSelf;
  final void Function(int delta) onChangePoison;
  final void Function(int delta) onChangeExperience;

  Widget getButton(String button, Player player){
    return switch(button) {
      "allMinusOne" => MaterialButton(
        minWidth: 10,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0), side: BorderSide(color: Colors.black,) ),
        onPressed: () {onChangeLifeAllPlayers(-1);},
        onLongPress: () {onChangeLifeAllPlayers(1);}, 
        child: WhiteBorderText(text: "- 1 / - 1", strokeWidth: 1,)
        ),
      "othersMinusOne" => MaterialButton(
        minWidth: 10,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0), side: BorderSide(color: Colors.black,) ),
        onPressed: () {onChangeLifeOthers(-1);}, 
        onLongPress: () {onChangeLifeOthers(1);}, 
        child: WhiteBorderText(text: "0 /- 1", strokeWidth: 1,)
        ),
      "othersMinusOnePlayerPlusOne" => MaterialButton(
        minWidth: 10,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0), side: BorderSide(color: Colors.black,) ),
        onPressed: () {onChangeLifeOthersAndSelf(-1, 1);}, 
        onLongPress: () {onChangeLifeOthersAndSelf(1, -1);}, 
        child: WhiteBorderText(text: "+ 1/ - 1",strokeWidth: 1,)
        ),
      "selfAdd5" => MaterialButton(
        minWidth: 10,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0), side: BorderSide(color: Colors.black,) ),
        onPressed: () => onChangeLife(5),
        onLongPress: () => onChangeLife(-5),
        child: WhiteBorderText(text: "5", strokeWidth: 1,)
      ),
      "selfRemove5" => MaterialButton(
        minWidth: 10,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0), side: BorderSide(color: Colors.black,) ),
        onPressed: () => onChangeLife(-5),
        onLongPress: () => onChangeLife(5),
        child: WhiteBorderText(text: "- 5", strokeWidth: 1,)
      ),
      "poison" => PoisonButton(player: player, onChangePoison: onChangePoison,),
      "experience" => ExperienceButton(player: player, onChangeExperience: onChangeExperience,),
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
    required this.onChangePoison,
  });
  final Player player;
  final void Function(int delta) onChangePoison;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 10,
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
      onPressed: () => onChangePoison(1),
      onLongPress: () => onChangePoison(-1),
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
    required this.onChangeExperience,
  });
  final Player player;
  final void Function(int delta) onChangeExperience;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => onChangeExperience(1),
      onLongPress: () => onChangeExperience(-1),
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
