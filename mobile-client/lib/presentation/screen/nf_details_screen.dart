import 'package:flutter/material.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/nf/nf.dart';
import 'package:quantifico/data/model/nf/nf_item.dart';
import 'package:quantifico/style.dart';
import 'package:quantifico/util/date_util.dart';
import 'package:quantifico/util/number_util.dart';
import 'package:quantifico/util/string_util.dart';

class NfDetailsScreen extends StatefulWidget {
  final Nf nf;
  final Color headerBackgroundColor;

  const NfDetailsScreen({
    this.nf,
    this.headerBackgroundColor,
  });

  @override
  _NfDetailsScreenState createState() => _NfDetailsScreenState();
}

class _NfDetailsScreenState extends State<NfDetailsScreen> with SingleTickerProviderStateMixin {
  final List<Tab> tabs = const [
    Tab(text: 'Itens'),
    Tab(text: 'Detalhes'),
  ];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: tabs.length,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.headerBackgroundColor ?? Theme.of(context).primaryColor,
        bottom: NfDetailsScreenHeader(
          backgroundColor: widget.headerBackgroundColor ?? Theme.of(context).primaryColor,
          nf: widget.nf,
          tabs: TabBar(
            indicatorColor: Colors.white,
            controller: _tabController,
            tabs: tabs,
          ),
        ),
      ),
      body: Container(
        color: AppStyle.backgroundColor,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildItemsTab(),
            _buildDetailsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsTab() {
    final items = widget.nf.items;
    if (items.isNotEmpty) {
      return _buildItems(items);
    } else {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sem dados para exibir'),
            const SizedBox(width: 5),
            Icon(Icons.sentiment_neutral),
          ],
        ),
      );
    }
  }

  Widget _buildItems(List<NfItem> items) {
    final colors = [
      Colors.red,
      Colors.indigo,
      Colors.green,
      Colors.blue,
      Colors.amber,
      Colors.deepPurple,
    ];

    var colorIdx = 0;
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 5),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final tile = Container(
          color: Colors.white,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 5,
                  color: colors[colorIdx],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildItemTile(item),
                  ),
                ),
              ],
            ),
          ),
        );

        colorIdx += 1;
        if (colorIdx >= colors.length) {
          colorIdx = 0;
        }

        return tile;
      },
    );
  }

  Widget _buildItemTile(NfItem item) {
    const textStyle = TextStyle(fontSize: 13.0);
    const verticalSpacing = SizedBox(height: 10);
    const verticalDivider = SizedBox(
      height: 15,
      child: VerticalDivider(thickness: 2),
    );

    return Row(
      children: [
        Text(
          item.product.code,
          style: textStyle,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                toLimitedLength(
                  item.product.description,
                  (SizeConfig.blockSizeHorizontal * 9).toInt(),
                ),
                style: textStyle,
              ),
              verticalSpacing,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    formatNumber(item.quantity),
                    style: textStyle,
                  ),
                  verticalDivider,
                  Text(
                    formatCurrency(item.unitPrice),
                    style: textStyle,
                  ),
                  verticalDivider,
                  Text(
                    formatCurrency(item.totalAmount),
                    style: textStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsTab() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [],
        ),
      ),
    );
  }
}

class NfDetailsScreenHeader extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget tabs;
  final Nf nf;
  final Color backgroundColor;

  const NfDetailsScreenHeader({
    @required this.tabs,
    @required this.nf,
    @required this.backgroundColor,
  });

  @override
  Size get preferredSize {
    return const Size.fromHeight(100.0);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          _buildNfInfo(),
          tabs,
        ],
      ),
    );
  }

  Widget _buildNfInfo() {
    const primaryInfoTextStyle = TextStyle(
      fontSize: 20,
      color: Colors.white,
    );

    const secondaryInfoTextStyle = TextStyle(
      fontSize: 13,
      color: Colors.white,
    );

    const verticalSpacing = SizedBox(height: 10);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nf.number.toString(),
            style: primaryInfoTextStyle,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    formatDate(nf.date),
                    style: secondaryInfoTextStyle,
                  ),
                  const SizedBox(
                    height: 10,
                    child: VerticalDivider(
                      thickness: 1,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    formatCurrency(nf.totalAmount),
                    style: secondaryInfoTextStyle,
                  ),
                ],
              ),
              verticalSpacing,
              Text(
                toLimitedLength(
                  nf.customer.name,
                  (SizeConfig.blockSizeHorizontal * 9).toInt(),
                ),
                style: secondaryInfoTextStyle,
              ),
            ],
          )
        ],
      ),
    );
  }
}
