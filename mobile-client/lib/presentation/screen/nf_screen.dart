import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/nf_screen/barrel.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/nf/nf_screen_filter.dart';
import 'package:quantifico/data/model/nf/nf_screen_record.dart';
import 'package:quantifico/presentation/screen/nf_details_screen.dart';
import 'package:quantifico/presentation/shared/error_indicator.dart';
import 'package:quantifico/presentation/shared/filter_dialog.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';
import 'package:quantifico/presentation/shared/text_date_picker.dart';
import 'package:quantifico/style.dart';
import 'package:quantifico/util/date_util.dart';
import 'package:quantifico/util/number_util.dart';

class NfScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder<NfScreenBloc, NfScreenState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppStyle.backgroundColor,
          body: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: _buildBody(context, state),
          ),
          floatingActionButton: _buildFab(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, NfScreenState state) {
    if (state is NfScreenLoaded) {
      return RefreshIndicator(
        onRefresh: () async {
          final bloc = BlocProvider.of<NfScreenBloc>(context);
          bloc.add(const LoadNfScreen());
        },
        child: _buildLoadedScreen(context, state),
      );
    } else if (state is NfScreenLoading) {
      return const LoadingIndicator();
    } else {
      return ErrorIndicator(
        text: 'Não foi possível carregar suas Notas Fiscais',
        onRetry: () {
          final bloc = BlocProvider.of<NfScreenBloc>(context);
          bloc.add(const LoadNfScreen());
        },
      );
    }
  }

  Widget _buildLoadedScreen(BuildContext context, NfScreenLoaded state) {
    if (state.nfScreenRecords.isNotEmpty) {
      return _buildNfs(context, state);
    } else {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: SizeConfig.screenHeight - 85.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sem dados para exibir'),
              const SizedBox(width: 5),
              Icon(Icons.sentiment_neutral),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildNfs(BuildContext context, NfScreenLoaded state) {
    final scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          final bloc = BlocProvider.of<NfScreenBloc>(context);
          bloc.add(const LoadMoreNfScreen());
        }
      }
    });

    return ListView.separated(
      controller: scrollController,
      separatorBuilder: (context, index) => const SizedBox(height: 5),
      itemCount: state.nfScreenRecords.length + 1,
      itemBuilder: (context, index) {
        if (index == state.nfScreenRecords.length) {
          if (state is NfScreenLoadingMore) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: LoadingIndicator(),
            );
          } else {
            return null;
          }
        } else {
          final nfScreenRecord = state.nfScreenRecords[index];
          return GestureDetector(
            onTap: () {
              Navigator.push<Widget>(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return NfDetailsScreen(
                      nf: nfScreenRecord.nf,
                      headerBackgroundColor: nfScreenRecord.color,
                    );
                  },
                ),
              );
            },
            child: _buildNfTile(nfScreenRecord),
          );
        }
      },
    );
  }

  Widget _buildNfTile(NfScreenRecord nfScreenRecord) {
    return Container(
      color: Colors.white,
      height: 100,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: nfScreenRecord.color,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                ),
              ],
            ),
            width: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  nfScreenRecord.nf.number.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatDate(nfScreenRecord.nf.date)),
                      Text(formatCurrency(nfScreenRecord.nf.totalAmount)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          nfScreenRecord.nf.customer.name,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFab(BuildContext context, NfScreenState state) {
    if (state is NfScreenLoaded) {
      return FloatingActionButton(
        child: Icon(Icons.filter_list),
        onPressed: () {
          showDialog<Widget>(
            context: context,
            builder: (BuildContext _) => _buildFilterDialog(
              context,
              state,
            ),
          );
        },
      );
    } else {
      return null;
    }
  }

  Widget _buildFilterDialog(
    BuildContext context,
    NfScreenLoaded state,
  ) {
    return NfScreenFilterDialog(
      onApply: (initialDate, endDate, customerName) {
        final bloc = BlocProvider.of<NfScreenBloc>(context);
        final filter = NfScreenFilter(
          initialDate: initialDate,
          endDate: endDate,
          customerName: customerName,
        );
        bloc.add(UpdateFilterNfScreen(filter));
      },
      initialDate: state.activeFilter?.initialDate,
      endDate: state.activeFilter?.endDate,
      customerName: state.activeFilter?.customerName,
    );
  }
}

class NfScreenFilterDialog extends StatefulWidget {
  final void Function(DateTime initialDate, DateTime endDate, String customerName) onApply;
  final DateTime initialDate;
  final DateTime endDate;
  final String customerName;

  const NfScreenFilterDialog({
    @required this.onApply,
    this.initialDate,
    this.endDate,
    this.customerName,
  });

  @override
  _NfScreenFilterDialogState createState() => _NfScreenFilterDialogState();
}

class _NfScreenFilterDialogState extends State<NfScreenFilterDialog> {
  DateTime _initialDate;
  DateTime _endDate;
  TextEditingController customerNameController;

  @override
  void initState() {
    super.initState();
    _initialDate = widget.initialDate;
    _endDate = widget.endDate;
    customerNameController = TextEditingController(text: widget.customerName);
  }

  @override
  Widget build(BuildContext context) {
    const verticalSpacing = SizedBox(height: 20);
    return FilterDialog(
      onApply: () => widget.onApply(
        _initialDate,
        _endDate,
        customerNameController.text,
      ),
      onClear: () {
        setState(() {
          _initialDate = null;
          _endDate = null;
          customerNameController.clear();
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            TextDatePicker(
              onChanged: (value) {
                _initialDate = value;
              },
              labelText: 'Data inicial',
              initialValue: _initialDate,
            ),
            verticalSpacing,
            TextDatePicker(
              onChanged: (value) {
                _endDate = value;
              },
              labelText: 'Data final',
              initialValue: _endDate,
            ),
            verticalSpacing,
            TextField(
              controller: customerNameController,
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Cliente',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
