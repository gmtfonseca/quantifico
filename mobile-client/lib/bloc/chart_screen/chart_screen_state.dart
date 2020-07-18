import 'package:equatable/equatable.dart';
import 'package:quantifico/bloc/chart/special/barrel.dart';

abstract class ChartScreenState extends Equatable {
  const ChartScreenState();

  @override
  List<Object> get props => [];
}

class ChartScreenLoading extends ChartScreenState {
  const ChartScreenLoading();
}

class ChartScreenLoaded extends ChartScreenState {
  final AnnualSalesBloc annualSalesBloc;
  final CustomerSalesBloc customerSalesBloc;
  final CitySalesBloc citySalesBloc;
  final MonthlySalesBloc monthlySalesBloc;

  const ChartScreenLoaded({
    this.annualSalesBloc,
    this.customerSalesBloc,
    this.citySalesBloc,
    this.monthlySalesBloc,
  });

  @override
  List<Object> get props => [annualSalesBloc, customerSalesBloc];
}

class ChartScreenNotLoaded extends ChartScreenState {
  const ChartScreenNotLoaded();
}
