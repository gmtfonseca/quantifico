import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ChartContainerState extends Equatable {
  const ChartContainerState();

  @override
  List<Object> get props => [];
}

class ChartContainerLoading extends ChartContainerState {
  const ChartContainerLoading();
}

class ChartContainerLoaded extends ChartContainerState {
  final bool isStarred;
  final Color color;

  const ChartContainerLoaded({
    this.isStarred,
    this.color,
  });

  @override
  List<Object> get props => [isStarred, color];
}

class ChartContainerNotLoaded extends ChartContainerState {
  const ChartContainerNotLoaded();
}

class ChartContainerEnabled extends ChartContainerState {
  const ChartContainerEnabled();
}
