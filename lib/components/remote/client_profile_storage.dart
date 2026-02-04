import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_lifecounter/components/remote/client_profile.dart';

const String prefsSelectedButtonsKey = 'client_settings_selected_buttons';
const String prefsProfilesKey = 'client_settings_profiles';
const String prefsActiveProfileKey = 'client_settings_active_profile';

class ClientProfileStorageData {
  const ClientProfileStorageData({
    required this.selectedButtons,
    required this.profiles,
    required this.activeProfileName,
  });

  final List<String> selectedButtons;
  final List<ClientProfile> profiles;
  final String? activeProfileName;
}

Future<ClientProfileStorageData> loadClientProfileStorage() async {
  final prefs = await SharedPreferences.getInstance();
  final storedButtons = prefs.getStringList(prefsSelectedButtonsKey) ?? <String>[];
  final profileJson = prefs.getString(prefsProfilesKey);
  final activeProfile = prefs.getString(prefsActiveProfileKey);
  final profiles = decodeClientProfiles(profileJson);
  final active =
      profiles.any((p) => p.name == activeProfile) ? activeProfile : null;
  return ClientProfileStorageData(
    selectedButtons: storedButtons,
    profiles: profiles,
    activeProfileName: active,
  );
}

Future<void> saveClientProfiles(
  List<ClientProfile> profiles,
  String? activeProfileName,
) async {
  final prefs = await SharedPreferences.getInstance();
  final encoded = encodeClientProfiles(profiles);
  await prefs.setString(prefsProfilesKey, encoded);
  if (activeProfileName != null) {
    await prefs.setString(prefsActiveProfileKey, activeProfileName);
  } else {
    await prefs.remove(prefsActiveProfileKey);
  }
}

Future<void> saveSelectedButtons(List<String> selectedButtons) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(prefsSelectedButtonsKey, selectedButtons);
}
