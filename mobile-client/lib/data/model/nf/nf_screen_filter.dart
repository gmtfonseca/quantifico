import 'package:equatable/equatable.dart';

class NfScreenFilter extends Equatable {
  final DateTime initialDate;
  final DateTime endDate;
  final String customerName;

  const NfScreenFilter({
    this.initialDate,
    this.endDate,
    this.customerName,
  });

  @override
  List<Object> get props => [
        initialDate,
        endDate,
        customerName,
      ];

  @override
  String toString() {
    return 'NfScreenFilter{initialDate: $initialDate, endDate: $endDate, customerName: $customerName';
  }
}
