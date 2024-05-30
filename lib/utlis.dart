import 'package:flutter/material.dart';
import 'package:the_lifecounter/player.dart';

List allButtons = ["allMinusOne", "othersMinusOne", "othersMinusOnePlayerPlusOne", "poison", "experience"];
List monoBackgrounds = ["monored", "monogreen", "monoblack", "monowhite", "monoblue", "colorless"];
List dualBackgrounds = ["azorius", "boros", "dimir", "golgari", "gruul", "izzet", "orzhov", "rakdos", "selesnya", "simic"];
List trioBackgrounds = ["grixis", "jund", "bant", "naya", "esper", "abzan", "jeskai", "sultai", "mardu", "temur"];

String getImage(String image){
  return switch(image) {
    "monored" => "lib/background_images/monored_icon.png",
    "monogreen" => "lib/background_images/monogreen_icon.png",
    "monowhite" => "lib/background_images/monowhite_icon.png",
    "monoblue" => "lib/background_images/monoblue_icon.png",
    "monoblack" => "lib/background_images/monoblack_icon.png",
    "colorless" => "lib/background_images/colorless_icon.png",
    "dimir" => "lib/background_images/dimir_icon.png",
    "grixis" => "lib/background_images/grixis_icon.png",
    "jund" => "lib/background_images/jund_icon.png",
    "naya" => "lib/background_images/naya_icon.png",
    "esper" => "lib/background_images/esper_icon.png",
    "bant" => "lib/background_images/bant_icon.png",
    "azorius" => "lib/background_images/azorius_icon.png",
    "boros" => "lib/background_images/boros_icon.png",
    "golgari" => "lib/background_images/golgari_icon.png",
    "gruul" => "lib/background_images/gruul_icon.png",
    "izzet" => "lib/background_images/izzet_icon.png",
    "orzhov" => "lib/background_images/orzhov_icon.png",
    "rakdos" => "lib/background_images/rakdos_icon.png",
    "selesnya" => "lib/background_images/selesnya_icon.png",
    "simic" => "lib/background_images/simic_icon.png",
    "abzan" =>"lib/background_images/abzan_icon.png",
    "jeskai" =>"lib/background_images/jeskai_icon.png",
    "sultai" =>"lib/background_images/sultai_icon.png",
    "mardu" =>"lib/background_images/mardu_icon.png",
    "temur" =>"lib/background_images/temur_icon.png",
    _=> throw Exception("Unexpexted file"),
  };
}

Color getBackgroundColor(String image){
  return switch(image) {
    "monored" => getColor("red"),
    "monogreen" => getColor("green"),
    "monowhite" => getColor("white"),
    "monoblue" => getColor("blue"),
    "monoblack" => getColor("black"),
    "colorless" => getColor("grey"),
    _=> throw Exception("Unexpexted file"),
  };
}

Color getColor(String color) {
    return switch(color) {
    "red" => Color.fromARGB(255, 196, 116, 110),
    "green" => Color.fromARGB(255, 114, 185, 116),
    "white" => const Color.fromRGBO(255, 255, 255, 1),
    "blue" => Color.fromARGB(255, 107, 163, 209),
    "black" => Color.fromARGB(255, 102, 96, 96),
    "grey" => Colors.grey,
    _=> throw Exception("Unexpexted color"),
  };
}

LinearGradient getGradient(String image, Player player) {
  Alignment start = player.playerNumber % 2 == 0 ? Alignment.topLeft : Alignment.topRight;
  Alignment end = player.playerNumber % 2 == 0 ? Alignment.bottomRight : Alignment.bottomLeft;
  return player.blur ? getBlurGradient(image, start, end) : getEdgyGradient(image, start, end);
}

LinearGradient getEdgyGradient(String image, start, end){
  return switch(image) {
    "azorius" => LinearGradient(colors: [getColor("blue"), getColor("white")], begin: start, end: end, stops: [0.5, 0.5]),
    "boros" => LinearGradient(colors: [getColor("white"), getColor("red")], begin: start, end: end, stops: [0.5, 0.5]),
    "dimir" => LinearGradient(colors: [getColor("blue"), getColor("black")], begin: start, end: end, stops: [0.5, 0.5]),
    "golgari" => LinearGradient(colors: [getColor("green"), getColor("black")], begin: start, end: end, stops: [0.5, 0.5]),
    "gruul" => LinearGradient(colors: [getColor("green"), getColor("red")], begin: start, end: end, stops: [0.5, 0.5]),
    "izzet" => LinearGradient(colors: [getColor("blue"), getColor("red")], begin: start, end: end, stops: [0.5, 0.5]),
    "orzhov" => LinearGradient(colors: [getColor("white"), getColor("black")], begin: start, end: end, stops: [0.5, 0.5]),
    "rakdos" => LinearGradient(colors: [getColor("red"), getColor("black")], begin: start, end: end, stops: [0.5, 0.5]),
    "selesnya" => LinearGradient(colors: [getColor("white"), getColor("green")], begin: start, end: end, stops: [0.5, 0.5]),
    "simic" => LinearGradient(colors: [getColor("blue"), getColor("green")], begin: start, end: end, stops: [0.5, 0.5]),
    "grixis" => LinearGradient(colors: [getColor("blue"), getColor("black"), getColor("black"), getColor("red")], begin: start, end: end, stops: [0.3, 0.3, 0.6, 0.6]),
    "jund" => LinearGradient(colors: [getColor("black"), getColor("red"), getColor("red"), getColor("green")], begin: start, end: end, stops: [0.3, 0.3, 0.6, 0.6]),
    "bant" => LinearGradient(colors: [getColor("green"), getColor("white"), getColor("white"), getColor("blue")], begin: start, end: end, stops: [0.3, 0.3, 0.6, 0.6]),
    "naya" => LinearGradient(colors: [getColor("red"), getColor("green"), getColor("green"), getColor("white")], begin: start, end: end, stops: [0.3, 0.3, 0.6, 0.6]),
    "esper" => LinearGradient(colors: [getColor("white"), getColor("blue"), getColor("blue"), getColor("black")], begin: start, end: end, stops: [0.3, 0.3, 0.6, 0.6]),
    "abzan" => LinearGradient(colors: [getColor("white"), getColor("black"), getColor("black"), getColor("green")], begin: start, end: end, stops: [0.3, 0.3, 0.6, 0.6]),
    "jeskai" => LinearGradient(colors: [getColor("blue"), getColor("red"), getColor("red"), getColor("white")], begin: start, end: end, stops: [0.3, 0.3, 0.6, 0.6]),
    "sultai" => LinearGradient(colors: [getColor("black"), getColor("green"), getColor("green"), getColor("blue")], begin: start, end: end, stops: [0.3, 0.3, 0.6, 0.6]),
    "mardu" => LinearGradient(colors: [getColor("red"), getColor("white"), getColor("white"), getColor("black")], begin: start, end: end, stops: [0.3, 0.3, 0.6, 0.6]),
    "temur" => LinearGradient(colors: [getColor("green"), getColor("blue"), getColor("blue"), getColor("red")], begin: start, end: end, stops: [0.3, 0.3, 0.6, 0.6]),
    _=> throw Exception("Unexpexted file"),
  };
}

LinearGradient getBlurGradient(String image, start, end){
  return switch(image) {
    "azorius" => LinearGradient(colors: [getColor("blue"), getColor("white")], begin: start, end: end, stops: [0.3, 0.8]),
    "boros" => LinearGradient(colors: [getColor("white"), getColor("red")], begin: start, end: end, stops: [0.3, 0.8]),
    "dimir" => LinearGradient(colors: [getColor("blue"), getColor("black")], begin: start, end: end, stops: [0.3, 0.8]),
    "golgari" => LinearGradient(colors: [getColor("green"), getColor("black")], begin: start, end: end, stops: [0.3, 0.8]),
    "gruul" => LinearGradient(colors: [getColor("green"), getColor("red")], begin: start, end: end, stops: [0.3, 0.8]),
    "izzet" => LinearGradient(colors: [getColor("blue"), getColor("red")], begin: start, end: end, stops: [0.3, 0.8]),
    "orzhov" => LinearGradient(colors: [getColor("white"), getColor("black")], begin: start, end: end, stops: [0.3, 0.8]),
    "rakdos" => LinearGradient(colors: [getColor("red"), getColor("black")], begin: start, end: end, stops: [0.3, 0.8]),
    "selesnya" => LinearGradient(colors: [getColor("white"), getColor("green")], begin: start, end: end, stops: [0.3, 0.8]),
    "simic" => LinearGradient(colors: [getColor("blue"), getColor("green")], begin: start, end: end, stops: [0.3, 0.8]),
    "grixis" => LinearGradient(colors: [getColor("blue"), getColor("black"), getColor("red")], begin: start, end: end, stops: [0.2, 0.5, 0.8]),
    "jund" => LinearGradient(colors: [getColor("black"), getColor("red"), getColor("green")], begin: start, end: end, stops: [0.2, 0.5, 0.8]),
    "bant" => LinearGradient(colors: [getColor("green"), getColor("white"), getColor("blue")], begin: start, end: end, stops: [0.2, 0.5, 0.8]),
    "naya" => LinearGradient(colors: [getColor("red"), getColor("green"), getColor("white")], begin: start, end: end, stops: [0.2, 0.5, 0.8]),
    "esper" => LinearGradient(colors: [getColor("white"), getColor("blue"), getColor("black")], begin: start, end: end, stops: [0.2, 0.5, 0.8]),
    "abzan" => LinearGradient(colors: [getColor("white"), getColor("black"), getColor("green")], begin: start, end: end, stops: [0.2, 0.5, 0.8]),
    "jeskai" => LinearGradient(colors: [getColor("blue"), getColor("red"), getColor("white")], begin: start, end: end, stops: [0.2, 0.5, 0.8]),
    "sultai" => LinearGradient(colors: [getColor("black"), getColor("green"), getColor("blue")], begin: start, end: end, stops: [0.2, 0.5, 0.8]),
    "mardu" => LinearGradient(colors: [getColor("red"), getColor("white"), getColor("black")], begin: start, end: end, stops: [0.2, 0.5, 0.8]),
    "temur" => LinearGradient(colors: [getColor("green"), getColor("blue"), getColor("red")], begin: start, end: end, stops: [0.2, 0.5, 0.8]),
    _=> throw Exception("Unexpexted file"),
  };
}

String getButtonText(String button) {
  return switch(button) {
    "allMinusOne" => "One damage to all players",
    "othersMinusOne" => "One damge to other players",
    "othersMinusOnePlayerPlusOne" => "One damage to other players, one life for you",
    "poison" => "Poison counters",
    "experience" => "Experience counters",
    _=> button, 
  };
}

BoxDecoration getDecoration(Player player) {
  String background = player.background;
  if(monoBackgrounds.contains(background)) {
    return BoxDecoration(
            color: getBackgroundColor(background),            
            image:player.icon ?  DecorationImage(
              opacity: 0.3,
              image: AssetImage(getImage(background)
              ),
            ) : null
  );
  } else {
    return BoxDecoration(
            gradient: getGradient(background, player),
            image:player.icon ?  DecorationImage(
              opacity: 0.3,
              image: AssetImage(getImage(background)),
            ) : null
  );
  } 
}

BoxDecoration getCommanderDecoration(Player player) {
  String background = player.background;
  if(monoBackgrounds.contains(background)) {
    return BoxDecoration(
            image:player.icon ?  DecorationImage(
              opacity: 0.3,
              image: AssetImage(getImage(background)
              ),
            ) : null
  );
  } else {
    return BoxDecoration(
            gradient: getGradient(background, player),
            image:player.icon ?  DecorationImage(
              opacity: 0.3,
              image: AssetImage(getImage(background)),
            ) : null
  );
  }
}

bool isMonoColor(String background) {
  return monoBackgrounds.contains(background);
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
  final double? fontSize;
  final double? height;
  final double strokeWidth;


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

