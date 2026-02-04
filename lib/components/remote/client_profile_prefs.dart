import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_lifecounter/functions/player.dart';

const String prefsBackgroundKey = 'client_settings_background';
const String prefsIconKey = 'client_settings_icon';
const String prefsBlurKey = 'client_settings_blur';

Future<void> applyClientPrefsToHost({
  required Player player,
  required void Function(String action, Map<String, dynamic> payload) send,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final background = prefs.getString(prefsBackgroundKey);
  final icon = prefs.getBool(prefsIconKey);
  final blur = prefs.getBool(prefsBlurKey);
  if (background != null && background != player.background) {
    send('changeBackground',
        {'player': player.playerNumber, 'background': background});
  }
  if (icon != null && icon != player.icon) {
    send('toggleIcon', {'player': player.playerNumber});
  }
  if (blur != null && blur != player.blur) {
    send('toggleBlur', {'player': player.playerNumber});
  }
}

Future<void> saveClientBackground(String background) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(prefsBackgroundKey, background);
}

Future<void> saveClientIcon(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(prefsIconKey, value);
}

Future<void> saveClientBlur(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(prefsBlurKey, value);
}
