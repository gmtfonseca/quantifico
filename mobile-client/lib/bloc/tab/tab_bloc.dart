import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:quantifico/bloc/tab/tab.dart';
import 'package:quantifico/data/model/tab.dart';

class TabBloc extends Bloc<TabEvent, Tab> {
  @override
  Tab get initialState => Tab.home;

  @override
  Stream<Tab> mapEventToState(TabEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }
}
