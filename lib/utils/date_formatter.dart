import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateFormatter {
  static String formatRelativeDateTime(dynamic input) {
    final dateTime = parseDateTime(input);
    if (dateTime == null) {
      return '';
    }

    final formattedDate = DateFormat('HH:mm').format(dateTime);
    return '$formattedDate | ${timeago.format(dateTime)}';
  }

  static String extractDate(dynamic input) {
    final parsed = parseDateTime(input);
    if (parsed == null) {
      return '';
    }

    final day = parsed.day.toString().padLeft(2, '0');
    final month = parsed.month.toString().padLeft(2, '0');
    final year = parsed.year.toString();

    return '$day.$month.$year';
  }

  static DateTime? parseDateTime(dynamic input) {
    if (input is DateTime) {
      return input;
    }
    if (input is String) {
      return DateTime.tryParse(input)?.toLocal();
    }
    if (input is int) {
      return DateTime.fromMillisecondsSinceEpoch(
        input * 1000,
        isUtc: true,
      ).toLocal();
    }
    if (input is num) {
      return DateTime.fromMillisecondsSinceEpoch(
        input.toInt() * 1000,
        isUtc: true,
      ).toLocal();
    }
    return null;
  }
}
