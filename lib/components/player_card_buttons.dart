import 'package:the_lifecounter/functions/utlis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_lifecounter/functions/player.dart';
import 'package:the_lifecounter/state/game_state.dart';


class CustomButtonRow extends ConsumerWidget {
  const CustomButtonRow({
    super.key,
    required this.player,
    required this.selectedButtons,
  });

  final List<String> selectedButtons;
  final Player player;


  Widget getButton(String button, Player player, WidgetRef ref){
    return switch(button) {
      "allMinusOne" => MaterialButton(
        minWidth: 10,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0), side: BorderSide(color: Colors.black,) ),
        onPressed: () {ref.read(gameStateProvider.notifier).changeLifeAllPlayers(-1);},
        onLongPress: () {ref.read(gameStateProvider.notifier).changeLifeAllPlayers(1);}, 
        child: WhiteBorderText(text: "- 1 / - 1", strokeWidth: 1,)
        ),
      "othersMinusOne" => MaterialButton(
        minWidth: 10,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0), side: BorderSide(color: Colors.black,) ),
        onPressed: () {ref.read(gameStateProvider.notifier).changeLifeOthers(player.playerNumber, -1);}, 
        onLongPress: () {ref.read(gameStateProvider.notifier).changeLifeOthers(player.playerNumber, 1);}, 
        child: WhiteBorderText(text: "0 /- 1", strokeWidth: 1,)
        ),
      "othersMinusOnePlayerPlusOne" => MaterialButton(
        minWidth: 10,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0), side: BorderSide(color: Colors.black,) ),
        onPressed: () {ref.read(gameStateProvider.notifier).changeLifeOthersAndSelf(playerNumber: player.playerNumber, othersDelta: -1, selfDelta: 1);}, 
        onLongPress: () {ref.read(gameStateProvider.notifier).changeLifeOthersAndSelf(playerNumber: player.playerNumber, othersDelta: 1, selfDelta: -1);}, 
        child: WhiteBorderText(text: "+ 1/ - 1",strokeWidth: 1,)
        ),
      "selfAdd5" => MaterialButton(
        minWidth: 10,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0), side: BorderSide(color: Colors.black,) ),
        onPressed: () => ref.read(gameStateProvider.notifier).changeLife(player.playerNumber, 5),
        onLongPress: () => ref.read(gameStateProvider.notifier).changeLife(player.playerNumber, -5),
        child: WhiteBorderText(text: "5", strokeWidth: 1,)
      ),
      "selfRemove5" => MaterialButton(
        minWidth: 10,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0), side: BorderSide(color: Colors.black,) ),
        onPressed: () => ref.read(gameStateProvider.notifier).changeLife(player.playerNumber, -5),
        onLongPress: () => ref.read(gameStateProvider.notifier).changeLife(player.playerNumber, 5),
        child: WhiteBorderText(text: "- 5", strokeWidth: 1,)
      ),
      "poison" => PoisonButton(player: player),
      "experience" => ExperienceButton(player: player,),
      _=> throw Exception("Unrecognized button"),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (String button in selectedButtons)
          getButton(button, player, ref),
        if(selectedButtons.isEmpty) SizedBox(height: 45,)
      ],
          
      );
  }
}

class PoisonButton extends ConsumerWidget {
  PoisonButton({
    super.key,
    required this.player,
  });
  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialButton(
      minWidth: 10,
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
      onPressed: () => {ref.read(gameStateProvider.notifier).changePoison(player.playerNumber, 1)},
      onLongPress: () => {ref.read(gameStateProvider.notifier).changePoison(player.playerNumber, -1)},
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

class ExperienceButton extends ConsumerWidget {
  ExperienceButton({
    super.key,
    required this.player,
  });
  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialButton(
      onPressed: () => {ref.read(gameStateProvider.notifier).changeExperience(player.playerNumber, 1)},
      onLongPress: () => {ref.read(gameStateProvider.notifier).changeExperience(player.playerNumber, -1)},
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
