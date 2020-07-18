import 'package:flutter_test/flutter_test.dart';
import 'package:quantifico/data/model/nf/product.dart';

void main() {
  group('Product model', () {
    test('should parse json into model', () {
      const json = {
        'codigo': 'PG001051',
        'descricao': 'GALO DOIDO',
      };
      final product = Product.fromJson(json);
      expect(
        product,
        const Product(
          code: 'PG001051',
          description: 'GALO DOIDO',
        ),
      );
    });
  });
}
