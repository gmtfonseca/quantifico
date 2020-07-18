import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/auth/auth_bloc.dart';
import 'package:quantifico/bloc/tab/tab.dart';
import 'package:quantifico/bloc/nf_screen/barrel.dart';
import 'package:quantifico/bloc/tab/tab_bloc.dart';
import 'package:quantifico/data/repository/chart_container_repository.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:quantifico/data/repository/nf_repository.dart';
import 'package:quantifico/presentation/chart/annual_sales_chart.dart';
import 'package:quantifico/presentation/chart/city_sales_chart.dart';
import 'package:quantifico/presentation/chart/customer_sales_chart.dart';
import 'package:quantifico/presentation/chart/monthly_sales_chart.dart';
import 'package:quantifico/presentation/chart/product_sales_chart.dart';
import 'package:quantifico/bloc/chart/special/annual_sales_bloc.dart';
import 'package:quantifico/bloc/chart/special/city_sales_bloc.dart';
import 'package:quantifico/bloc/chart/special/customer_sales_bloc.dart';
import 'package:quantifico/bloc/chart/special/monthly_sales_bloc.dart';
import 'package:quantifico/bloc/chart/special/product_sales_bloc.dart';
import 'package:quantifico/bloc/chart_container/barrel.dart';
import 'package:quantifico/bloc/chart_screen/barrel.dart';
import 'package:quantifico/bloc/home_screen/barrel.dart';

class AppBlocsProvider extends StatelessWidget {
  final ChartRepository chartRepository;
  final ChartContainerRepository chartContainerRepository;
  final NfRepository nfRepository;
  final Widget child;

  const AppBlocsProvider({
    @required this.chartRepository,
    @required this.chartContainerRepository,
    @required this.nfRepository,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<TabBloc>(
          create: (context) => TabBloc(),
        ),
        BlocProvider<AnnualSalesBloc>(
          create: (context) => AnnualSalesBloc(
            authBloc: authBloc,
            chartRepository: chartRepository,
          ),
        ),
        BlocProvider<CustomerSalesBloc>(
          create: (context) => CustomerSalesBloc(
            authBloc: authBloc,
            chartRepository: chartRepository,
          ),
        ),
        BlocProvider<CitySalesBloc>(
          create: (context) => CitySalesBloc(
            authBloc: authBloc,
            chartRepository: chartRepository,
          ),
        ),
        BlocProvider<MonthlySalesBloc>(
          create: (context) => MonthlySalesBloc(
            authBloc: authBloc,
            chartRepository: chartRepository,
          ),
        ),
        BlocProvider<ProductSalesBloc>(
          create: (context) => ProductSalesBloc(
            authBloc: authBloc,
            chartRepository: chartRepository,
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<HomeScreenBloc>(
                create: (context) => HomeScreenBloc(
                  authBloc: authBloc,
                  chartContainerRepository: chartContainerRepository,
                  nfRepository: nfRepository,
                  chartBlocs: {
                    'AnnualSalesChart': BlocProvider.of<AnnualSalesBloc>(context),
                    'CustomerSalesChart': BlocProvider.of<CustomerSalesBloc>(context),
                    'CitySalesChart': BlocProvider.of<CitySalesBloc>(context),
                    'MonthlySalesChart': BlocProvider.of<MonthlySalesBloc>(context),
                    'ProductSalesChart': BlocProvider.of<ProductSalesBloc>(context),
                  },
                )..add(const LoadHomeScreen()),
              ),
              BlocProvider<ChartScreenBloc>(
                create: (context) => ChartScreenBloc(
                  chartBlocs: [
                    BlocProvider.of<AnnualSalesBloc>(context),
                    BlocProvider.of<CustomerSalesBloc>(context),
                    BlocProvider.of<CitySalesBloc>(context),
                    BlocProvider.of<MonthlySalesBloc>(context),
                    BlocProvider.of<ProductSalesBloc>(context),
                  ],
                )..add(const LoadChartScreen()),
              ),
              BlocProvider<NfScreenBloc>(
                create: (context) => NfScreenBloc(
                  authBloc: authBloc,
                  nfRepository: nfRepository,
                )..add(const LoadNfScreen()),
              ),
              BlocProvider<ChartContainerBloc<AnnualSalesChart>>(
                create: (context) => ChartContainerBloc<AnnualSalesChart>(
                    chartBloc: BlocProvider.of<AnnualSalesBloc>(context),
                    chartContainerRepository: chartContainerRepository)
                  ..add(const LoadContainer()),
              ),
              BlocProvider<ChartContainerBloc<CustomerSalesChart>>(
                create: (context) => ChartContainerBloc<CustomerSalesChart>(
                    chartBloc: BlocProvider.of<CustomerSalesBloc>(context),
                    chartContainerRepository: chartContainerRepository)
                  ..add(const LoadContainer()),
              ),
              BlocProvider<ChartContainerBloc<ProductSalesChart>>(
                create: (context) => ChartContainerBloc<ProductSalesChart>(
                    chartBloc: BlocProvider.of<ProductSalesBloc>(context),
                    chartContainerRepository: chartContainerRepository)
                  ..add(const LoadContainer()),
              ),
              BlocProvider<ChartContainerBloc<CitySalesChart>>(
                create: (context) => ChartContainerBloc<CitySalesChart>(
                    chartBloc: BlocProvider.of<CitySalesBloc>(context),
                    chartContainerRepository: chartContainerRepository)
                  ..add(const LoadContainer()),
              ),
              BlocProvider<ChartContainerBloc<MonthlySalesChart>>(
                create: (context) => ChartContainerBloc<MonthlySalesChart>(
                    chartBloc: BlocProvider.of<MonthlySalesBloc>(context),
                    chartContainerRepository: chartContainerRepository)
                  ..add(const LoadContainer()),
              )
            ],
            child: child,
          );
        },
      ),
    );
  }
}
