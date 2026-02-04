import 'package:the_lifecounter/functions/player.dart';
import 'package:the_lifecounter/state/game_state.dart';

Map<String, dynamic> gameStateToJson(GameState state) {
  return {
    'type': 'state',
    'layout': state.layout,
    'gameMode': state.gameMode,
    'players': state.players.map(playerToJson).toList(),
  };
}

Map<String, dynamic> playerToJson(Player player) {
  final commander = <String, int>{};
  player.commanderDamage.forEach((key, value) {
    commander[key.toString()] = value;
  });
  return {
    'playerNumber': player.playerNumber,
    'life': player.life,
    'lifeChange': player.lifeChange,
    'background': player.background,
    'commanderDamage': commander,
    'poison': player.poison,
    'experience': player.experience,
    'icon': player.icon,
    'blur': player.blur,
  };
}

GameState gameStateFromJson(Map<String, dynamic> json) {
  final players = (json['players'] as List<dynamic>? ?? [])
      .map((p) => playerFromJson(p as Map<String, dynamic>))
      .toList();
  return GameState(
    layout: json['layout'] as String? ?? 'default',
    gameMode: json['gameMode'] as String? ?? 'commander',
    players: players,
    assignedPlayer: json['assignedPlayer'] as int?,
  );
}

Player playerFromJson(Map<String, dynamic> json) {
  final commanderDamage = <int, int>{};
  final rawMap = json['commanderDamage'];
  if (rawMap is Map) {
    rawMap.forEach((key, value) {
      final k = int.tryParse(key.toString());
      final v = int.tryParse(value.toString());
      if (k != null && v != null) {
        commanderDamage[k] = v;
      }
    });
  }
  return Player(
    playerNumber: json['playerNumber'] as int? ?? 0,
    life: json['life'] as int? ?? 40,
    lifeChange: json['lifeChange'] as int? ?? 0,
    background: json['background'] as String? ?? 'colorless',
    commanderDamage: commanderDamage,
    poison: json['poison'] as int? ?? 0,
    experience: json['experience'] as int? ?? 0,
    icon: json['icon'] as bool? ?? true,
    blur: json['blur'] as bool? ?? false,
  );
}
