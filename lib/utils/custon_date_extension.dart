import 'package:intl/intl.dart';

extension CustomDateFormatter on DateTime {
  String get cddmmyyyy => DateFormat('dd/MMM/yyyy').format(this);
}