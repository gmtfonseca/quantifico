import 'package:meta/meta.dart';
import 'package:quantifico/data/model/nf/nf.dart';
import 'package:quantifico/data/model/nf/nf_screen_filter.dart';
import 'package:quantifico/data/model/nf/nf_stats.dart';
import 'package:quantifico/data/provider/nf_web_provider.dart';

class NfRepository {
  final NfWebProvider nfWebProvider;

  NfRepository({@required this.nfWebProvider});

  Future<List<Nf>> getNfs({
    NfScreenFilter filter,
    int page,
  }) async {
    return await nfWebProvider.fetchNfs(
      initialDate: filter?.initialDate,
      endDate: filter?.endDate,
      customerName: filter?.customerName,
      page: page,
    );
  }

  Future<NfStats> getStats({
    int month,
    int year,
  }) async {
    return await nfWebProvider.fetchStats(
      month: month,
      year: year,
    );
  }
}
