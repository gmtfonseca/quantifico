import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ProductSalesRecord extends Equatable {
  final String product;
  final double sales;

  const ProductSalesRecord({
    @required this.product,
    @required this.sales,
  });

  ProductSalesRecord.fromJson(Map json)
      : product = json['descricao']?.toString(),
        sales = double.tryParse(json['totalFaturado']?.toString());

  @override
  List<Object> get props => [
        product,
        sales,
      ];

  @override
  String toString() {
    return 'ProductSalesRecord{product: $product, sales: $sales}';
  }
}
