import 'package:flutter_test/flutter_test.dart';
import 'package:quantifico/data/model/nf/nf_item.dart';
import 'package:quantifico/data/model/nf/product.dart';

void main() {
  group('Nf Item model', () {
    test('should parse json into model', () {
      const json = {
        'produto': {
          'codigo': 'PG001051',
          'descricao': 'GALO DOIDO',
        },
        'valor': {
          'unitario': 2.0,
          'total': 300.0,
        },
        'quantidade': 150
      };
      final nfItem = NfItem.fromJson(json);
      expect(
        nfItem,
        const NfItem(
          product: Product(
            code: 'PG001051',
            description: 'GALO DOIDO',
          ),
          unitPrice: 2.0,
          totalAmount: 300.0,
          quantity: 150.0,
        ),
      );
    });
  });
}
