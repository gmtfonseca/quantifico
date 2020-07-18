import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/bloc/chart_container/chart_container_event.dart';
import 'package:quantifico/bloc/chart_container/chart_container_state.dart';
import 'package:quantifico/data/repository/chart_container_repository.dart';

class ChartContainerBloc<C> extends Bloc<ChartContainerEvent, ChartContainerState> {
  final String chartName;
  final ChartContainerRepository chartContainerRepository;
  final ChartBloc chartBloc;
  StreamSubscription chartSubscription;

  ChartContainerBloc({
    @required this.chartContainerRepository,
    @required this.chartBloc,
  }) : chartName = C.toString();

  @override
  ChartContainerState get initialState => const ChartContainerLoading();

  @override
  Stream<ChartContainerState> mapEventToState(ChartContainerEvent event) async* {
    if (event is LoadContainer) {
      yield* _mapLoadContainerToState();
    } else if (event is ChangeContainerColor) {
      yield* _mapChangeContainerColorToState(event);
    } else if (event is StarChart) {
      yield* _mapStarToState();
    } else if (event is UnstarChart) {
      yield* _mapUnstarToState();
    } else if (event is RefreshChart) {
      yield* _mapRefreshChartToState();
    }
  }

  Stream<ChartContainerState> _mapLoadContainerToState() async* {
    try {
      final defaultColor = Colors.white.value;
      final isStarred = chartContainerRepository.isStarred(chartName);
      final color = chartContainerRepository.getColor(chartName) ?? defaultColor;
      yield ChartContainerLoaded(isStarred: isStarred, color: Color(color));
    } catch (e) {
      yield const ChartContainerNotLoaded();
    }
  }

  Stream<ChartContainerState> _mapChangeContainerColorToState(ChangeContainerColor event) async* {
    if (state is ChartContainerLoaded) {
      final currState = state as ChartContainerLoaded;
      try {
        await chartContainerRepository.changeColor(chartName, event.color.value);
        yield ChartContainerLoaded(isStarred: currState.isStarred, color: event.color);
      } catch (e) {
        yield const ChartContainerNotLoaded();
      }
    }
  }

  Stream<ChartContainerState> _mapStarToState() async* {
    if (state is ChartContainerLoaded) {
      final currState = state as ChartContainerLoaded;
      try {
        chartContainerRepository.star(chartName);
        final isStarred = chartContainerRepository.isStarred(chartName);
        yield ChartContainerLoaded(isStarred: isStarred, color: currState.color);
      } catch (e) {
        yield const ChartContainerNotLoaded();
      }
    }
  }

  Stream<ChartContainerState> _mapUnstarToState() async* {
    if (state is ChartContainerLoaded) {
      final currState = state as ChartContainerLoaded;
      try {
        chartContainerRepository.unstar(chartName);
        final isStarred = chartContainerRepository.isStarred(chartName);
        yield ChartContainerLoaded(isStarred: isStarred, color: currState.color);
      } catch (e) {
        yield const ChartContainerNotLoaded();
      }
    }
  }

  Stream<ChartContainerState> _mapRefreshChartToState() async* {
    chartBloc.add(const RefreshSeries());
  }

  @override
  Future<void> close() {
    chartSubscription?.cancel();
    return super.close();
  }
}
