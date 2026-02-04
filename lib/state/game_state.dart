import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_lifecounter/functions/player.dart';

class GameState {
  const GameState({
    required this.layout,
    required this.gameMode,
    required this.players,
    this.assignedPlayer,
  });

  final String layout;
  final String gameMode;
  final List<Player> players;
  final int? assignedPlayer;

  GameState copyWith({
    String? layout,
    String? gameMode,
    List<Player>? players,
    int? assignedPlayer,
  }) {
    return GameState(
      layout: layout ?? this.layout,
      gameMode: gameMode ?? this.gameMode,
      players: players ?? this.players,
      assignedPlayer: assignedPlayer ?? this.assignedPlayer,
    );
  }

  factory GameState.initial() {
    final initialPlayers = _buildPlayers(
      count: 4,
      gameMode: 'commander',
    );
    return GameState(
      layout: 'default',
      gameMode: 'commander',
      players: initialPlayers,
    );
  }
}

final gameStateProvider =
    StateNotifierProvider<GameNotifier, GameState>((ref) => GameNotifier());

final playerProvider = Provider.family<Player?, int>((ref, playerNumber) {
  final players = ref.watch(gameStateProvider).players;
  return _findPlayer(players, playerNumber);
});

final playersProvider =
    Provider<List<Player>>((ref) => ref.watch(gameStateProvider).players);

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(GameState.initial());

  final Map<int, Timer> _lifeChangeTimers = {};

  void setLayout(String layout) {
    state = state.copyWith(layout: layout);
  }

  void setGameMode(String newGameMode, {bool force = false}) {
    if (!force && newGameMode == state.gameMode) return;
    _clearLifeChangeTimers();
    final playerNumbers = _playerNumbers(state.players);
    final updatedPlayers = state.players
        .map(
          (player) => player.resetForMode(newGameMode, playerNumbers),
        )
        .toList();
    state = state.copyWith(
      gameMode: newGameMode,
      players: _reseedCommanderDamage(updatedPlayers, newGameMode),
    );
  }

  void restartGame() {
    setGameMode(state.gameMode, force: true);
  }

  void addPlayer() {
    _clearLifeChangeTimers();
    final currentPlayers = [...state.players];
    final newPlayerNumbers = <int>[];
    if (state.gameMode == 'standard') {
      newPlayerNumbers.add(currentPlayers.length + 1);
      newPlayerNumbers.add(currentPlayers.length + 2);
    } else {
      newPlayerNumbers.add(currentPlayers.length + 1);
    }

    final allNumbers = [..._playerNumbers(currentPlayers), ...newPlayerNumbers];
    for (final number in newPlayerNumbers) {
      currentPlayers.add(
        Player.initial(
          playerNumber: number,
          gameMode: state.gameMode,
          allPlayerNumbers: allNumbers,
        ),
      );
    }

    state = state.copyWith(
      players: _reseedCommanderDamage(currentPlayers, state.gameMode),
    );
  }

  void removePlayer() {
    final minPlayers = state.gameMode == 'standard' ? 2 : 1;
    if (state.players.length <= minPlayers) {
      return;
    }

    final players = [...state.players];
    if (state.gameMode == 'standard') {
      final removed = players.removeLast();
      _cancelTimer(removed.playerNumber);
      final removed2 = players.removeLast();
      _cancelTimer(removed2.playerNumber);
    } else {
      final removed = players.removeLast();
      _cancelTimer(removed.playerNumber);
    }

    state = state.copyWith(
      players: _reseedCommanderDamage(players, state.gameMode),
    );
  }

  void resetStandard(int playerNumber) {
    if (state.gameMode != 'standard') return;
    final targetNumbers = [
      playerNumber,
      if (playerNumber % 2 == 0) playerNumber - 1 else playerNumber + 1,
    ];

    final updatedPlayers = state.players.map((player) {
      if (!targetNumbers.contains(player.playerNumber)) return player;
      return player.resetStandardPair(state.gameMode);
    }).toList();

    state = state.copyWith(players: updatedPlayers);
  }

  void changeLife(int playerNumber, int delta) {
    state = state.copyWith(
      players: state.players.map((player) {
        if (player.playerNumber != playerNumber) return player;
        return player.copyWith(
          life: player.life + delta,
          lifeChange: player.lifeChange + delta,
        );
      }).toList(),
    );
    _resetLifeChangeTimer(playerNumber);
  }

  void changeLifeAllPlayers(int delta) {
    for (final player in state.players) {
      changeLife(player.playerNumber, delta);
    }
  }

  void changeLifeOthers(int playerNumber, int delta) {
    final others = _otherPlayerNumbers(state, playerNumber);
    for (final other in others) {
      changeLife(other, delta);
    }
  }

  void changeLifeOthersAndSelf({
    required int playerNumber,
    required int othersDelta,
    required int selfDelta,
  }) {
    changeLife(playerNumber, selfDelta);
    changeLifeOthers(playerNumber, othersDelta);
  }

  void dealCommanderDamage({
    required int playerNumber,
    required int fromPlayerNumber,
    required int delta,
  }) {
    changeLife(playerNumber, delta);
    state = state.copyWith(
      players: state.players.map((player) {
        if (player.playerNumber != playerNumber) return player;
        final updatedCommander = Map<int, int>.from(player.commanderDamage);
        updatedCommander[fromPlayerNumber] =
            (updatedCommander[fromPlayerNumber] ?? 0) - delta;
        return player.copyWith(commanderDamage: updatedCommander);
      }).toList(),
    );
  }

  void changeBackground(int playerNumber, String background) {
    _updatePlayer(playerNumber, (player) => player.copyWith(
          background: background,
        ));
  }

  void changePoison(int playerNumber, int delta) {
    _updatePlayer(playerNumber, (player) => player.copyWith(
          poison: player.poison + delta,
        ));
  }

  void changeExperience(int playerNumber, int delta) {
    _updatePlayer(playerNumber, (player) => player.copyWith(
          experience: player.experience + delta,
        ));
  }

  void toggleIcon(int playerNumber) {
    _updatePlayer(playerNumber, (player) => player.copyWith(
          icon: !player.icon,
        ));
  }

  void toggleBlur(int playerNumber) {
    _updatePlayer(playerNumber, (player) => player.copyWith(
          blur: !player.blur,
        ));
  }

  void _updatePlayer(
    int playerNumber,
    Player Function(Player player) updater,
  ) {
    state = state.copyWith(
      players: state.players.map((player) {
        if (player.playerNumber != playerNumber) return player;
        return updater(player);
      }).toList(),
    );
  }

  void _resetLifeChangeTimer(int playerNumber) {
    _lifeChangeTimers[playerNumber]?.cancel();
    _lifeChangeTimers[playerNumber] = Timer(const Duration(seconds: 3), () {
      _updatePlayer(
        playerNumber,
        (player) => player.copyWith(lifeChange: 0),
      );
      _lifeChangeTimers.remove(playerNumber);
    });
  }

  void _cancelTimer(int playerNumber) {
    _lifeChangeTimers[playerNumber]?.cancel();
    _lifeChangeTimers.remove(playerNumber);
  }

  void _clearLifeChangeTimers() {
    for (final timer in _lifeChangeTimers.values) {
      timer.cancel();
    }
    _lifeChangeTimers.clear();
  }
}

List<Player> _reseedCommanderDamage(List<Player> players, String gameMode) {
  if (gameMode != 'commander') {
    return players
        .map((player) => player.copyWith(commanderDamage: const {}))
        .toList();
  }

  final playerNumbers = _playerNumbers(players);
  return players
      .map(
        (player) => player.copyWith(
          commanderDamage:
              emptyCommanderDamageFor(player.playerNumber, playerNumbers),
        ),
      )
      .toList();
}

List<Player> _buildPlayers({
  required int count,
  required String gameMode,
}) {
  final numbers = List.generate(count, (index) => index + 1);
  return List.generate(
    count,
    (index) => Player.initial(
      playerNumber: index + 1,
      gameMode: gameMode,
      allPlayerNumbers: numbers,
    ),
  );
}

List<int> _playerNumbers(List<Player> players) =>
    players.map((p) => p.playerNumber).toList();

Player? _findPlayer(List<Player> players, int playerNumber) {
  for (final player in players) {
    if (player.playerNumber == playerNumber) return player;
  }
  return null;
}

List<int> _otherPlayerNumbers(GameState state, int playerNumber) {
  if (state.gameMode == 'standard') {
    final partnerNumber = playerNumber % 2 == 0
        ? playerNumber - 1
        : playerNumber + 1;
    return state.players
        .where((p) => p.playerNumber == partnerNumber)
        .map((p) => p.playerNumber)
        .toList();
  }

  return state.players
      .where((p) => p.playerNumber != playerNumber)
      .map((p) => p.playerNumber)
      .toList();
}

List<int> playerOrder(List<Player> allPlayers) {
  final even = <int>[];
  final odd = <int>[];

  for (final player in allPlayers) {
    if (player.playerNumber % 2 == 0) {
      even.add(player.playerNumber);
    } else {
      odd.add(player.playerNumber);
    }
  }
  return [...odd, ...even.reversed];
}

List<Player> orderedOpponents(GameState state, int playerNumber) {
  final others =
      state.players.where((player) => player.playerNumber != playerNumber);
  final order = playerOrder(state.players);
  final sorted = [...others];
  sorted.sort((a, b) =>
      Comparable.compare(order.indexOf(a.playerNumber),
          order.indexOf(b.playerNumber)));
  return sorted;
}
