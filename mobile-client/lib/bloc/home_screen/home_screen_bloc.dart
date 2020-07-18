import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/auth/barrel.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/bloc/chart/chart_event.dart';
import 'package:quantifico/bloc/home_screen/barrel.dart';
import 'package:quantifico/data/model/network_exception.dart';
import 'package:quantifico/data/repository/chart_container_repository.dart';
import 'package:quantifico/data/repository/nf_repository.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final AuthBloc authBloc;
  final ChartContainerRepository chartContainerRepository;
  final NfRepository nfRepository;
  final Map<String, ChartBloc> chartBlocs;

  HomeScreenBloc({
    @required this.authBloc,
    @required this.chartContainerRepository,
    @required this.nfRepository,
    @required this.chartBlocs,
  });

  @override
  HomeScreenState get initialState => const HomeScreenLoading();

  @override
  Stream<HomeScreenState> mapEventToState(HomeScreenEvent event) async* {
    if (event is LoadHomeScreen) {
      yield* _mapLoadHomeScreenToState();
    } else if (event is RefreshHomeScreen) {
      yield* _mapRefreshHomeScreenToState();
    } else if (event is UpdateStarredCharts) {
      yield* _mapUpdateStarredCharts();
    }
  }

  Stream<HomeScreenState> _mapLoadHomeScreenToState() async* {
    try {
      yield const HomeScreenLoading();
      final user = (authBloc.state as Authenticated).session.user;
      final starredCharts = chartContainerRepository.getStarred();
      _initiStarredCharts(starredCharts);
      starredCharts.sort();
      // Month and year were set just for testing
      final stats = await nfRepository.getStats(year: 2019, month: 5);
      yield HomeScreenLoaded(
        user: user,
        currDate: DateTime.now(),
        stats: stats,
        starredCharts: starredCharts,
      );
    } catch (e) {
      yield const HomeScreenNotLoaded();
      if (e is UnauthorizedRequestException) {
        authBloc.add(const CheckAuthentication());
      }
    }
  }

  Stream<HomeScreenState> _mapRefreshHomeScreenToState() async* {
    try {
      yield const HomeScreenLoading();
      final user = (authBloc.state as Authenticated).session.user;
      final starredCharts = chartContainerRepository.getStarred();
      _refreshStarredCharts(starredCharts);
      starredCharts.sort();
      // Month and year were set just for testing
      final stats = await nfRepository.getStats(year: 2019, month: 5);
      yield HomeScreenLoaded(
        user: user,
        currDate: DateTime.now(),
        stats: stats,
        starredCharts: starredCharts,
      );
    } catch (e) {
      yield const HomeScreenNotLoaded();
      if (e is UnauthorizedRequestException) {
        authBloc.add(const CheckAuthentication());
      }
    }
  }

  Stream<HomeScreenState> _mapUpdateStarredCharts() async* {
    if (state is HomeScreenLoaded) {
      try {
        final currState = state as HomeScreenLoaded;
        final starredCharts = chartContainerRepository.getStarred();
        starredCharts.sort();
        yield HomeScreenLoaded(
          user: currState.user,
          currDate: DateTime.now(),
          stats: currState.stats,
          starredCharts: starredCharts,
        );
      } catch (e) {
        yield const HomeScreenNotLoaded();
        if (e is UnauthorizedRequestException) {
          authBloc.add(const CheckAuthentication());
        }
      }
    }
  }

  void _refreshStarredCharts(List<String> starredCharts) {
    for (final chartName in starredCharts) {
      if (chartBlocs.containsKey(chartName)) {
        final chartBloc = chartBlocs[chartName];
        chartBloc.add(const RefreshSeries());
      }
    }
  }

  void _initiStarredCharts(List<String> starredCharts) {
    for (final chartName in starredCharts) {
      if (chartBlocs.containsKey(chartName)) {
        final chartBloc = chartBlocs[chartName];
        if (chartBloc.state is SeriesUninitialized) {
          chartBloc.add(const LoadSeries());
        }
      }
    }
  }
}
