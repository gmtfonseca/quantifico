import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CustomerSalesRecord extends Equatable {
  final String customer;
  final double sales;

  const CustomerSalesRecord({
    @required this.customer,
    @required this.sales,
  });

  CustomerSalesRecord.fromJson(Map json)
      : customer = json['razaoSocial']?.toString(),
        sales = double.tryParse(json['totalFaturado']?.toString());

  @override
  List<Object> get props => [
        customer,
        sales,
      ];

  @override
  String toString() {
    return 'CustomerSalesRecord{customer: $customer, sales: $sales}';
  }
}
