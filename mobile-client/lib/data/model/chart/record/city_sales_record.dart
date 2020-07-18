import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CitySalesRecord extends Equatable {
  final String city;
  final double sales;

  const CitySalesRecord({
    @required this.city,
    @required this.sales,
  });

  CitySalesRecord.fromJson(Map json)
      : city = json['descricaoMunicipio']?.toString(),
        sales = double.tryParse(json['totalFaturado']?.toString());

  @override
  List<Object> get props => [
        city,
        sales,
      ];

  @override
  String toString() {
    return 'CitySalesRecord{city: $city, sales: $sales}';
  }
}
