import 'dart:async';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/data/model/chart/filter/annual_sales_filter.dart';
import 'package:quantifico/data/model/chart/record/annual_sales_record.dart';
import 'package:quantifico/data/model/network_exception.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:quantifico/bloc/auth/barrel.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnnualSalesBloc extends ChartBloc {
  AnnualSalesFilter _activeFilter = AnnualSalesFilter(
    startYear: DateTime.now().year - 4,
    endYear: DateTime.now().year,
  );

  AnnualSalesBloc({
    @required AuthBloc authBloc,
    @required ChartRepository chartRepository,
  }) : super(authBloc: authBloc, chartRepository: chartRepository);

  @override
  Stream<ChartState> mapLoadSeriesToState() async* {
    try {
      yield const SeriesLoading();
      final annualSalesData = await chartRepository.getAnnualSalesData(filter: _activeFilter);
      if (annualSalesData.isNotEmpty) {
        final series = _buildSeries(annualSalesData);
        yield SeriesLoaded<AnnualSalesRecord, String, AnnualSalesFilter>(
          series,
          activeFilter: _activeFilter,
        );
      } else {
        yield SeriesLoadedEmpty<AnnualSalesFilter>(activeFilter: _activeFilter);
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
      _activeFilter = event.filter as AnnualSalesFilter;
      yield* mapLoadSeriesToState();
    } catch (e) {
      yield const SeriesNotLoaded();
      if (e is UnauthorizedRequestException) {
        authBloc.add(const CheckAuthentication());
      }
    }
  }

  List<charts.Series<AnnualSalesRecord, String>> _buildSeries(List<AnnualSalesRecord> data) {
    final numberFormat = NumberFormat.compactSimpleCurrency(locale: 'pt-BR', name: '');
    return [
      charts.Series<AnnualSalesRecord, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (AnnualSalesRecord record, _) => record.year ?? 'Outro',
        measureFn: (AnnualSalesRecord record, _) => record.sales,
        data: data,
        labelAccessorFn: (AnnualSalesRecord record, _) => numberFormat.format(record.sales),
      )
    ];
  }
}
