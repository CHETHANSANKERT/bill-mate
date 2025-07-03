import 'package:intl/intl.dart';

extension CustomDateFormatter on DateTime {
  String get cddmmyyyy => DateFormat('yyyy-MM-dd').format(this);
}