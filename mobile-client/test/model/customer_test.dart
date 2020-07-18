import 'package:flutter_test/flutter_test.dart';
import 'package:quantifico/data/model/nf/customer.dart';

void main() {
  group('Customer model', () {
    test('should parse json into model', () {
      const json = {
        'cnpj': '87395844000168',
        'razaoSocial': 'RAKALO PRODUTOS DE BELEZA LTDA',
      };
      final customer = Customer.fromJson(json);
      expect(
        customer,
        const Customer(
          cnpj: '87395844000168',
          name: 'RAKALO PRODUTOS DE BELEZA LTDA',
        ),
      );
    });
  });
}
