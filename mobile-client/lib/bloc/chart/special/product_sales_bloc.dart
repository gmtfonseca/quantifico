import 'dart:async';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/chart/filter/product_sales_filter.dart';
import 'package:quantifico/data/model/chart/record/product_sales_record.dart';
import 'package:quantifico/data/model/network_exception.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:quantifico/util/string_util.dart';
import 'package:quantifico/bloc/auth/barrel.dart';

class ProductSalesBloc extends ChartBloc {
  ProductSalesFilter _activeFilter = ProductSalesFilter(
    limit: ChartConfig.maxRecordLimit,
    sort: -1,
  );

  ProductSalesBloc({
    @required AuthBloc authBloc,
    @required ChartRepository chartRepository,
  }) : super(authBloc: authBloc, chartRepository: chartRepository);

  @override
  Stream<ChartState> mapLoadSeriesToState() async* {
    try {
      yield const SeriesLoading();
      final productSalesData = await chartRepository.getProductSalesData(filter: _activeFilter);
      if (productSalesData.isNotEmpty) {
        final series = _buildSeries(productSalesData);
        yield SeriesLoaded<ProductSalesRecord, String, ProductSalesFilter>(
          series,
          activeFilter: _activeFilter,
        );
      } else {
        yield SeriesLoadedEmpty<ProductSalesFilter>(
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
      _activeFilter = event.filter as ProductSalesFilter;
      yield* mapLoadSeriesToState();
    } catch (e) {
      yield const SeriesNotLoaded();
      if (e is UnauthorizedRequestException) {
        authBloc.add(const CheckAuthentication());
      }
    }
  }

  List<charts.Series<ProductSalesRecord, String>> _buildSeries(List<ProductSalesRecord> data) {
    const MAX_CITY_LENGTH = 35;
    return [
      charts.Series<ProductSalesRecord, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
        domainFn: (ProductSalesRecord record, _) => record.product,
        measureFn: (ProductSalesRecord record, _) => record.sales,
        data: data,
        labelAccessorFn: (ProductSalesRecord record, _) => toLimitedLength(
          record.product,
          MAX_CITY_LENGTH,
        ),
      )
    ];
  }
}
