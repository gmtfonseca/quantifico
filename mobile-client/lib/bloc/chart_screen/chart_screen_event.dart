import 'package:equatable/equatable.dart';

abstract class ChartScreenEvent extends Equatable {
  const ChartScreenEvent();

  @override
  List<Object> get props => [];
}

class LoadChartScreen extends ChartScreenEvent {
  const LoadChartScreen();

  @override
  String toString() => 'LoadChartScreen';
}

class RefreshChartScreen extends ChartScreenEvent {
  const RefreshChartScreen();

  @override
  String toString() => 'RefreshChartScreen';
}
