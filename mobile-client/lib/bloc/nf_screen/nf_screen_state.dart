import 'package:equatable/equatable.dart';
import 'package:quantifico/data/model/nf/nf_screen_filter.dart';
import 'package:quantifico/data/model/nf/nf_screen_record.dart';

abstract class NfScreenState extends Equatable {
  const NfScreenState();

  @override
  List<Object> get props => [];
}

class NfScreenLoading extends NfScreenState {
  const NfScreenLoading();
}

class NfScreenLoaded extends NfScreenState {
  final List<NfScreenRecord> nfScreenRecords;
  final NfScreenFilter activeFilter;

  const NfScreenLoaded({
    this.nfScreenRecords,
    this.activeFilter,
  });

  @override
  List<Object> get props => [nfScreenRecords, activeFilter];
}

class NfScreenLoadingMore extends NfScreenLoaded {
  const NfScreenLoadingMore({
    List<NfScreenRecord> nfScreenRecords,
    NfScreenFilter activeFilter,
  }) : super(
          nfScreenRecords: nfScreenRecords,
          activeFilter: activeFilter,
        );
}

class NfScreenNotLoaded extends NfScreenState {
  const NfScreenNotLoaded();
}
