import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String cnpj;
  final String name;

  const Customer({
    this.cnpj,
    this.name,
  });

  Customer.fromJson(Map json)
      : cnpj = json['cnpj']?.toString(),
        name = json['razaoSocial']?.toString();

  @override
  List<Object> get props => [
        cnpj,
        name,
      ];

  @override
  String toString() {
    return 'Customer{cnpj: $cnpj, name: $name}';
  }
}
