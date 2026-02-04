import 'package:flutter/material.dart';
import 'package:the_lifecounter/components/common/commander_damage_row.dart';
import 'package:the_lifecounter/components/common/life_counter.dart';
import 'package:the_lifecounter/components/common/player_card_buttons.dart';
import 'package:the_lifecounter/functions/player.dart';
import 'package:the_lifecounter/functions/utlis.dart';
import 'package:the_lifecounter/state/game_state.dart';
import 'package:the_lifecounter/components/remote/client_profile.dart';
import 'package:the_lifecounter/components/remote/client_profile_actions.dart';
import 'package:the_lifecounter/components/remote/client_profile_storage.dart';
import 'package:the_lifecounter/components/remote/client_profile_prefs.dart';
import 'package:the_lifecounter/components/remote/remote_player_settings_panel.dart';

class RemotePlayerCard extends StatefulWidget {
  const RemotePlayerCard({
    super.key,
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
  State<RemotePlayerCard> createState() => _RemotePlayerCardState();
}

class _RemotePlayerCardState extends State<RemotePlayerCard>
    with SingleTickerProviderStateMixin {
  var settings = false;
  List<String> selectedButtons = ["othersMinusOne"];
  late AnimationController _animationController;
  bool _prefsLoaded = false;
  bool _prefsApplied = false;
  List<ClientProfile> _profiles = [];
  String? _activeProfileName;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0,
      upperBound: 1,
    );
    loadClientProfileState().then((data) {
      if (!mounted) return;
      setState(() {
        if (data.selectedButtons.isNotEmpty) {
          selectedButtons = data.selectedButtons;
        }
        _profiles = data.profiles;
        _activeProfileName = data.activeProfileName;
        _prefsLoaded = true;
      });
      applyClientPrefsToHost(player: widget.player, send: widget.send);
      _prefsApplied = true;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RemotePlayerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_prefsLoaded && !_prefsApplied) {
      applyClientPrefsToHost(player: widget.player, send: widget.send);
      _prefsApplied = true;
    }
  }

  void toggleSettings() {
    if (settings) {
      _animationController.reverse();
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          settings = !settings;
        });
      });
    } else {
      setState(() {
        settings = !settings;
        _animationController.forward();
      });
    }
  }

  void setButtons(String button) {
    setState(() {
      if (selectedButtons.contains(button)) {
        selectedButtons.remove(button);
      } else {
        selectedButtons.add(button);
      }
    });
    saveSelectedButtons(selectedButtons);
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    final state = widget.state;
    double width = MediaQuery.of(context).size.width;
    return DecoratedBox(
      decoration: getDecoration(player),
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey)),
        child: Stack(
          children: [
                if (settings)
              AnimatedBuilder(
                  animation: _animationController,
                  child: RemotePlayerSettingsPanel(
                    selectedButtons: selectedButtons,
                    setButtons: setButtons,
                    player: player,
                    onChangeBackground: (bg) {
                      widget.send('changeBackground',
                          {'player': player.playerNumber, 'background': bg});
                      saveClientBackground(bg);
                    },
                    onToggleIcon: () {
                      widget.send('toggleIcon', {'player': player.playerNumber});
                      saveClientIcon(!player.icon);
                    },
                    onToggleBlur: () {
                      widget.send('toggleBlur', {'player': player.playerNumber});
                      saveClientBlur(!player.blur);
                    },
                    profileNames: _profiles.map((p) => p.name).toList(),
                    profileBackgrounds: {
                      for (final p in _profiles) p.name: p.background
                    },
                    activeProfileName: _activeProfileName,
                        onSelectProfile: (name) {
                          final selected = _profiles.firstWhere((p) => p.name == name);
                          applyClientProfile(
                            profile: selected,
                            player: player,
                            selectedButtons: selectedButtons,
                            profiles: _profiles,
                            activeProfileName: _activeProfileName,
                            send: widget.send,
                            saveBackground: saveClientBackground,
                            saveIcon: saveClientIcon,
                            saveBlur: saveClientBlur,
                          ).then((next) {
                            if (!mounted) return;
                            setState(() {
                              selectedButtons = next.selectedButtons;
                              _activeProfileName = next.activeProfileName;
                            });
                          });
                        },
                    onClearProfile: () {
                      clearActiveProfile(
                        selectedButtons: selectedButtons,
                        profiles: _profiles,
                      ).then((next) {
                        if (!mounted) return;
                        setState(() {
                          _activeProfileName = next.activeProfileName;
                        });
                      });
                    },
                    onDeleteProfile: (name) async {
                      final confirmed = await _confirmDeleteProfile(name);
                      if (!mounted || !confirmed) return;
                      deleteProfile(
                        name: name,
                        selectedButtons: selectedButtons,
                        profiles: _profiles,
                        activeProfileName: _activeProfileName,
                      ).then((next) {
                        if (!mounted) return;
                        setState(() {
                          _profiles = next.profiles;
                          _activeProfileName = next.activeProfileName;
                        });
                      });
                    },
                        canSave: _activeProfileName != null,
                        onSave: _activeProfileName == null
                            ? null
                            : () {
                                saveActiveProfile(
                                  activeProfileName: _activeProfileName!,
                                  player: player,
                                  selectedButtons: selectedButtons,
                                  profiles: _profiles,
                                ).then((next) {
                                  if (!mounted) return;
                                  setState(() {
                                    _profiles = next.profiles;
                                  });
                                });
                              },
                    onSaveAsNew: () async {
                      final name = await promptProfileName(context);
                      if (!mounted || name == null || name.trim().isEmpty) return;
                      saveProfileFromCurrent(
                        name: name.trim(),
                        player: player,
                        selectedButtons: selectedButtons,
                        profiles: _profiles,
                      ).then((next) {
                        if (!mounted) return;
                        setState(() {
                          _profiles = next.profiles;
                          _activeProfileName = next.activeProfileName;
                        });
                      });
                    },
                    onDisconnect: widget.onDisconnect,
                    onClose: toggleSettings,
                  ),
                  builder: (context, child) => SlideTransition(
                        position: Tween(
                          begin: const Offset(0, 1),
                          end: const Offset(0, 0),
                        ).animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeInOut)),
                        child: child,
                      ))
            else
              Column(
                children: [
                  if (state.gameMode == 'commander')
                    CommanderDamageRow(
                      player: player,
                      state: state,
                      onDealDamage: (from, delta) => widget.send(
                        'dealCommanderDamage',
                        {
                          'player': player.playerNumber,
                          'from': from,
                          'delta': delta
                        },
                      ),
                    ),
                  Expanded(
                    child: LifeCounter(
                      player: player,
                      onChangeLife: (delta) => widget.send('changeLife',
                          {'player': player.playerNumber, 'delta': delta}),
                    ),
                  ),
                  if (width > 289)
                    Transform.translate(
                      offset: const Offset(0, -36),
                      child: CustomButtonRow(
                          player: player,
                          selectedButtons: selectedButtons,
                          onChangeLife: (delta) => widget.send('changeLife',
                              {'player': player.playerNumber, 'delta': delta}),
                          onChangeLifeAllPlayers: (delta) =>
                              widget.send('changeLifeAllPlayers', {'delta': delta}),
                          onChangeLifeOthers: (delta) => widget.send(
                              'changeLifeOthers',
                              {'player': player.playerNumber, 'delta': delta}),
                          onChangeLifeOthersAndSelf: (othersDelta, selfDelta) =>
                              widget.send('changeLifeOthersAndSelf', {
                                'player': player.playerNumber,
                                'othersDelta': othersDelta,
                                'selfDelta': selfDelta
                              }),
                          onChangePoison: (delta) => widget.send('changePoison',
                              {'player': player.playerNumber, 'delta': delta}),
                          onChangeExperience: (delta) => widget.send(
                              'changeExperience',
                              {'player': player.playerNumber, 'delta': delta})),
                    ),
                ],
              ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: toggleSettings,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDeleteProfile(String name) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete profile'),
        content: Text('Delete "$name"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result == true;
  }
}
