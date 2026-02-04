import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the_lifecounter/components/remote/remote_player_card.dart';
import 'package:the_lifecounter/functions/player.dart';
import 'package:the_lifecounter/network/messages.dart';
import 'package:the_lifecounter/state/game_state.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({super.key});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  WebSocket? _socket;
  String? _error;
  bool _connecting = false;
  GameState? _remoteState;
  int _playerNumber = 1;
  bool _lockedToAssigned = false;
  bool _handshakeAccepted = false;

  @override
  void dispose() {
    _socket?.close();
    _ipController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    final target = _ipController.text.trim();
    final name =
        _nameController.text.trim().isEmpty ? 'Player' : _nameController.text.trim();
    if (target.isEmpty) return;
    _handshakeAccepted = false;
    setState(() {
      _connecting = true;
      _error = null;
    });
    try {
      final ws = await WebSocket.connect('ws://$target');
      setState(() {
        _socket = ws;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connected')),
      );
      ws.listen(
        (event) {
          if (!mounted) return;
          setState(() {
            try {
              final decoded = jsonDecode(event);
              if (decoded is Map && decoded['type'] == 'state') {
                final map = Map<String, dynamic>.from(decoded);
                _remoteState = gameStateFromJson(map);
                final assigned = map['assignedPlayer'];
                if (assigned is int) {
                  _playerNumber = assigned;
                  _lockedToAssigned = true;
                }
                _handshakeAccepted = true;
              } else if (decoded is Map && decoded['type'] == 'handshake') {
                final code = decoded['code'] as int?;
                if (code != null) {
                  _showHandshakeDialog(code);
                }
              } else if (decoded is Map && decoded['type'] == 'handshakeStatus') {
                final clientConfirmed = decoded['clientConfirmed'] == true;
                final hostConfirmed = decoded['hostConfirmed'] == true;
                if (clientConfirmed && hostConfirmed) {
                  _handshakeAccepted = true;
                }
              }
            } catch (_) {
              // ignore malformed messages
            }
          });
        },
        onError: (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Connection error: $e')),
            );
            _handleDisconnect(error: e.toString());
          }
        },
        onDone: () {
          _handleDisconnect(error: 'Disconnected');
        },
      );
      ws.add(jsonEncode({
        'type': 'command',
        'action': 'introduce',
        'name': name,
      }));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection failed: $e')),
        );
        setState(() {
          _error = e.toString();
        });
      }
    } finally {
      setState(() {
        _connecting = false;
      });
    }
  }

  void _handleDisconnect({String? error}) {
    if (!mounted) return;
    _socket = null;
    _remoteState = null;
    _lockedToAssigned = false;
    _playerNumber = 1;
    setState(() {
      _error = error;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? 'Disconnected')),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _showHandshakeDialog(int code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm code'),
        content: Text('Code: $code'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _sendCommand('handshakeConfirm', {'code': code});
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final assignedPlayer = _remoteState?.players.firstWhere(
            (p) => p.playerNumber == _playerNumber,
            orElse: () => _remoteState!.players.first,
          );

    final showFullscreen = _remoteState != null && _lockedToAssigned && assignedPlayer != null && _handshakeAccepted;

    return Scaffold(
      body: SafeArea(
        child: showFullscreen
            ? _FullScreenPlayer(
                player: assignedPlayer,
                state: _remoteState!,
                send: _sendCommand,
                onDisconnect: () => _handleDisconnect(error: 'Disconnected'),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter host IP:PORT',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _ipController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '192.168.0.12:50505',
                      ),
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Your name',
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _connecting ? null : _connect,
                      child: _connecting
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Connect'),
                    ),
                    const SizedBox(height: 12),
                    if (_error != null)
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    if (_socket != null)
                      const Text(
                        'Connected!',
                        style: TextStyle(color: Colors.green),
                      ),
                    const SizedBox(height: 16),
                    if (_remoteState != null && !_lockedToAssigned)
                      const Text('Waiting for host to assign your player...'),
                  ],
                ),
              ),
      ),
    );
  }

  void _sendCommand(String action, Map<String, dynamic> payload) {
    if (_socket == null) return;
    _socket!.add(jsonEncode({
      'type': 'command',
      'action': action,
      ...payload,
    }));
  }
}

class _FullScreenPlayer extends StatelessWidget {
  const _FullScreenPlayer({
    required this.player,
    required this.state,
    required this.send,
    required this.onDisconnect,
  });

  final Player player;
  final GameState state;
  final void Function(String action, Map<String, dynamic> payload) send;
  final VoidCallback onDisconnect;

  @override
  Widget build(BuildContext context) {
    return RemotePlayerCard(
      player: player,
      state: state,
      send: send,
      onDisconnect: onDisconnect,
    );
  }
}
