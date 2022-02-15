import 'package:intl/intl.dart';

class DateUtilities {
  static String format(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date);
  }
}