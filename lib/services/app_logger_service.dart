import 'dart:developer' as developer;

void log(
  String message, {
  String? name,
  int level = 0,
  Object? error,
  StackTrace? stackTrace,
}) {
  final logName = name ?? 'app';
  final prefix = _levelPrefix(level);
  developer.log('$prefix[$logName] $message');

  if (error != null) {
    developer.log('$prefix[$logName] Error: $error');
  }
  if (stackTrace != null) {
    developer.log('$prefix[$logName] StackTrace: $stackTrace');
  }
}

String _levelPrefix(int level) {
  if (level >= 1000) return '[ERROR] ';
  if (level >= 900) return '[WARN] ';
  return '';
}
