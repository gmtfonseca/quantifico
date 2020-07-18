import 'package:equatable/equatable.dart';
import 'package:quantifico/data/model/nf/customer.dart';
import 'package:quantifico/data/model/nf/nf_item.dart';

class Nf extends Equatable {
  final String series;
  final int number;
  final DateTime date;
  final double totalAmount;
  final Customer customer;
  final List<NfItem> items;

  const Nf({
    this.series,
    this.number,
    this.date,
    this.totalAmount,
    this.customer,
    this.items,
  });

  Nf.fromJson(Map json)
      : series = json['serie']?.toString(),
        number = int.tryParse(json['numero']?.toString()),
        date = json['dataEmissao'] != null ? DateTime.tryParse(json['dataEmissao']?.toString()) : null,
        totalAmount = double.tryParse(json['total']['nf']?.toString()),
        customer = Customer.fromJson(json['cliente'] as Map),
        items = List.generate((json['saidas'] as Iterable).length, (i) {
          return NfItem.fromJson((json['saidas'] as List)[i] as Map);
        });

  @override
  List<Object> get props => [
        series,
        number,
        date,
        totalAmount,
        customer,
        items,
      ];

  @override
  String toString() {
    return 'Nf{series: $series, number: $number, date: $date, totalAmount: $totalAmount, customer: $customer, items: $items}';
  }
}
