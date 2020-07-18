import 'package:equatable/equatable.dart';
import 'package:quantifico/data/model/auth/user.dart';
import 'package:quantifico/data/model/nf/nf_stats.dart';

abstract class HomeScreenState extends Equatable {
  const HomeScreenState();

  @override
  List<Object> get props => [];
}

class HomeScreenLoading extends HomeScreenState {
  const HomeScreenLoading();
}

class HomeScreenLoaded extends HomeScreenState {
  final User user;
  final DateTime currDate;
  final NfStats stats;
  final List<String> starredCharts;

  const HomeScreenLoaded({
    this.user,
    this.currDate,
    this.stats,
    this.starredCharts,
  });

  @override
  List<Object> get props => [starredCharts];
}

class HomeScreenNotLoaded extends HomeScreenState {
  const HomeScreenNotLoaded();
}
