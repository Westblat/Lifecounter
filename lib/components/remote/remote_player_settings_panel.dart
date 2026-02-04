import 'package:flutter/material.dart';
import 'package:the_lifecounter/components/common/settings_widget.dart';
import 'package:the_lifecounter/functions/player.dart';

class RemotePlayerSettingsPanel extends StatelessWidget {
  const RemotePlayerSettingsPanel({
    super.key,
    required this.selectedButtons,
    required this.setButtons,
    required this.player,
    required this.onChangeBackground,
    required this.onToggleIcon,
    required this.onToggleBlur,
    required this.profileNames,
    required this.profileBackgrounds,
    required this.activeProfileName,
    required this.onSelectProfile,
    required this.onClearProfile,
    required this.onDeleteProfile,
    required this.canSave,
    required this.onSave,
    required this.onSaveAsNew,
    required this.onDisconnect,
    required this.onClose,
  });

  final List<String> selectedButtons;
  final void Function(String button) setButtons;
  final Player player;
  final void Function(String background) onChangeBackground;
  final VoidCallback onToggleIcon;
  final VoidCallback onToggleBlur;
  final List<String> profileNames;
  final Map<String, String?> profileBackgrounds;
  final String? activeProfileName;
  final void Function(String name) onSelectProfile;
  final VoidCallback onClearProfile;
  final void Function(String name) onDeleteProfile;
  final bool canSave;
  final VoidCallback? onSave;
  final VoidCallback onSaveAsNew;
  final VoidCallback onDisconnect;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SettingsWidget(
          selectedButtons: selectedButtons,
          setButtons: setButtons,
          player: player,
          onChangeBackground: onChangeBackground,
          onToggleIcon: onToggleIcon,
          onToggleBlur: onToggleBlur,
          profileNames: profileNames,
          profileBackgrounds: profileBackgrounds,
          activeProfileName: activeProfileName,
          onSelectProfile: onSelectProfile,
          onClearProfile: onClearProfile,
          onDeleteProfile: onDeleteProfile,
          showProfileActionInExtraActions: true,
          extraActions: [
            ListTile(
              leading: const Icon(Icons.save),
              title: const Text('Save'),
              enabled: canSave,
              onTap: canSave ? onSave : null,
            ),
            ListTile(
              leading: const Icon(Icons.save),
              title: const Text('Save as new'),
              onTap: onSaveAsNew,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Disconnect'),
              onTap: onDisconnect,
            ),
          ],
        ),
        Positioned(
          top: 4,
          right: 4,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
            tooltip: 'Close',
          ),
        ),
      ],
    );
  }
}
