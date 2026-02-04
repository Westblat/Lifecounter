import 'package:flutter/material.dart';
import 'package:the_lifecounter/components/remote/client_profile.dart';
import 'package:the_lifecounter/components/remote/client_profile_storage.dart';
import 'package:the_lifecounter/functions/player.dart';

class ClientProfileState {
  const ClientProfileState({
    required this.selectedButtons,
    required this.profiles,
    required this.activeProfileName,
  });

  final List<String> selectedButtons;
  final List<ClientProfile> profiles;
  final String? activeProfileName;
}

Future<ClientProfileState> loadClientProfileState() async {
  final data = await loadClientProfileStorage();
  return ClientProfileState(
    selectedButtons: data.selectedButtons,
    profiles: data.profiles,
    activeProfileName: data.activeProfileName,
  );
}

Future<ClientProfileState> applyClientProfile({
  required ClientProfile profile,
  required Player player,
  required List<String> selectedButtons,
  required List<ClientProfile> profiles,
  required String? activeProfileName,
  required void Function(String action, Map<String, dynamic> payload) send,
  required Future<void> Function(String background) saveBackground,
  required Future<void> Function(bool value) saveIcon,
  required Future<void> Function(bool value) saveBlur,
}) async {
  final nextSelectedButtons = List<String>.from(profile.selectedButtons);
  final nextActiveProfileName = profile.name;
  await saveSelectedButtons(nextSelectedButtons);
  if (profile.background != null && profile.background != player.background) {
    send('changeBackground',
        {'player': player.playerNumber, 'background': profile.background});
    await saveBackground(profile.background!);
  }
  if (profile.icon != null && profile.icon != player.icon) {
    send('toggleIcon', {'player': player.playerNumber});
    await saveIcon(profile.icon!);
  }
  if (profile.blur != null && profile.blur != player.blur) {
    send('toggleBlur', {'player': player.playerNumber});
    await saveBlur(profile.blur!);
  }
  await saveClientProfiles(profiles, nextActiveProfileName);
  return ClientProfileState(
    selectedButtons: nextSelectedButtons,
    profiles: profiles,
    activeProfileName: nextActiveProfileName,
  );
}

Future<ClientProfileState> saveProfileFromCurrent({
  required String name,
  required Player player,
  required List<String> selectedButtons,
  required List<ClientProfile> profiles,
}) async {
  final profile = ClientProfile(
    name: name,
    selectedButtons: List<String>.from(selectedButtons),
    background: player.background,
    icon: player.icon,
    blur: player.blur,
  );
  final nextProfiles = List<ClientProfile>.from(profiles)
    ..removeWhere((p) => p.name == profile.name)
    ..add(profile);
  await saveClientProfiles(nextProfiles, profile.name);
  return ClientProfileState(
    selectedButtons: selectedButtons,
    profiles: nextProfiles,
    activeProfileName: profile.name,
  );
}

Future<ClientProfileState> saveActiveProfile({
  required String activeProfileName,
  required Player player,
  required List<String> selectedButtons,
  required List<ClientProfile> profiles,
}) async {
  final profile = ClientProfile(
    name: activeProfileName,
    selectedButtons: List<String>.from(selectedButtons),
    background: player.background,
    icon: player.icon,
    blur: player.blur,
  );
  final nextProfiles = List<ClientProfile>.from(profiles)
    ..removeWhere((p) => p.name == profile.name)
    ..add(profile);
  await saveClientProfiles(nextProfiles, activeProfileName);
  return ClientProfileState(
    selectedButtons: selectedButtons,
    profiles: nextProfiles,
    activeProfileName: activeProfileName,
  );
}

Future<ClientProfileState> clearActiveProfile({
  required List<String> selectedButtons,
  required List<ClientProfile> profiles,
}) async {
  await saveClientProfiles(profiles, null);
  return ClientProfileState(
    selectedButtons: selectedButtons,
    profiles: profiles,
    activeProfileName: null,
  );
}

Future<ClientProfileState> deleteProfile({
  required String name,
  required List<String> selectedButtons,
  required List<ClientProfile> profiles,
  required String? activeProfileName,
}) async {
  final nextProfiles = List<ClientProfile>.from(profiles)
    ..removeWhere((p) => p.name == name);
  final nextActive =
      activeProfileName == name ? null : activeProfileName;
  await saveClientProfiles(nextProfiles, nextActive);
  return ClientProfileState(
    selectedButtons: selectedButtons,
    profiles: nextProfiles,
    activeProfileName: nextActive,
  );
}

Future<String?> promptProfileName(BuildContext context) async {
  final controller = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Save profile'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Profile name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(controller.text),
          child: const Text('Save'),
        ),
      ],
    ),
  );
  return result;
}
