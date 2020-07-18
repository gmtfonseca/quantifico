import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/bloc/chart/chart_event.dart';
import 'package:quantifico/bloc/chart/chart_state.dart';
import 'package:quantifico/presentation/shared/error_indicator.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';

abstract class Chart extends StatelessWidget {
  final ChartBloc bloc;

  const Chart({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is SeriesUninitialized) {
          return const Center(
            child: Text('Gráfico não inicializado'),
          );
        } else if (state is SeriesLoading) {
          return const LoadingIndicator();
        } else if (state is SeriesNotLoaded) {
          return ErrorIndicator(
            text: 'Erro ao carregar gráfico',
            onRetry: () {
              bloc.add(const LoadSeries());
            },
          );
        } else if (state is SeriesLoadedEmpty) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sem dados para exibir',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.sentiment_neutral,
                  color: Colors.black54,
                ),
              ],
            ),
          );
        } else {
          return buildContent();
        }
      },
    );
  }

  @protected
  Widget buildContent();

  Widget buildFilterDialog();
}
