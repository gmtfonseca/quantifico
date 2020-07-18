import 'package:flutter_test/flutter_test.dart';
import 'package:quantifico/data/model/nf/nf_stats.dart';

void main() {
  group('Nf Test model', () {
    test('should parse json into model', () {
      const json = {
        'totalNf': 100,
        'totalFaturado': 3000.50,
      };
      final nfStats = NfStats.fromJson(json);
      expect(
        nfStats,
        const NfStats(
          nfCount: 100,
          totalSales: 3000.50,
        ),
      );
    });
  });
}
