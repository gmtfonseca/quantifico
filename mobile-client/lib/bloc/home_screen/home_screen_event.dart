import 'package:equatable/equatable.dart';

abstract class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object> get props => [];
}

class RefreshHomeScreen extends HomeScreenEvent {
  const RefreshHomeScreen();

  @override
  String toString() => 'RefreshHomeScreen';
}

class UpdateStarredCharts extends HomeScreenEvent {
  const UpdateStarredCharts();

  @override
  String toString() => 'UpdateStarredCharts';
}

class LoadHomeScreen extends HomeScreenEvent {
  const LoadHomeScreen();

  @override
  String toString() => 'LoadHomeScreen';
}
