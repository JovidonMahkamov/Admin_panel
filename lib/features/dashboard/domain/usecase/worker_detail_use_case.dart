import 'package:admin_panel/features/dashboard/domain/entity/worker_detail_entity.dart';
import 'package:admin_panel/features/dashboard/domain/repository/dashboard_repositories.dart';

class WorkerDetailUseCase {
  final DashboardRepositories repo;
  WorkerDetailUseCase(this.repo);

  Future<WorkerDetailEntity> call({required String sana, required int id}) => repo.workerDetail(sana: sana, id: id);
}
