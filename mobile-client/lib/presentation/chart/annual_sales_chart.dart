import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:intl/intl.dart';
import 'package:quantifico/data/model/chart/filter/annual_sales_filter.dart';
import 'package:quantifico/data/model/chart/record/annual_sales_record.dart';
import 'package:quantifico/presentation/chart/shared/chart.dart';
import 'package:quantifico/presentation/shared/filter_dialog.dart';

class AnnualSalesChart extends Chart {
  const AnnualSalesChart({
    Key key,
    @required ChartBloc bloc,
  }) : super(key: key, bloc: bloc);

  @override
  Widget buildContent() {
    final simpleCurrencyFormatter = charts.BasicNumericTickFormatterSpec.fromNumberFormat(
      NumberFormat.compactSimpleCurrency(locale: 'pt-BR'),
    );

    final state = bloc.state as SeriesLoaded<AnnualSalesRecord, String, AnnualSalesFilter>;
    return charts.BarChart(
      state.series,
      animate: true,
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickFormatterSpec: simpleCurrencyFormatter,
        renderSpec: const charts.GridlineRendererSpec(
          lineStyle: charts.LineStyleSpec(color: charts.Color.transparent),
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
          ),
        ),
      ),
      barRendererDecorator: charts.BarLabelDecorator<String>(),
    );
  }

  @override
  Widget buildFilterDialog() {
    if (bloc.state is FilterableState) {
      final state = bloc.state as FilterableState;
      return AnnualSalesFiltersDialog(
        startYear: (state.activeFilter as AnnualSalesFilter)?.startYear,
        endYear: (state.activeFilter as AnnualSalesFilter)?.endYear,
        onApply: ({int startYear, int endYear}) {
          bloc.add(
            UpdateFilter(
              AnnualSalesFilter(
                startYear: startYear,
                endYear: endYear,
              ),
            ),
          );
        },
      );
    } else {
      return null;
    }
  }
}

class AnnualSalesFiltersDialog extends StatefulWidget {
  final void Function({int startYear, int endYear}) onApply;
  final int startYear;
  final int endYear;

  const AnnualSalesFiltersDialog({
    this.onApply,
    this.startYear,
    this.endYear,
  });

  @override
  _AnnualSalesFiltersDialogState createState() => _AnnualSalesFiltersDialogState();
}

class _AnnualSalesFiltersDialogState extends State<AnnualSalesFiltersDialog> {
  final TextEditingController _startYearController = TextEditingController();
  final TextEditingController _endYearController = TextEditingController();
  bool _isValidFilter;

  @override
  void initState() {
    super.initState();
    _isValidFilter = true;
    _startYearController.text = widget.startYear?.toString();
    _endYearController.text = widget.endYear?.toString();
  }

  void _validateFilter() {
    setState(() {
      const MAX_YEAR_INTERVAL = 4;
      if (_startYearController.text.isEmpty || _endYearController.text.isEmpty) {
        _isValidFilter = false;
      }

      final startYear = int.parse(_startYearController.text);
      final endYear = int.parse(_endYearController.text);

      _isValidFilter = (startYear - endYear).abs() <= MAX_YEAR_INTERVAL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FilterDialog(
      onApply: _isValidFilter
          ? () => widget.onApply(
                startYear: _startYearController.text.isNotEmpty ? int.parse(_startYearController.text) : null,
                endYear: _endYearController.text.isNotEmpty ? int.parse(_endYearController.text) : null,
              )
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _startYearController,
              onChanged: (_) => _validateFilter(),
              maxLength: 4,
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: 'Ano inicial',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _endYearController,
              onChanged: (_) => _validateFilter(),
              maxLength: 4,
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: 'Ano final',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 15),
            const Text(
              'Intervalo máximo de 4 anos',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
