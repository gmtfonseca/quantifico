import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ChartContainerEvent extends Equatable {
  const ChartContainerEvent();

  @override
  List<Object> get props => [];
}

class LoadContainer extends ChartContainerEvent {
  const LoadContainer();

  @override
  String toString() => 'LoadContainer';
}

class ChangeContainerColor extends ChartContainerEvent {
  final Color color;

  const ChangeContainerColor(this.color);

  @override
  String toString() => 'ChangeContainerColor';
}

class RefreshChart extends ChartContainerEvent {
  const RefreshChart();

  @override
  String toString() => 'RefreshChart';
}

class StarChart extends ChartContainerEvent {
  const StarChart();

  @override
  String toString() => 'StarChart';
}

class UnstarChart extends ChartContainerEvent {
  const UnstarChart();

  @override
  String toString() => 'UnstarChart';
}
