import '../config/app_config.dart';

void log(
  String message, {
  String? name,
  int level = 0,
  Object? error,
  StackTrace? stackTrace,
}) {
  final logName = name ?? 'app';
  final prefix = _levelPrefix(level);
  print('$prefix[$logName] $message');

  if (error != null) {
    print('$prefix[$logName] Error: $error');
  }
  if (stackTrace != null) {
    print('$prefix[$logName] StackTrace: $stackTrace');
  }
}

String _levelPrefix(int level) {
  if (level >= 1000) return '[ERROR] ';
  if (level >= 900) return '[WARN] ';
  return '';
}
