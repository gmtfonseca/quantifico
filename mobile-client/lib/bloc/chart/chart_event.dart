import 'package:equatable/equatable.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();

  @override
  List<Object> get props => [];
}

class LoadSeries extends ChartEvent {
  const LoadSeries();

  @override
  String toString() => 'LoadSeries';
}

class RefreshSeries extends ChartEvent {
  const RefreshSeries();

  @override
  String toString() => 'RefreshSeries';
}

class UpdateFilter<T> extends ChartEvent {
  final T filter;

  const UpdateFilter(this.filter);

  @override
  String toString() => 'UpdateFilter';
}
