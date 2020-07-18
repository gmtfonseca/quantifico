import 'dart:async';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/data/model/chart/filter/monthly_sales_filter.dart';
import 'package:quantifico/data/model/chart/record/monthly_sales_record.dart';
import 'package:quantifico/data/model/network_exception.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:quantifico/bloc/auth/barrel.dart';

class MonthlySalesBloc extends ChartBloc {
  MonthlySalesFilter _activeFilter = MonthlySalesFilter(years: [DateTime.now().year]);

  MonthlySalesBloc({
    @required AuthBloc authBloc,
    @required ChartRepository chartRepository,
  }) : super(authBloc: authBloc, chartRepository: chartRepository);

  @override
  Stream<ChartState> mapLoadSeriesToState() async* {
    try {
      yield const SeriesLoading();
      final monthlySalesData = await chartRepository.getMonthlySalesData(filter: _activeFilter);
      if (monthlySalesData.isNotEmpty) {
        final monthlySalesMap = _monthlySalesListToMap(monthlySalesData);
        final seriesList = _buildSeries(monthlySalesMap);
        yield SeriesLoaded<MonthSales, int, MonthlySalesFilter>(
          seriesList,
          activeFilter: _activeFilter,
        );
      } else {
        yield SeriesLoadedEmpty<MonthlySalesFilter>(activeFilter: _activeFilter);
      }
    } catch (e) {
      yield const SeriesNotLoaded();
      if (e is UnauthorizedRequestException) {
        authBloc.add(const CheckAuthentication());
      }
    }
  }

  @override
  Stream<ChartState> mapUpdateFilterToState(UpdateFilter event) async* {
    try {
      _activeFilter = event.filter as MonthlySalesFilter;
      yield* mapLoadSeriesToState();
    } catch (e) {
      yield const SeriesNotLoaded();
      if (e is UnauthorizedRequestException) {
        authBloc.add(const CheckAuthentication());
      }
    }
  }

  Map<String, Map<String, double>> _monthlySalesListToMap(List<MonthlySalesRecord> data) {
    final Map<String, Map<String, double>> years = Map();

    for (final record in data) {
      if (!years.containsKey(record.year)) {
        years[record.year] = {};
      }

      years[record.year][record.month] = record.sales;
    }

    return years;
  }

  List<charts.Series<MonthSales, int>> _buildSeries(Map<String, Map<String, double>> monthlySalesMap) {
    final colors = [
      charts.MaterialPalette.blue,
      charts.MaterialPalette.red,
      charts.MaterialPalette.green,
      charts.MaterialPalette.yellow,
    ];

    final List<charts.Series<MonthSales, int>> seriesList = [];
    var colorIdx = 0;
    monthlySalesMap.forEach((year, months) {
      final data = _toFilledMonthSalesList(months);
      final color = colors[colorIdx];
      final series = charts.Series<MonthSales, int>(
        id: year,
        colorFn: (_, __) => color.shadeDefault,
        domainFn: (MonthSales record, _) => int.parse(record.month),
        measureFn: (MonthSales record, _) => record.sales,
        data: data,
      );
      colorIdx += 1;
      seriesList.add(series);
    });

    return seriesList;
  }

  List<MonthSales> _toFilledMonthSalesList(Map<String, double> year) {
    const MONTHS_IN_YEAR = 12;
    final List<MonthSales> data = [];
    for (var m = 1; m <= MONTHS_IN_YEAR; m++) {
      final month = m.toString();
      if (year.containsKey(month)) {
        data.add(MonthSales(month: month, sales: year[month]));
      } else {
        data.add(MonthSales(month: month, sales: 0.0));
      }
    }
    return data;
  }
}
