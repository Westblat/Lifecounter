import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_lifecounter/network/messages.dart';
import 'package:the_lifecounter/state/game_state.dart';

class HostControls extends ConsumerStatefulWidget {
  const HostControls({super.key, this.startOnInit = false});

  final bool startOnInit;

  @override
  ConsumerState<HostControls> createState() => _HostControlsState();
}

class _HostControlsState extends ConsumerState<HostControls> {
  HttpServer? _server;
  final List<_ClientConn> _clients = [];
  String? _ip;
  List<String> _ips = [];
  int _port = 50505;
  bool _starting = false;
  bool _running = false;
  String? _error;
  ProviderSubscription<GameState>? _gameListener;
  int _clientId = 1;
  final _rand = Random();

  @override
  void initState() {
    super.initState();
    if (widget.startOnInit) {
      _startServer();
    }
  }

  @override
  void dispose() {
    _gameListener?.close();
    _server?.close(force: true);
    for (final client in _clients) {
      client.socket.close();
    }
    super.dispose();
  }

  Future<void> _startServer() async {
    if (_running || _starting) return;
    if (kIsWeb) {
      _safeSetState(() {
        _error = 'Hosting is not supported in web builds.';
      });
      return;
    }
    _safeSetState(() {
      _starting = true;
      _error = null;
    });
    try {
      final server = await HttpServer.bind(InternetAddress.anyIPv4, _port);
      if (!mounted) {
        await server.close(force: true);
        return;
      }
      _server = server;
      _running = true;
      _port = server.port;
      final ips = await _findLocalIps();
      _safeSetState(() {
        _ips = ips;
        _ip = ips.isNotEmpty ? ips.first : server.address.address;
        _port = server.port;
      });
      _gameListener ??= ref.listenManual<GameState>(
        gameStateProvider,
        (prev, next) => _broadcastState(next),
      );
      server.transform(WebSocketTransformer()).listen((socket) {
        final conn = _ClientConn(
          id: _clientId++,
          socket: socket,
          code: 1000 + _rand.nextInt(9000),
        );
        _safeSetState(() {
          _clients.add(conn);
        });
        _sendHandshake(conn);
        socket.listen(
          (data) => _handleMessage(data, socket),
          onError: (_) {},
          onDone: () {
            _removeClient(conn);
          },
        );
        socket.done.whenComplete(() => _removeClient(conn));
      });
    } catch (e) {
      _safeSetState(() {
        _error = e.toString();
      });
    } finally {
      _safeSetState(() {
        _starting = false;
      });
    }
  }

  void _stopServer() {
    _server?.close(force: true);
    for (final client in _clients) {
      client.socket.close();
    }
    _clients.clear();
    _gameListener?.close();
    _gameListener = null;
    _safeSetState(() {
      _running = false;
      _ip = null;
      _ips = [];
      _error = null;
    });
  }

  void _broadcastState(GameState state) {
    final closed = <_ClientConn>[];
    for (final client in _clients) {
      if (!client.confirmed) continue;
      try {
        client.socket.add(jsonEncode(_stateForClient(state, client)));
      } catch (_) {
        closed.add(client);
      }
    }
    if (closed.isNotEmpty) {
      _safeSetState(() {
        _clients.removeWhere((c) => closed.contains(c));
      });
    }
  }

  void _sendStateTo(_ClientConn client, GameState state) {
    if (!client.confirmed) return;
    try {
      client.socket.add(jsonEncode(_stateForClient(state, client)));
    } catch (_) {
      client.socket.close();
    }
  }

  void _handleMessage(dynamic data, WebSocket socket) {
    if (data is! String) return;
    try {
      final decoded = jsonDecode(data);
      if (decoded is! Map<String, dynamic>) return;
      if (decoded['type'] == 'command') {
        decoded['_socket'] = socket;
        _applyCommand(decoded);
      }
    } catch (_) {
      // ignore malformed messages
    }
  }

  void _applyCommand(Map<String, dynamic> command) {
    final action = command['action'];
    final controller = ref.read(gameStateProvider.notifier);
    switch (action) {
      case 'changeLife':
        final playerNumber = command['player'] as int?;
        final delta = command['delta'] as int?;
        if (playerNumber != null && delta != null) {
          controller.changeLife(playerNumber, delta);
        }
      case 'changePoison':
        final playerNumber = command['player'] as int?;
        final delta = command['delta'] as int?;
        if (playerNumber != null && delta != null) {
          controller.changePoison(playerNumber, delta);
        }
      case 'changeExperience':
        final playerNumber = command['player'] as int?;
        final delta = command['delta'] as int?;
        if (playerNumber != null && delta != null) {
          controller.changeExperience(playerNumber, delta);
        }
      case 'dealCommanderDamage':
        final playerNumber = command['player'] as int?;
        final from = command['from'] as int?;
        final delta = command['delta'] as int?;
        if (playerNumber != null && from != null && delta != null) {
          controller.dealCommanderDamage(
            playerNumber: playerNumber,
            fromPlayerNumber: from,
            delta: delta,
          );
        }
      case 'changeLifeAllPlayers':
        final delta = command['delta'] as int?;
        if (delta != null) {
          controller.changeLifeAllPlayers(delta);
        }
      case 'changeLifeOthers':
        final playerNumber = command['player'] as int?;
        final delta = command['delta'] as int?;
        if (playerNumber != null && delta != null) {
          controller.changeLifeOthers(playerNumber, delta);
        }
      case 'changeLifeOthersAndSelf':
        final playerNumber = command['player'] as int?;
        final othersDelta = command['othersDelta'] as int?;
        final selfDelta = command['selfDelta'] as int?;
        if (playerNumber != null &&
            othersDelta != null &&
            selfDelta != null) {
          controller.changeLifeOthersAndSelf(
            playerNumber: playerNumber,
            othersDelta: othersDelta,
            selfDelta: selfDelta,
          );
        }
      case 'changeBackground':
        final playerNumber = command['player'] as int?;
        final background = command['background'] as String?;
        if (playerNumber != null && background != null) {
          controller.changeBackground(playerNumber, background);
        }
      case 'toggleIcon':
        final playerNumber = command['player'] as int?;
        if (playerNumber != null) {
          controller.toggleIcon(playerNumber);
        }
      case 'toggleBlur':
        final playerNumber = command['player'] as int?;
        if (playerNumber != null) {
          controller.toggleBlur(playerNumber);
        }
      case 'introduce':
        final name = command['name'] as String?;
        final socket = command['_socket'] as WebSocket?;
        if (name != null && socket != null) {
          for (final c in _clients) {
            if (c.socket == socket) {
              c.name = name;
              _safeSetState(() {});
              break;
            }
          }
        }
      case 'handshakeConfirm':
        final socket = command['_socket'] as WebSocket?;
        final code = command['code'] as int?;
        if (socket != null && code != null) {
          for (final c in _clients) {
            if (c.socket == socket && c.code == code) {
              c.clientConfirmed = true;
              _safeSetState(() {});
              if (c.confirmed) {
                _completeHandshake(c);
              } else {
                _sendHandshakeStatus(c);
              }
            }
          }
        }
      default:
        break;
    }
  }

  Future<List<String>> _findLocalIps() async {
    final ips = <String>[];
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          if (!addr.isLoopback && !ips.contains(addr.address)) {
            ips.add(addr.address);
          }
        }
      }
    } catch (_) {
      // ignore errors and fallback to server.address
    }
    return ips;
  }

  @override
  Widget build(BuildContext context) {
    const isWeb = kIsWeb;
    final state = ref.watch(gameStateProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _running || _starting || isWeb ? null : _startServer,
              icon: const Icon(Icons.wifi_tethering),
              label: Text(_starting ? 'Starting...' : 'Start hosting'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: _running && !isWeb ? _stopServer : null,
              icon: const Icon(Icons.stop),
              label: const Text('Stop'),
            ),
          ],
        ),
        if (isWeb) ...[
          const SizedBox(height: 8),
          const Text(
            'Hosting is not supported in web builds. Run the host on mobile or desktop.',
          ),
        ],
        const SizedBox(height: 8),
        if (_running)
          Text(
            'Host at: ${_ip != null ? '$_ip:$_port' : 'Unknown'}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        if (_ips.length > 1)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              const Text('Other IPs:'),
              for (final ip in _ips.skip(1)) Text('$ip:$_port'),
            ],
          ),
        if (_error != null) ...[
          const SizedBox(height: 4),
          Text(
            'Error: $_error',
            style: const TextStyle(color: Colors.red),
          ),
        ],
        const SizedBox(height: 8),
        if (_running)
          Text(
            'Connected clients: ${_clients.length}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        if (_clients.isNotEmpty) ...[
          const SizedBox(height: 8),
          ..._clients.map((c) => _ClientTile(
                client: c,
                availablePlayers: state.players.map((p) => p.playerNumber).toList(),
                onApprove: () {
                  setState(() {
                    c.hostConfirmed = true;
                  });
                  if (c.confirmed) {
                    _completeHandshake(c);
                  } else {
                    _sendHandshakeStatus(c);
                    _safeSetState(() {});
                  }
                },
                onAssign: (player) {
                  setState(() {
                    c.assignedPlayer = player;
                  });
                  _sendStateTo(c, ref.read(gameStateProvider));
                },
                onDisconnect: () => _removeClient(c),
              )),
        ],
      ],
    );
  }

  Map<String, dynamic> _stateForClient(GameState state, _ClientConn client) {
    final base = gameStateToJson(state);
    base['assignedPlayer'] = client.assignedPlayer;
    return base;
  }

  void _removeClient(_ClientConn conn) {
    conn.socket.close();
    _safeSetState(() {
      _clients.remove(conn);
    });
  }

  void _safeSetState(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }

  void _sendHandshake(_ClientConn client) {
    try {
      client.socket.add(jsonEncode({'type': 'handshake', 'code': client.code}));
    } catch (_) {
      _removeClient(client);
    }
  }

  void _sendHandshakeStatus(_ClientConn client) {
    try {
      client.socket.add(jsonEncode({
        'type': 'handshakeStatus',
        'code': client.code,
        'hostConfirmed': client.hostConfirmed,
        'clientConfirmed': client.clientConfirmed,
      }));
    } catch (_) {
      _removeClient(client);
    }
  }

  void _completeHandshake(_ClientConn client) {
    client.hostConfirmed = true;
    client.clientConfirmed = true;
    _safeSetState(() {});
    _sendHandshakeStatus(client);
    _sendStateTo(client, ref.read(gameStateProvider));
  }
}

class _ClientConn {
  _ClientConn({
    required this.id,
    required this.socket,
    required this.code,
  });

  final int id;
  final WebSocket socket;
  final int code;
  int? assignedPlayer;
  String? name;
  bool hostConfirmed = false;
  bool clientConfirmed = false;

  bool get confirmed => hostConfirmed && clientConfirmed;
}

class _ClientTile extends StatelessWidget {
  const _ClientTile({
    required this.client,
    required this.availablePlayers,
    required this.onApprove,
    required this.onAssign,
    required this.onDisconnect,
  });

  final _ClientConn client;
  final List<int> availablePlayers;
  final VoidCallback onApprove;
  final void Function(int?) onAssign;
  final VoidCallback onDisconnect;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            client.name != null
                ? '${client.name} (#${client.id})'
                : 'Client #${client.id}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        if (!client.confirmed)
          Text('Code: ${client.code}',
              style: const TextStyle(color: Colors.orange)),
        IconButton(
          icon: Icon(
            client.hostConfirmed ? Icons.check_circle : Icons.check_circle_outline,
            color: client.hostConfirmed ? Colors.green : Colors.grey,
          ),
          tooltip: 'Approve',
          onPressed: onApprove,
        ),
        if (client.confirmed)
          DropdownButton<int>(
            hint: const Text('Assign player'),
            value: client.assignedPlayer,
            items: availablePlayers
                .map((p) => DropdownMenuItem(
                      value: p,
                      child: Text('P$p'),
                    ))
                .toList(),
            onChanged: onAssign,
          ),
        IconButton(
          onPressed: onDisconnect,
          icon: const Icon(Icons.close),
          tooltip: 'Disconnect',
        ),
      ],
    );
  }
}
