import 'package:intl/intl.dart';

class AppDateTime {
  static getFormattedDateFromFormattedString(
    {required value,
    String currentFormat =  "yyyy-MM-ddTHH:mm:ssZ",
    String desiredFormat = "yyyy-MM-dd HH:mm:ss",
    isUtc = false}) {
  DateTime? dateTime = DateTime.now();
  if (value != null || value.isNotEmpty) {
    try {
      dateTime = DateFormat(currentFormat).parse(value, isUtc).toLocal();
    } catch (e) {
      print("$e");
    }
  }
  return dateTime;
}
}