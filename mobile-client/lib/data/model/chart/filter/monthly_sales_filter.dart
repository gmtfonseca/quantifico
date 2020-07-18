import 'package:equatable/equatable.dart';

class MonthlySalesFilter extends Equatable {
  final List<int> years;

  const MonthlySalesFilter({
    this.years,
  });

  @override
  List<Object> get props => [years];
}
