import 'dart:async';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/chart/record/city_sales_record.dart';
import 'package:quantifico/data/model/chart/filter/city_sales_filter.dart';
import 'package:quantifico/data/model/network_exception.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:quantifico/util/string_util.dart';
import 'package:quantifico/bloc/auth/barrel.dart';

class CitySalesBloc extends ChartBloc {
  CitySalesFilter _activeFilter = CitySalesFilter(
    limit: ChartConfig.maxRecordLimit,
    sort: -1,
  );

  CitySalesBloc({
    @required AuthBloc authBloc,
    @required ChartRepository chartRepository,
  }) : super(authBloc: authBloc, chartRepository: chartRepository);

  @override
  Stream<ChartState> mapLoadSeriesToState() async* {
    try {
      yield const SeriesLoading();
      final citySalesData = await chartRepository.getCitySalesData(filter: _activeFilter);
      if (citySalesData.isNotEmpty) {
        final series = _buildSeries(citySalesData);
        yield SeriesLoaded<CitySalesRecord, String, CitySalesFilter>(
          series,
          activeFilter: _activeFilter,
        );
      } else {
        yield SeriesLoadedEmpty<CitySalesFilter>(
          activeFilter: _activeFilter,
        );
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
      _activeFilter = event.filter as CitySalesFilter;
      yield* mapLoadSeriesToState();
    } catch (e) {
      yield const SeriesNotLoaded();
      if (e is UnauthorizedRequestException) {
        authBloc.add(const CheckAuthentication());
      }
    }
  }

  List<charts.Series<CitySalesRecord, String>> _buildSeries(List<CitySalesRecord> data) {
    const MAX_CITY_LENGTH = 35;
    return [
      charts.Series<CitySalesRecord, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (CitySalesRecord record, _) => record.city,
        measureFn: (CitySalesRecord record, _) => record.sales,
        data: data,
        labelAccessorFn: (CitySalesRecord record, _) => toLimitedLength(
          record.city,
          MAX_CITY_LENGTH,
        ),
      )
    ];
  }
}
