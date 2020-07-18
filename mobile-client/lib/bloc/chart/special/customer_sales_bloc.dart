import 'dart:async';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/auth/auth_bloc.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/chart/filter/customer_sales_filter.dart';
import 'package:quantifico/data/model/chart/record/customer_sales_record.dart';
import 'package:quantifico/data/model/network_exception.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:quantifico/util/string_util.dart';
import 'package:quantifico/bloc/auth/barrel.dart';

class CustomerSalesBloc extends ChartBloc {
  CustomerSalesFilter _activeFilter = CustomerSalesFilter(
    limit: ChartConfig.maxRecordLimit,
    sort: -1,
  );

  CustomerSalesBloc({
    @required AuthBloc authBloc,
    @required ChartRepository chartRepository,
  }) : super(authBloc: authBloc, chartRepository: chartRepository);

  @override
  Stream<ChartState> mapLoadSeriesToState() async* {
    try {
      yield const SeriesLoading();
      final customerSalesData = await chartRepository.getCustomerSalesData(filter: _activeFilter);
      if (customerSalesData.isNotEmpty) {
        final series = _buildSeries(customerSalesData);
        yield SeriesLoaded<CustomerSalesRecord, String, CustomerSalesFilter>(
          series,
          activeFilter: _activeFilter,
        );
      } else {
        yield SeriesLoadedEmpty<CustomerSalesFilter>(
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
      _activeFilter = event.filter as CustomerSalesFilter;
      yield* mapLoadSeriesToState();
    } catch (e) {
      yield const SeriesNotLoaded();
      if (e is UnauthorizedRequestException) {
        authBloc.add(const CheckAuthentication());
      }
    }
  }

  List<charts.Series<CustomerSalesRecord, String>> _buildSeries(List<CustomerSalesRecord> data) {
    const MAX_CITY_LENGTH = 35;
    return [
      charts.Series<CustomerSalesRecord, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (CustomerSalesRecord record, _) => record.customer,
        measureFn: (CustomerSalesRecord record, _) => record.sales,
        data: data,
        labelAccessorFn: (CustomerSalesRecord record, _) => toLimitedLength(
          record.customer,
          MAX_CITY_LENGTH,
        ),
      )
    ];
  }
}
