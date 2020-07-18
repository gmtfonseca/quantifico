import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/data/model/chart/filter/monthly_sales_filter.dart';
import 'package:quantifico/presentation/chart/shared/chart.dart';
import 'package:quantifico/presentation/shared/filter_dialog.dart';

class MonthlySalesChart extends Chart {
  const MonthlySalesChart({
    Key key,
    @required ChartBloc bloc,
  }) : super(key: key, bloc: bloc);

  @override
  Widget buildContent() {
    final simpleCurrencyFormatter = charts.BasicNumericTickFormatterSpec.fromNumberFormat(
      NumberFormat.compactSimpleCurrency(locale: 'pt-BR'),
    );

    final customTickFormatter = charts.BasicNumericTickFormatterSpec((num month) {
      switch (month.toInt()) {
        case 1:
          return 'Jan';
        case 2:
          return 'Fev';
        case 3:
          return 'Mar';
        case 4:
          return 'Abr';
        case 5:
          return 'Mai';
        case 6:
          return 'Jun';
        case 7:
          return 'Jul';
        case 8:
          return 'Ago';
        case 9:
          return 'Set';
        case 10:
          return 'Out';
        case 11:
          return 'Nov';
        case 12:
          return 'Dez';
        default:
          return '';
      }
    });

    const MONTHS_IN_YEAR = 12;
    return charts.LineChart(
      (bloc.state as SeriesLoaded).series,
      animate: true,
      behaviors: [charts.SeriesLegend()],
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickFormatterSpec: simpleCurrencyFormatter,
        renderSpec: const charts.GridlineRendererSpec(
          lineStyle: charts.LineStyleSpec(color: charts.Color.transparent),
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
          ),
        ),
      ),
      domainAxis: charts.NumericAxisSpec(
        tickProviderSpec: const charts.BasicNumericTickProviderSpec(
          desiredTickCount: MONTHS_IN_YEAR,
          zeroBound: false,
          dataIsInWholeNumbers: true,
        ),
        tickFormatterSpec: customTickFormatter,
        renderSpec: const charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
    );
  }

  @override
  Widget buildFilterDialog() {
    if (bloc.state is FilterableState) {
      final state = bloc.state as FilterableState;
      return MonthlySalesFilterDialog(
        years: (state.activeFilter as MonthlySalesFilter)?.years,
        onApply: ({List<int> years}) {
          bloc.add(
            UpdateFilter(
              MonthlySalesFilter(years: years),
            ),
          );
        },
      );
    } else {
      return null;
    }
  }
}

class MonthlySalesFilterDialog extends StatefulWidget {
  final void Function({List<int> years}) onApply;
  final List<int> years;

  const MonthlySalesFilterDialog({
    this.onApply,
    this.years,
  });

  @override
  _MonthlySalesFilterDialogState createState() => _MonthlySalesFilterDialogState();
}

class _MonthlySalesFilterDialogState extends State<MonthlySalesFilterDialog> {
  final TextEditingController _yearController = TextEditingController();
  List<int> _years;
  bool _addButtonEnabled;

  @override
  void initState() {
    super.initState();
    _years = List.from(widget.years);
    _updateAddButtonAvailability();
  }

  @override
  Widget build(BuildContext context) {
    const verticalSpacing = SizedBox(height: 15);
    return FilterDialog(
      onApply: () {
        widget.onApply(years: _years);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quais anos você deseja visualizar?',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            verticalSpacing,
            Row(
              children: [
                _buildYearTextField(),
                _buildAddButton(),
              ],
            ),
            verticalSpacing,
            Wrap(
              spacing: 10,
              children: _buildYearChips(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearTextField() {
    return Expanded(
      child: TextField(
        controller: _yearController,
        autofocus: true,
        onChanged: (year) {
          setState(() {
            _updateAddButtonAvailability();
          });
        },
        decoration: const InputDecoration(
          labelText: 'Ano',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
        maxLength: 4,
      ),
    );
  }

  Widget _buildAddButton() {
    return FlatButton(
      child: const Text('ADICIONAR'),
      onPressed: _addButtonEnabled
          ? () {
              setState(() {
                _years.add(int.parse(_yearController.text));
                _yearController.clear();
                _updateAddButtonAvailability();
              });
            }
          : null,
    );
  }

  List<Widget> _buildYearChips() {
    return _years
        .map((year) => Chip(
              label: Text(year.toString()),
              onDeleted: () {
                setState(() {
                  _years.remove(year);
                  _updateAddButtonAvailability();
                });
              },
            ))
        .toList()
        .cast<Widget>();
  }

  void _updateAddButtonAvailability() {
    const YEAR_LENGTH = 4;
    const MAX_YEARS = 4;
    _addButtonEnabled = _yearController.text.length == YEAR_LENGTH && _years.length < MAX_YEARS;
  }
}
