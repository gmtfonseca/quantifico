import 'package:flutter/material.dart' hide Tab;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/tab/tab.dart';
import 'package:quantifico/data/model/tab.dart';
import 'package:quantifico/presentation/screen/home_screen.dart';
import 'package:quantifico/presentation/screen/chart_screen.dart';
import 'package:quantifico/presentation/screen/nf_screen.dart';
import 'package:quantifico/presentation/shared/tab_selector.dart';
import 'package:quantifico/bloc/tab/tab_bloc.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<TabBloc, Tab>(
        builder: (context, activeTab) {
          return Scaffold(
            body: _buildBody(context, activeTab),
            bottomNavigationBar: _buildNavBar(context, activeTab),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, Tab activeTab) {
    switch (activeTab) {
      case Tab.home:
        return const HomeScreen();
      case Tab.chart:
        return const ChartScreen();
      case Tab.nf:
        return NfScreen();
      default:
        return Container();
    }
  }

  Widget _buildNavBar(BuildContext context, Tab activeTab) {
    final tabBloc = BlocProvider.of<TabBloc>(context);
    return TabSelector(
      activeTab: activeTab,
      onTabSelected: (tab) => tabBloc.add(UpdateTab(tab)),
    );
  }
}
