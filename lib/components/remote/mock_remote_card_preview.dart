import 'package:flutter/material.dart';
import 'package:the_lifecounter/components/remote/remote_player_card.dart';
import 'package:the_lifecounter/functions/player.dart';
import 'package:the_lifecounter/state/game_state.dart';

class MockRemoteCardPreview extends StatefulWidget {
  const MockRemoteCardPreview({super.key});

  @override
  State<MockRemoteCardPreview> createState() => _MockRemoteCardPreviewState();
}

class _MockRemoteCardPreviewState extends State<MockRemoteCardPreview> {
  GameState _state = GameState(
    layout: 'default',
    gameMode: 'commander',
    players: [
      Player.initial(
        playerNumber: 1,
        gameMode: 'commander',
        allPlayerNumbers: const [1],
      ),
    ],
  );

  void _updatePlayer(
    int playerNumber,
    Player Function(Player player) update,
  ) {
    setState(() {
      _state = _state.copyWith(
        players: _state.players
            .map((player) =>
                player.playerNumber == playerNumber ? update(player) : player)
            .toList(),
      );
    });
  }

  void _send(String action, Map<String, dynamic> payload) {
    final playerNumber = payload['player'] as int? ?? 1;
    switch (action) {
      case 'changeBackground':
        final background = payload['background'] as String?;
        if (background == null) return;
        _updatePlayer(
          playerNumber,
          (player) => player.copyWith(background: background),
        );
      case 'toggleIcon':
        _updatePlayer(
          playerNumber,
          (player) => player.copyWith(icon: !player.icon),
        );
      case 'toggleBlur':
        _updatePlayer(
          playerNumber,
          (player) => player.copyWith(blur: !player.blur),
        );
      case 'changeLife':
        final delta = payload['delta'] as int?;
        if (delta == null) return;
        _updatePlayer(
          playerNumber,
          (player) => player.copyWith(life: player.life + delta),
        );
      case 'changeLifeAllPlayers':
        final delta = payload['delta'] as int?;
        if (delta == null) return;
        setState(() {
          _state = _state.copyWith(
            players: _state.players
                .map((player) => player.copyWith(life: player.life + delta))
                .toList(),
          );
        });
      case 'changeLifeOthers':
        final delta = payload['delta'] as int?;
        if (delta == null) return;
        setState(() {
          _state = _state.copyWith(
            players: _state.players
                .map((player) => player.playerNumber == playerNumber
                    ? player
                    : player.copyWith(life: player.life + delta))
                .toList(),
          );
        });
      case 'changeLifeOthersAndSelf':
        final othersDelta = payload['othersDelta'] as int?;
        final selfDelta = payload['selfDelta'] as int?;
        if (othersDelta == null || selfDelta == null) return;
        setState(() {
          _state = _state.copyWith(
            players: _state.players
                .map((player) => player.playerNumber == playerNumber
                    ? player.copyWith(life: player.life + selfDelta)
                    : player.copyWith(life: player.life + othersDelta))
                .toList(),
          );
        });
      case 'changePoison':
        final delta = payload['delta'] as int?;
        if (delta == null) return;
        _updatePlayer(
          playerNumber,
          (player) => player.copyWith(poison: player.poison + delta),
        );
      case 'changeExperience':
        final delta = payload['delta'] as int?;
        if (delta == null) return;
        _updatePlayer(
          playerNumber,
          (player) => player.copyWith(experience: player.experience + delta),
        );
      case 'dealCommanderDamage':
        final from = payload['from'] as int?;
        final delta = payload['delta'] as int?;
        if (from == null || delta == null) return;
        _updatePlayer(
          playerNumber,
          (player) {
            final updated = Map<int, int>.from(player.commanderDamage);
            updated[from] = (updated[from] ?? 0) - delta;
            return player.copyWith(
              commanderDamage: updated,
              life: player.life + delta,
            );
          },
        );
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = _state.players.first;
    return RemotePlayerCard(
      player: player,
      state: _state,
      send: _send,
      onDisconnect: () {},
    );
  }
}
