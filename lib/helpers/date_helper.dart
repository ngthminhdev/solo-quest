class DateHelper {
  static String _pad(int n) => n.toString().padLeft(2, '0');

  static String formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    return '${_pad(local.day)}/${_pad(local.month)}/${local.year}';
  }

  static String formatDate(DateTime date) {
    final local = date.toLocal();
    return '${_pad(local.day)}/${_pad(local.month)}/${local.year}';
  }

  static String formatDateRange(DateTime start, DateTime end) {
    return '${formatDate(start)} – ${formatDate(end)}';
  }

  static String formatTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    return '${_pad(local.hour)}:${_pad(local.minute)}';
  }

  static bool isSameDate(DateTime a, DateTime b) {
    final la = a.toLocal();
    final lb = b.toLocal();
    return la.year == lb.year && la.month == lb.month && la.day == lb.day;
  }

  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final local = dateTime.toLocal();
    final diff = now.difference(local);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return formatDateTime(dateTime);
  }

  static String formatWeekday(DateTime dateTime) {
    final local = dateTime.toLocal();
    const days = ['Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'];
    return days[local.weekday - 1];
  }

  static String formatFullDate(DateTime dateTime) {
    return '${formatWeekday(dateTime)}, ${formatDate(dateTime)}';
  }
}
