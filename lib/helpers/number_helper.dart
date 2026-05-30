import 'package:intl/intl.dart';

class NumberHelper {
  static String formatCurrency(num amount, {String symbol = '₫'}) {
    final formatter = NumberFormat('#,##0', 'vi_VN');
    return '${formatter.format(amount)}$symbol';
  }

  static String formatNumber(num number) {
    final formatter = NumberFormat('#,##0', 'vi_VN');
    return formatter.format(number);
  }

  static String formatCompact(num number) {
    if (number >= 1000000000) return '${(number / 1000000000).toStringAsFixed(1)}B';
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
    return number.toString();
  }
}
