import 'package:admin_panel/features/history/domain/entity/history_entity.dart';

abstract class HistoryRepo {
  Future<HistoryEntity> getHistory();

}