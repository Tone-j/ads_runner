import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String toFormatted() => DateFormat('MMM d, yyyy').format(this);
  String toShortDate() => DateFormat('MM/dd/yy').format(this);
  String toFullDateTime() => DateFormat('MMM d, yyyy h:mm a').format(this);

  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return toFormatted();
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}
