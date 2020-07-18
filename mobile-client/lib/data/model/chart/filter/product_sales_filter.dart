import 'package:equatable/equatable.dart';

class ProductSalesFilter extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final int limit;
  final int sort;

  const ProductSalesFilter({
    this.startDate,
    this.endDate,
    this.limit,
    this.sort,
  });

  @override
  List<Object> get props => [
        startDate,
        endDate,
        limit,
        sort,
      ];
}
