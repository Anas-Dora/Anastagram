import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateFormatter {
  static String formatRelativeDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('HH:mm').format(dateTime);
    return '$formattedDate | ${timeago.format(dateTime)}';
  }

  static String extractDate(String datetime) {
    DateTime parsed = DateTime.parse(datetime);

    String day = parsed.day.toString().padLeft(2, '0');
    String month = parsed.month.toString().padLeft(2, '0');
    String year = parsed.year.toString();

    return '$day.$month.$year';
  }
}
