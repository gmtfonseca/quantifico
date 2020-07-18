import 'package:equatable/equatable.dart';
import 'package:charts_flutter/flutter.dart' as charts;

abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object> get props => [];
}

class SeriesUninitialized extends ChartState {
  const SeriesUninitialized();
}

class SeriesLoading extends ChartState {
  const SeriesLoading();
}

class SeriesNotLoaded extends ChartState {
  const SeriesNotLoaded();
}

class FilterableState<F> extends ChartState {
  final F activeFilter;
  const FilterableState({this.activeFilter});

  @override
  List<Object> get props => [activeFilter];
}

class SeriesLoadedEmpty<F> extends FilterableState<F> {
  const SeriesLoadedEmpty({F activeFilter}) : super(activeFilter: activeFilter);

  @override
  String toString() {
    return 'SeriesLoadedEmpty activeFilter: $activeFilter';
  }
}

class SeriesLoaded<T, D, F> extends FilterableState<F> {
  final List<charts.Series<T, D>> series;

  const SeriesLoaded(this.series, {F activeFilter}) : super(activeFilter: activeFilter);

  @override
  List<Object> get props => [series];

  @override
  String toString() {
    return 'SeriesLoaded $series, activeFilter: $activeFilter';
  }
}
