import 'package:intl/intl.dart';

String formatNumber(num value) {
  final formatter = NumberFormat('##0.00');
  return formatter.format(value);
}

String formatCurrency(num value) {
  final formatter = NumberFormat.currency(symbol: 'R\$');
  return formatter.format(value);
}
