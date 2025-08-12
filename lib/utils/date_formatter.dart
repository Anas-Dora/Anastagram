import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateFormatter {
  static String formatRelativeDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('HH:mm').format(dateTime);
    return '$formattedDate | ${timeago.format(dateTime)}';
  }
}
