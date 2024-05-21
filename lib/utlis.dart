List allButtons = ["allMinusOne", "othersMinusOne", "othersMinusOnePlayerPlusOne", "poison", "experience"];
List allBackgrounds = ["monored", "monogreen", "monoblack", "monowhite", "monoblue"];

String getImage(String image){
  return switch(image) {
    "monored" => ("lib/background_images/monored.jpeg"),
    "monogreen" => ("lib/background_images/monogreen.webp"),
    "monowhite" => ("lib/background_images/monowhite.jpeg"),
    "monoblue" => ("lib/background_images/monoblue.webp"),
    "monoblack" => ("lib/background_images/monoblack.jpeg"),
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
