import 'package:admin_panel/features/history/data/datasource/history_data_source.dart';
import 'package:admin_panel/features/history/domain/entity/history_entity.dart';
import 'package:admin_panel/features/history/domain/repository/history_repo.dart';

class HistoryRepoImpl implements HistoryRepo {
  final HistoryDataSource remote;

  HistoryRepoImpl({required this.remote});

  @override
  Future<HistoryEntity> getHistory() => remote.getHistory();


}
