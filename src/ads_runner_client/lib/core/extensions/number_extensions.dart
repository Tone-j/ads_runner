import 'package:intl/intl.dart';

extension NumberExtensions on num {
  String get toCurrency => NumberFormat.currency(symbol: 'R', decimalDigits: 0).format(this);
  String get toCurrencyDecimal => NumberFormat.currency(symbol: 'R', decimalDigits: 2).format(this);

  String get toCompact {
    if (this >= 1000000) return '${(this / 1000000).toStringAsFixed(1)}M';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}K';
    return toStringAsFixed(0);
  }

  String get toPercentage => '${toStringAsFixed(1)}%';
}
