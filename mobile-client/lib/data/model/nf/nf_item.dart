import 'package:equatable/equatable.dart';
import 'package:quantifico/data/model/nf/product.dart';

class NfItem extends Equatable {
  final Product product;
  final double unitPrice;
  final double totalAmount;
  final double quantity;

  const NfItem({
    this.product,
    this.unitPrice,
    this.totalAmount,
    this.quantity,
  });

  NfItem.fromJson(Map json)
      : product = Product.fromJson(json['produto'] as Map),
        unitPrice = double.tryParse(json['valor']['unitario']?.toString()),
        totalAmount = double.tryParse(json['valor']['total']?.toString()),
        quantity = double.tryParse(json['quantidade']?.toString());

  @override
  List<Object> get props => [
        product,
        unitPrice,
        totalAmount,
        quantity,
      ];

  @override
  String toString() {
    return 'NfItem{product: $product, unitPrice: $unitPrice, totalAmount: $totalAmount, quantity: $quantity}';
  }
}
