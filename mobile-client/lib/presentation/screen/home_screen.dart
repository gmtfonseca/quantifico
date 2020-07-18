import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/auth/barrel.dart';
import 'package:quantifico/bloc/chart/special/barrel.dart';
import 'package:quantifico/bloc/chart/special/product_sales_bloc.dart';
import 'package:quantifico/bloc/chart_container/barrel.dart';
import 'package:quantifico/bloc/home_screen/barrel.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/presentation/chart/barrel.dart';
import 'package:quantifico/presentation/chart/product_sales_chart.dart';
import 'package:quantifico/presentation/chart/shared/chart_container.dart';
import 'package:quantifico/presentation/shared/error_indicator.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';
import 'package:quantifico/style.dart';
import 'package:quantifico/util/number_util.dart';
import 'package:quantifico/util/date_util.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
          builder: (
            BuildContext context,
            HomeScreenState state,
          ) {
            if (state is HomeScreenLoaded) {
              return _buildLoadedScreen(context, state);
            } else if (state is HomeScreenLoading) {
              return const LoadingIndicator();
            } else {
              return ErrorIndicator(
                text: 'Não foi possível carregar seu home',
                onRetry: () {
                  final bloc = BlocProvider.of<HomeScreenBloc>(context);
                  bloc.add(const LoadHomeScreen());
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadedScreen(BuildContext context, HomeScreenLoaded state) {
    const verticalSpacing = SizedBox(height: 15);
    const contextVerticalSpacing = SizedBox(height: 25);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: RefreshIndicator(
        onRefresh: () async {
          final bloc = BlocProvider.of<HomeScreenBloc>(context);
          bloc.add(const RefreshHomeScreen());
        },
        child: ListView(
          children: [
            verticalSpacing,
            _buildUserTile(context, state),
            verticalSpacing,
            const Divider(),
            verticalSpacing,
            _buildContextTitle('Resumo do mês'),
            verticalSpacing,
            _buildInsights(state),
            contextVerticalSpacing,
            _buildContextTitle('Gráficos em destaque'),
            verticalSpacing,
            _buildCharts(context, state),
            verticalSpacing,
          ],
        ),
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, HomeScreenLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildUserIntroduction(context, state),
          GestureDetector(
            onTap: () {
              showDialog<Widget>(
                context: context,
                builder: (BuildContext _) => _buildSignOutDialog(context),
              );
            },
            child: CircleAvatar(
              radius: 30.0,
              backgroundImage: const AssetImage('assets/profile.jpeg'),
              backgroundColor: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSignOutDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Sair'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const [
            Text('Realmente deseja sair?'),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('NÃO'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: const Text('SIM'),
          onPressed: () {
            final authBloc = BlocProvider.of<AuthBloc>(context);
            authBloc.add(DeAuthenticate());
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildUserIntroduction(BuildContext context, HomeScreenLoaded state) {
    final userName = state.user?.name;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          formatDate(state.currDate),
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Olá, $userName',
          style: TextStyle(
            fontSize: SizeConfig.textScaler * 5.5,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildContextTitle(String title) {
    const titleStyle = TextStyle(
      fontSize: 18,
      color: Colors.black54,
    );

    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: titleStyle,
      ),
    );
  }

  Widget _buildInsights(HomeScreenLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
            child: _buildInsightCard(
              'Total Faturado',
              formatCurrency(state.stats.totalSales),
              Colors.redAccent,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _buildInsightCard(
              'N° Notas Fiscais',
              state.stats.nfCount.toString(),
              Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String label, String value, Color backgroundColor) {
    return SizedBox(
      height: 120,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(11),
        clipBehavior: Clip.hardEdge,
        elevation: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharts(BuildContext context, HomeScreenLoaded state) {
    if (state.starredCharts.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: state.starredCharts.length,
        itemBuilder: (context, index) {
          final chartName = state.starredCharts[index];
          return _buildChartFromName(context, chartName);
        },
      );
    } else {
      return Container(
        height: SizeConfig.screenHeight - 350.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Nenhum gráfico em destaque',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.sentiment_neutral,
              color: Colors.black54,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildChartFromName(BuildContext context, String chartName) {
    final bloc = BlocProvider.of<HomeScreenBloc>(context);
    final onStarOrUnstar = () => bloc.add(const UpdateStarredCharts());

    switch (chartName) {
      case 'AnnualSalesChart':
        final annualSalesContainerBloc = BlocProvider.of<ChartContainerBloc<AnnualSalesChart>>(context);
        final annualSalesBloc = BlocProvider.of<AnnualSalesBloc>(context);
        return ChartContainer(
          title: 'Faturamento Anual',
          bloc: annualSalesContainerBloc,
          chart: AnnualSalesChart(
            bloc: annualSalesBloc,
          ),
          onStarOrUnstar: onStarOrUnstar,
        );
      case 'CitySalesChart':
        final citySalesContainerBloc = BlocProvider.of<ChartContainerBloc<CitySalesChart>>(context);
        final citySalesBloc = BlocProvider.of<CitySalesBloc>(context);
        return ChartContainer(
          title: 'Faturamento por Cidade',
          bloc: citySalesContainerBloc,
          chart: CitySalesChart(
            bloc: citySalesBloc,
          ),
          onStarOrUnstar: onStarOrUnstar,
        );
      case 'MonthlySalesChart':
        final monthlySalesContainerBloc = BlocProvider.of<ChartContainerBloc<MonthlySalesChart>>(context);
        final monthlySalesBloc = BlocProvider.of<MonthlySalesBloc>(context);
        return ChartContainer(
          title: 'Faturamento Mensal',
          bloc: monthlySalesContainerBloc,
          chart: MonthlySalesChart(
            bloc: monthlySalesBloc,
          ),
          onStarOrUnstar: onStarOrUnstar,
        );
      case 'CustomerSalesChart':
        final customerSalesContainerBloc = BlocProvider.of<ChartContainerBloc<CustomerSalesChart>>(context);
        final customerSalesBloc = BlocProvider.of<CustomerSalesBloc>(context);
        return ChartContainer(
          title: 'Faturamento por Cliente',
          bloc: customerSalesContainerBloc,
          chart: CustomerSalesChart(
            bloc: customerSalesBloc,
          ),
          onStarOrUnstar: onStarOrUnstar,
        );
      case 'ProductSalesChart':
        final productSalesContainerBloc = BlocProvider.of<ChartContainerBloc<ProductSalesChart>>(context);
        final productSalesBloc = BlocProvider.of<ProductSalesBloc>(context);
        return ChartContainer(
          title: 'Faturamento por Produto',
          bloc: productSalesContainerBloc,
          chart: ProductSalesChart(
            bloc: productSalesBloc,
          ),
          onStarOrUnstar: onStarOrUnstar,
        );
      default:
        return const SizedBox();
    }
  }
}
