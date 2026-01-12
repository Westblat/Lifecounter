import 'package:flutter/material.dart';
import 'package:the_lifecounter/functions/utlis.dart';

@immutable
class Player {
  const Player({
    required this.playerNumber,
    required this.life,
    required this.background,
    this.lifeChange = 0,
    this.commanderDamage = const {},
    this.poison = 0,
    this.experience = 0,
    this.icon = true,
    this.blur = false,
  });

  final int playerNumber;
  final int life;
  final String background;
  final int lifeChange;
  final Map<int, int> commanderDamage;
  final int poison;
  final int experience;
  final bool icon;
  final bool blur;

  Player copyWith({
    int? life,
    String? background,
    int? lifeChange,
    Map<int, int>? commanderDamage,
    int? poison,
    int? experience,
    bool? icon,
    bool? blur,
  }) {
    return Player(
      playerNumber: playerNumber,
      life: life ?? this.life,
      background: background ?? this.background,
      lifeChange: lifeChange ?? this.lifeChange,
      commanderDamage: commanderDamage ?? this.commanderDamage,
      poison: poison ?? this.poison,
      experience: experience ?? this.experience,
      icon: icon ?? this.icon,
      blur: blur ?? this.blur,
    );
  }

  Player resetForMode(String gameMode, List<int> allPlayerNumbers) {
    final commanderDamageMap = gameMode == 'commander'
        ? emptyCommanderDamageFor(playerNumber, allPlayerNumbers)
        : const <int, int>{};
    return copyWith(
      life: gameMode == 'standard' ? 20 : 40,
      lifeChange: 0,
      poison: 0,
      experience: 0,
      commanderDamage: commanderDamageMap,
    );
  }

  Player resetStandardPair(String gameMode) {
    if (gameMode != 'standard') return this;
    return copyWith(
      life: 20,
      lifeChange: 0,
      poison: 0,
      experience: 0,
      commanderDamage: const {},
    );
  }

  static Player initial({
    required int playerNumber,
    required String gameMode,
    required List<int> allPlayerNumbers,
  }) {
    return Player(
      playerNumber: playerNumber,
      life: gameMode == 'standard' ? 20 : 40,
      background: monoBackgrounds[playerNumber % monoBackgrounds.length],
      lifeChange: 0,
      commanderDamage: gameMode == 'commander'
          ? emptyCommanderDamageFor(playerNumber, allPlayerNumbers)
          : const <int, int>{},
      poison: 0,
      experience: 0,
    );
  }

  @override
  int get hashCode =>
      Object.hash(playerNumber, life, background, lifeChange, poison, experience, icon, blur, commanderDamageHash);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Player &&
        other.playerNumber == playerNumber &&
        other.life == life &&
        other.background == background &&
        other.lifeChange == lifeChange &&
        other.poison == poison &&
        other.experience == experience &&
        other.icon == icon &&
        other.blur == blur &&
        _mapEquals(other.commanderDamage, commanderDamage);
  }

  int get commanderDamageHash {
    int hash = 0;
    commanderDamage.forEach((key, value) {
      hash = Object.hash(hash, key, value);
    });
    return hash;
  }
}

Map<int, int> emptyCommanderDamageFor(int playerNumber, List<int> allPlayerNumbers) {
  return {
    for (final number in allPlayerNumbers)
      if (number != playerNumber) number: 0,
  };
}

bool _mapEquals(Map<int, int> a, Map<int, int> b) {
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (b[entry.key] != entry.value) return false;
  }
  return true;
}
