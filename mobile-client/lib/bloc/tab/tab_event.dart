import 'package:equatable/equatable.dart';
import 'package:quantifico/data/model/tab.dart';

abstract class TabEvent extends Equatable {
  const TabEvent();
}

class UpdateTab extends TabEvent {
  final Tab tab;

  const UpdateTab(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'UpdateTab { tab: $tab }';
}
