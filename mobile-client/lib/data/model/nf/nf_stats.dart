import 'package:equatable/equatable.dart';

class NfStats extends Equatable {
  final int nfCount;
  final double totalSales;

  const NfStats({
    this.nfCount,
    this.totalSales,
  });

  NfStats.fromJson(Map json)
      : nfCount = int.tryParse(json['totalNf']?.toString()),
        totalSales = double.tryParse(json['totalFaturado']?.toString());

  @override
  List<Object> get props => [
        nfCount,
        totalSales,
      ];

  @override
  String toString() {
    return 'NfStats{nfCount: $nfCount, totalSales: $totalSales}';
  }
}
