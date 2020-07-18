import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String code;
  final String description;

  const Product({
    this.code,
    this.description,
  });

  Product.fromJson(Map json)
      : code = json['codigo']?.toString(),
        description = json['descricao']?.toString();

  @override
  List<Object> get props => [
        code,
        description,
      ];

  @override
  String toString() {
    return 'Product{code: $code, description: $description}';
  }
}
