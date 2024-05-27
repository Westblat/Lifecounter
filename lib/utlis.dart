import 'package:flutter/material.dart';

List allButtons = ["allMinusOne", "othersMinusOne", "othersMinusOnePlayerPlusOne", "poison", "experience"];
List allBackgrounds = ["monored", "monogreen", "monoblack", "monowhite", "monoblue"];

String getImage(String image){
  return switch(image) {
    "monored" => "lib/background_images/monored_icon.png",
    "monogreen" => ("lib/background_images/monogreen_icon.png"),
    "monowhite" => ("lib/background_images/monowhite_icon.png"),
    "monoblue" => ("lib/background_images/monoblue_icon.png"),
    "monoblack" => ("lib/background_images/monoblack_icon.png"),
    _=> throw Exception("Unexpexted file"),
  };
}

Color getBackgroundColor(String image){
  return switch(image) {
    "monored" => const Color.fromRGBO(244, 67, 54, 0.5),
    "monogreen" => const Color.fromRGBO(76, 175, 80, 0.5),
    "monowhite" => const Color.fromRGBO(255, 255, 255, 0.5),
    "monoblue" => const Color.fromRGBO(33, 150, 243, 0.5),
    "monoblack" => const Color.fromRGBO(0, 0, 0, 0.3),
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
