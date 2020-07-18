import 'package:intl/intl.dart';

String formatDate(DateTime date, [String format = 'dd/MM/yyyy']) {
  final formatter = DateFormat(format);
  return date != null ? formatter.format(date) : '';
}
