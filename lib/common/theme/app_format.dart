import 'package:intl/intl.dart';

class AppFormat {
  static DateFormat date = DateFormat("dd/MM/yyyy");
  static DateFormat time = DateFormat("HH:mm");
  static DateFormat fullTime = DateFormat("HH:mm:ss");
  static DateFormat dateTime = DateFormat("dd/MM/yyyy HH:mm");
  static DateFormat dateTimeRequest = DateFormat("dd-MM-yyyy");
  static DateFormat dateTimeResponse = DateFormat("yyyy-MM-dd HH:mm:ss");
  static DateFormat dateTimeResponse1 = DateFormat("dd/MM/yyyy HH:mm:ss");
  static DateFormat dateRequest = DateFormat("yyyy/MM/dd");
  static DateFormat year = DateFormat("yyyy");
  static NumberFormat quantity = NumberFormat("#,###.###");
  static NumberFormat chart = NumberFormat("#,###.#");
}
