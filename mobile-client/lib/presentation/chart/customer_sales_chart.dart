import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/chart/filter/customer_sales_filter.dart';
import 'package:quantifico/data/model/chart/record/customer_sales_record.dart';
import 'package:quantifico/presentation/chart/shared/chart.dart';
import 'package:intl/intl.dart';
import 'package:quantifico/presentation/shared/filter_dialog.dart';
import 'package:quantifico/presentation/shared/text_date_picker.dart';

class CustomerSalesChart extends Chart {
  const CustomerSalesChart({
    Key key,
    @required ChartBloc bloc,
  }) : super(key: key, bloc: bloc);

  @override
  Widget buildContent() {
    final simpleCurrencyFormatter = charts.BasicNumericTickFormatterSpec.fromNumberFormat(
      NumberFormat.compactSimpleCurrency(locale: 'pt-BR'),
    );

    final state = bloc.state as SeriesLoaded<CustomerSalesRecord, String, CustomerSalesFilter>;
    return charts.BarChart(
      state.series,
      animate: true,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(
        insideLabelStyleSpec: const charts.TextStyleSpec(color: charts.Color.white, fontSize: 11),
        outsideLabelStyleSpec: charts.TextStyleSpec(color: charts.Color.black.lighter, fontSize: 11),
      ),
      domainAxis: const charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickFormatterSpec: simpleCurrencyFormatter,
        renderSpec: const charts.GridlineRendererSpec(
          lineStyle: charts.LineStyleSpec(color: charts.Color.transparent),
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildFilterDialog() {
    if (bloc.state is FilterableState) {
      final activeFilter = (bloc.state as FilterableState).activeFilter as CustomerSalesFilter;

      return CustomerSalesFilterDialog(
        startDate: activeFilter?.startDate,
        endDate: activeFilter?.endDate,
        limit: activeFilter?.limit,
        sort: activeFilter?.sort,
        onApply: (startDate, endDate, limit, sort) {
          bloc.add(
            UpdateFilter(
              CustomerSalesFilter(
                startDate: startDate,
                endDate: endDate,
                limit: limit,
                sort: sort,
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

class CustomerSalesFilterDialog extends StatefulWidget {
  final void Function(
    DateTime startDate,
    DateTime endDate,
    int limit,
    int sort,
  ) onApply;
  final DateTime startDate;
  final DateTime endDate;
  final int limit;
  final int sort;

  const CustomerSalesFilterDialog({
    this.onApply,
    this.startDate,
    this.endDate,
    this.limit,
    this.sort,
  });

  @override
  _CustomerSalesFilterDialogState createState() => _CustomerSalesFilterDialogState();
}

class _CustomerSalesFilterDialogState extends State<CustomerSalesFilterDialog> {
  DateTime _startDate;
  DateTime _endDate;
  double _limit;
  int _sort;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _limit = widget.limit?.toDouble() ?? 1.0;
    _sort = widget.sort;
  }

  @override
  Widget build(BuildContext context) {
    return FilterDialog(
      onApply: () {
        widget.onApply(
          _startDate,
          _endDate,
          _limit.round(),
          _sort,
        );
      },
      onClear: () {
        setState(() {
          _startDate = null;
          _endDate = null;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateFields(),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Limite',
                  style: TextStyle(color: Colors.black54),
                ),
                Expanded(
                  child: Slider(
                    label: '${_limit.round()}',
                    value: _limit,
                    onChanged: (value) {
                      setState(() {
                        _limit = value;
                      });
                    },
                    min: 1.0,
                    max: ChartConfig.maxRecordLimit.toDouble(),
                    divisions: ChartConfig.maxRecordLimit,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '${_limit.round()}',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              'Ordem',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                FilterChip(
                  label: const Text('Crescente'),
                  selected: _sort == 1,
                  onSelected: (value) {
                    setState(() {
                      _sort = 1;
                    });
                  },
                ),
                const SizedBox(width: 5),
                FilterChip(
                  label: const Text('Decrescente'),
                  selected: _sort == -1,
                  onSelected: (value) {
                    setState(() {
                      _sort = -1;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFields() {
    final startDateField = TextDatePicker(
      onChanged: (value) {
        _startDate = value;
      },
      labelText: 'Data inicial',
      initialValue: _startDate,
    );

    final endDateField = TextDatePicker(
      onChanged: (value) {
        _endDate = value;
      },
      labelText: 'Data final',
      initialValue: _endDate,
    );

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Column(
        children: [
          startDateField,
          const SizedBox(height: 20),
          endDateField,
        ],
      );
    } else {
      return Row(
        children: [
          Flexible(child: startDateField),
          const SizedBox(width: 20),
          Flexible(child: endDateField),
        ],
      );
    }
  }
}
