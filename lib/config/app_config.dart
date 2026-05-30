import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class AppConfig {
  static AppConfig? _instance;
  static AppConfig get instance => _instance!;

  final String apiHost;
  final String appVersion;
  final String env;
  final bool isWriteLogToServer;

  String get scheme => env == 'local' ? 'http' : 'https';
  int get versionCode => _parseVersionCode(appVersion);

  AppConfig._({
    required this.apiHost,
    required this.appVersion,
    required this.env,
    required this.isWriteLogToServer,
  });

  static Future<void> load({String configFile = 'assets/config.yaml'}) async {
    final yamlString = await rootBundle.loadString(configFile);
    final yamlMap = loadYaml(yamlString) as YamlMap;
    _instance = AppConfig._(
      apiHost: yamlMap['apiHost'] as String,
      appVersion: (yamlMap['appVersion'] ?? '1.0.0').toString(),
      env: (yamlMap['env'] ?? 'production').toString(),
      isWriteLogToServer: _parseBoolFlag(yamlMap['isWriteLogToServer'], defaultValue: true),
    );
  }

  static int _parseVersionCode(String version) {
    final parts = version.split('.');
    if (parts.length >= 3) {
      return int.tryParse(parts[0])! * 10000 + int.tryParse(parts[1])! * 100 + int.tryParse(parts[2])!;
    }
    return 0;
  }

  static bool _parseBoolFlag(dynamic value, {bool defaultValue = false}) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return defaultValue;
  }
}
