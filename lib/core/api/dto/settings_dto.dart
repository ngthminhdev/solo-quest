/// App settings DTO from /api/settings
class AppSettingsDto {
  final bool notificationsEnabled;
  final bool soundEnabled;
  final String theme;
  final String language;
  final Map<String, dynamic> preferences;

  AppSettingsDto({
    required this.notificationsEnabled,
    required this.soundEnabled,
    required this.theme,
    required this.language,
    required this.preferences,
  });

  factory AppSettingsDto.fromJson(Map<String, dynamic> json) {
    return AppSettingsDto(
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      soundEnabled: json['sound_enabled'] as bool? ?? true,
      theme: json['theme'] as String? ?? 'system',
      language: json['language'] as String? ?? 'vi',
      preferences: (json['preferences'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications_enabled': notificationsEnabled,
      'sound_enabled': soundEnabled,
      'theme': theme,
      'language': language,
      'preferences': preferences,
    };
  }
}
