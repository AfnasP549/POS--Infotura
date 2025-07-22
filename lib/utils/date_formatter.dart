import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDateTime(DateTime dateTime) {
    Intl.defaultLocale = 'en_US';
    final DateFormat formatter = DateFormat('dd/MM/yy HH:mm:ss');
    return formatter.format(dateTime);
  }
}