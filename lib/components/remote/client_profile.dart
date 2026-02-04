import 'dart:convert';

class ClientProfile {
  const ClientProfile({
    required this.name,
    required this.selectedButtons,
    required this.background,
    required this.icon,
    required this.blur,
  });

  final String name;
  final List<String> selectedButtons;
  final String? background;
  final bool? icon;
  final bool? blur;

  Map<String, dynamic> toJson() => {
        'name': name,
        'selectedButtons': selectedButtons,
        'background': background,
        'icon': icon,
        'blur': blur,
      };

  factory ClientProfile.fromJson(Map<String, dynamic> json) {
    final buttons = json['selectedButtons'];
    return ClientProfile(
      name: json['name'] as String? ?? 'Profile',
      selectedButtons:
          buttons is List ? buttons.map((e) => e.toString()).toList() : <String>[],
      background: json['background'] as String?,
      icon: json['icon'] as bool?,
      blur: json['blur'] as bool?,
    );
  }
}

List<ClientProfile> decodeClientProfiles(String? jsonStr) {
  if (jsonStr == null || jsonStr.trim().isEmpty) return [];
  try {
    final raw = jsonDecode(jsonStr);
    if (raw is! List) return [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(ClientProfile.fromJson)
        .toList();
  } catch (_) {
    return [];
  }
}

String encodeClientProfiles(List<ClientProfile> profiles) {
  return jsonEncode(profiles.map((p) => p.toJson()).toList(growable: false));
}
