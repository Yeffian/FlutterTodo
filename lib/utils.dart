import 'package:intl/intl.dart';

class DateUtilities {
  static String format(DateTime date) {
    return DateFormat.yMd().add_jm().format(date);
  }
}