import 'dart:io';

import 'package:quantifico/data/model/chart/record/barrel.dart';
import 'package:quantifico/data/model/chart/record/product_sales_record.dart';
import 'package:quantifico/data/provider/token_local_provider.dart';
import 'package:quantifico/util/web_client.dart';
import 'package:meta/meta.dart';

class ChartWebProvider {
  final WebClient webClient;
  final TokenLocalProvider tokenLocalProvider;

  ChartWebProvider({
    @required this.webClient,
    @required this.tokenLocalProvider,
  });

  Future<List<AnnualSalesRecord>> fetchAnnualSalesData({
    int startYear,
    int endYear,
  }) async {
    final Map<String, String> params = Map();
    if (startYear != null) {
      params['anoinicial'] = startYear.toString();
    }

    if (endYear != null) {
      params['anofinal'] = endYear.toString();
    }

    final body = await _fetchChartData('nfs/plot/faturamento-anual', params);
    final data = body?.map((dynamic record) => AnnualSalesRecord.fromJson(record as Map<dynamic, dynamic>))?.toList();
    return data;
  }

  Future<List<CustomerSalesRecord>> fetchCustomerSalesData({
    DateTime startDate,
    DateTime endDate,
    int limit,
    int sort,
  }) async {
    final Map<String, String> params = Map();

    if (startDate != null) {
      params['datainicial'] = startDate.toString();
    }

    if (endDate != null) {
      params['datafinal'] = endDate.toString();
    }

    if (limit != null) {
      params['limit'] = limit.toString();
    }

    if (sort != null) {
      params['sort'] = sort.toString();
    }

    final body = await _fetchChartData('nfs/plot/faturamento-cliente', params);
    final data = body?.map((dynamic record) => CustomerSalesRecord.fromJson(record as Map<dynamic, dynamic>))?.toList();
    return data;
  }

  Future<List<CitySalesRecord>> fetchCitySalesData({
    DateTime startDate,
    DateTime endDate,
    int limit,
    int sort,
  }) async {
    final Map<String, String> params = Map();

    if (startDate != null) {
      params['datainicial'] = startDate.toString();
    }

    if (endDate != null) {
      params['datafinal'] = endDate.toString();
    }
    if (limit != null) {
      params['limit'] = limit.toString();
    }

    if (sort != null) {
      params['sort'] = sort.toString();
    }

    final body = await _fetchChartData('nfs/plot/faturamento-cidade', params);
    final data = body?.map((dynamic record) => CitySalesRecord.fromJson(record as Map<dynamic, dynamic>))?.toList();
    return data;
  }

  Future<List<MonthlySalesRecord>> fetchMonthlySalesData({@required List<int> years}) async {
    if (years.isEmpty) {
      return [];
    }

    final Map<String, String> params = Map();
    params['anos'] = years.join(',');

    final body = await _fetchChartData('nfs/plot/faturamento-mensal', params);
    final data = body?.map((dynamic record) => MonthlySalesRecord.fromJson(record as Map<dynamic, dynamic>))?.toList();
    return data;
  }

  Future<List<ProductSalesRecord>> fetchProductSalesData({
    DateTime startDate,
    DateTime endDate,
    int limit,
    int sort,
  }) async {
    final Map<String, String> params = Map();

    if (startDate != null) {
      params['datainicial'] = startDate.toString();
    }

    if (endDate != null) {
      params['datafinal'] = endDate.toString();
    }

    if (limit != null) {
      params['limit'] = limit.toString();
    }

    if (sort != null) {
      params['sort'] = sort.toString();
    }

    final body = await _fetchChartData('nfs/plot/faturamento-produto', params);
    final data = body?.map((dynamic record) => ProductSalesRecord.fromJson(record as Map<dynamic, dynamic>))?.toList();
    return data;
  }

  Future<List<dynamic>> _fetchChartData(String endpoint, Map<String, String> params) async {
    final headers = await _getHeaders();
    final body = await webClient.fetch(
      endpoint,
      params: params.isNotEmpty ? params : null,
      headers: headers,
    ) as List<dynamic>;

    return body;
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await tokenLocalProvider.getToken();
    return {
      HttpHeaders.authorizationHeader: token,
    };
  }
}
