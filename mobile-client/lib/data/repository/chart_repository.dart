import 'package:meta/meta.dart';
import 'package:quantifico/data/model/chart/filter/annual_sales_filter.dart';
import 'package:quantifico/data/model/chart/filter/city_sales_filter.dart';
import 'package:quantifico/data/model/chart/filter/customer_sales_filter.dart';
import 'package:quantifico/data/model/chart/filter/monthly_sales_filter.dart';
import 'package:quantifico/data/model/chart/filter/product_sales_filter.dart';
import 'package:quantifico/data/model/chart/record/barrel.dart';
import 'package:quantifico/data/model/chart/record/product_sales_record.dart';
import 'package:quantifico/data/provider/chart_web_provider.dart';

class ChartRepository {
  final ChartWebProvider chartWebProvider;

  ChartRepository({
    @required this.chartWebProvider,
  });

  Future<List<AnnualSalesRecord>> getAnnualSalesData({AnnualSalesFilter filter}) async {
    return await chartWebProvider.fetchAnnualSalesData(
      startYear: filter?.startYear,
      endYear: filter?.endYear,
    );
  }

  Future<List<CustomerSalesRecord>> getCustomerSalesData({CustomerSalesFilter filter}) async {
    return await chartWebProvider.fetchCustomerSalesData(
      startDate: filter?.startDate,
      endDate: filter?.endDate,
      limit: filter?.limit,
      sort: filter?.sort,
    );
  }

  Future<List<CitySalesRecord>> getCitySalesData({CitySalesFilter filter}) async {
    return await chartWebProvider.fetchCitySalesData(
      startDate: filter?.startDate,
      endDate: filter?.endDate,
      limit: filter?.limit,
      sort: filter?.sort,
    );
  }

  Future<List<MonthlySalesRecord>> getMonthlySalesData({MonthlySalesFilter filter}) async {
    return await chartWebProvider.fetchMonthlySalesData(years: filter?.years);
  }

  Future<List<ProductSalesRecord>> getProductSalesData({ProductSalesFilter filter}) async {
    return await chartWebProvider.fetchProductSalesData(
      startDate: filter?.startDate,
      endDate: filter?.endDate,
      limit: filter?.limit,
      sort: filter?.sort,
    );
  }
}
