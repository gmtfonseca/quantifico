import 'package:equatable/equatable.dart';

class AnnualSalesFilter extends Equatable {
  final int startYear;
  final int endYear;

  const AnnualSalesFilter({
    this.startYear,
    this.endYear,
  });

  @override
  List<Object> get props => [
        startYear,
        endYear,
      ];
}
