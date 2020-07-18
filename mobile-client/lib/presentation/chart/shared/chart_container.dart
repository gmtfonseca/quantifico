import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart_container/barrel.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/presentation/chart/shared/chart.dart';
import 'package:quantifico/presentation/chart/shared/full_screen_chart.dart';
import 'package:quantifico/presentation/shared/color_picker_dialog.dart';

enum ChartContainerOptions { refresh, filter, color, expand }

class ChartContainer extends StatelessWidget {
  final String title;
  final ChartContainerBloc bloc;
  final Chart chart;
  final VoidCallback onStarOrUnstar;
  final double height;

  const ChartContainer({
    Key key,
    @required this.bloc,
    @required this.chart,
    @required this.title,
    this.onStarOrUnstar,
    this.height = 440,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: height,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          elevation: 1.5,
          borderRadius: BorderRadius.circular(11),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Opacity(
                    opacity: 0.90,
                    child: chart,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<ChartContainerBloc, ChartContainerState>(
      bloc: bloc,
      builder: (
        BuildContext context,
        ChartContainerState state,
      ) {
        return Container(
          decoration: BoxDecoration(
            color: state is ChartContainerLoaded ? state.color : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: _buildTitle(state),
              ),
              Row(
                children: [
                  _buildStarButton(state),
                  _buildOptions(context, state),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(ChartContainerState state) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: state is ChartContainerLoaded ? _getTextColor(state) : Colors.black45,
      ),
    );
  }

  Widget _buildOptions(BuildContext context, ChartContainerState state) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return _buildLandscapeOptions(context, state);
    } else {
      return _buildPortraitOptions(context, state);
    }
  }

  Widget _buildLandscapeOptions(BuildContext context, ChartContainerState state) {
    return Row(
      children: [
        _buildRefreshButton(state),
        _buildChangeColorButton(context, state),
        _buildFilterButton(context, state),
        _buildFullScreenButton(context, state),
      ],
    );
  }

  Widget _buildPortraitOptions(BuildContext context, ChartContainerState state) {
    if (state is ChartContainerLoaded) {
      final textColor = _getTextColor(state);
      return PopupMenuButton<ChartContainerOptions>(
        color: state.color,
        icon: Icon(
          Icons.more_vert,
          color: textColor,
        ),
        onSelected: (ChartContainerOptions result) {
          switch (result) {
            case ChartContainerOptions.refresh:
              bloc.add(const RefreshChart());
              break;
            case ChartContainerOptions.color:
              _showColorPickerDialog(context, state.color);
              break;
            case ChartContainerOptions.filter:
              _showFilterDialog(context);
              break;
            case ChartContainerOptions.expand:
              _openFullScreenMode(context, state.color);
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<ChartContainerOptions>>[
          PopupMenuItem<ChartContainerOptions>(
            value: ChartContainerOptions.refresh,
            child: ListTile(
              leading: Icon(
                Icons.refresh,
                color: textColor,
              ),
              title: Text(
                'Atualizar',
                style: TextStyle(color: textColor),
              ),
            ),
          ),
          PopupMenuItem<ChartContainerOptions>(
            value: ChartContainerOptions.color,
            child: ListTile(
              leading: Icon(
                Icons.color_lens,
                color: textColor,
              ),
              title: Text(
                'Alterar cor',
                style: TextStyle(color: textColor),
              ),
            ),
          ),
          PopupMenuItem<ChartContainerOptions>(
            value: ChartContainerOptions.filter,
            child: ListTile(
              leading: Icon(
                Icons.filter_list,
                color: textColor,
              ),
              title: Text(
                'Filtrar',
                style: TextStyle(color: textColor),
              ),
            ),
          ),
          PopupMenuItem<ChartContainerOptions>(
            value: ChartContainerOptions.expand,
            child: ListTile(
              leading: Icon(
                Icons.fullscreen,
                color: textColor,
              ),
              title: Text(
                'Expandir',
                style: TextStyle(color: textColor),
              ),
            ),
          ),
        ],
      );
    } else {
      return PopupMenuButton<ChartContainerOptions>(
        enabled: false,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<ChartContainerOptions>>[],
        icon: Icon(
          Icons.more_vert,
          color: Colors.black45,
        ),
      );
    }
  }

  Widget _buildStarButton(ChartContainerState state) {
    if (state is ChartContainerLoaded) {
      return IconButton(
        icon: Icon(
          state.isStarred ? Icons.star : Icons.star_border,
          color: _getTextColor(state),
        ),
        onPressed: () {
          _starOrUnstar(state);
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.star_border),
        onPressed: null,
      );
    }
  }

  Widget _buildChangeColorButton(BuildContext context, ChartContainerState state) {
    if (state is ChartContainerLoaded) {
      return IconButton(
        icon: Icon(
          Icons.color_lens,
          color: _getTextColor(state),
        ),
        onPressed: () {
          _showColorPickerDialog(context, state.color);
        },
      );
    } else {
      return const IconButton(
        icon: Icon(
          Icons.color_lens,
          color: Colors.black45,
        ),
        onPressed: null,
      );
    }
  }

  Widget _buildRefreshButton(ChartContainerState state) {
    if (state is ChartContainerLoaded) {
      return IconButton(
          icon: Icon(
            Icons.refresh,
            color: _getTextColor(state),
          ),
          onPressed: () {
            bloc.add(const RefreshChart());
          });
    } else {
      return const IconButton(
        icon: Icon(
          Icons.refresh,
          color: Colors.black45,
        ),
        onPressed: null,
      );
    }
  }

  Widget _buildFilterButton(BuildContext context, ChartContainerState state) {
    if (state is ChartContainerLoaded) {
      return IconButton(
          icon: Icon(
            Icons.filter_list,
            color: _getTextColor(state),
          ),
          onPressed: () {
            _showFilterDialog(context);
          });
    } else {
      return const IconButton(
        icon: Icon(Icons.filter_list),
        onPressed: null,
      );
    }
  }

  Widget _buildFullScreenButton(BuildContext context, ChartContainerState state) {
    if (state is ChartContainerLoaded) {
      return IconButton(
        icon: Icon(
          Icons.fullscreen,
          color: _getTextColor(state),
        ),
        onPressed: () => _openFullScreenMode(context, state.color),
      );
    } else {
      return const IconButton(
        icon: Icon(Icons.fullscreen),
        onPressed: null,
      );
    }
  }

  void _starOrUnstar(ChartContainerLoaded state) {
    if (state.isStarred) {
      bloc.add(const UnstarChart());
    } else {
      bloc.add(const StarChart());
    }
    if (onStarOrUnstar != null) {
      onStarOrUnstar();
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) => chart.buildFilterDialog(),
    );
  }

  void _showColorPickerDialog(BuildContext context, Color initialColor) {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) => ColorPickerDialog(
        initialColor: initialColor,
        onSelected: (Color color) {
          bloc.add(ChangeContainerColor(color));
        },
        colors: [
          Colors.white,
          Colors.blue,
          Colors.red,
          Colors.green,
          Colors.deepPurple,
          Colors.teal,
          Colors.indigo,
          Colors.deepOrange,
        ],
      ),
    );
  }

  void _openFullScreenMode(BuildContext context, Color appBarColor) {
    final fullScreenRoute = PageRouteBuilder<FullScreenChart>(
      pageBuilder: (context, animation, secondaryAnimation) => FullScreenChart(
        title: title,
        appBarColor: appBarColor,
        child: chart,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );

    Navigator.of(context).push(fullScreenRoute);
  }

  Color _getTextColor(ChartContainerLoaded state) {
    final brightess = ThemeData.estimateBrightnessForColor(state.color);
    return brightess == Brightness.light ? Colors.black.withOpacity(0.75) : Colors.white;
  }
}
