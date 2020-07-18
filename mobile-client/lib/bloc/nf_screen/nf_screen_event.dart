import 'package:equatable/equatable.dart';
import 'package:quantifico/data/model/nf/nf_screen_filter.dart';

abstract class NfScreenEvent extends Equatable {
  const NfScreenEvent();

  @override
  List<Object> get props => [];
}

class LoadNfScreen extends NfScreenEvent {
  const LoadNfScreen();

  @override
  String toString() => 'LoadNfScreen';
}

class UpdateFilterNfScreen extends NfScreenEvent {
  final NfScreenFilter filter;
  const UpdateFilterNfScreen(this.filter);

  @override
  String toString() => 'UpdateFilterNfScreen {filter: $filter}';
}

class LoadMoreNfScreen extends NfScreenEvent {
  const LoadMoreNfScreen();

  @override
  String toString() => 'LoadMoreNfScreen';
}
