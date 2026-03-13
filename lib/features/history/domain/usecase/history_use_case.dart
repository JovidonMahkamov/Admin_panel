import 'package:admin_panel/features/history/domain/entity/history_entity.dart';
import 'package:admin_panel/features/history/domain/repository/history_repo.dart';

class HistoryUseCase {
  final HistoryRepo repo;
  HistoryUseCase(this.repo);

  Future<HistoryEntity> call() => repo.getHistory();
}
