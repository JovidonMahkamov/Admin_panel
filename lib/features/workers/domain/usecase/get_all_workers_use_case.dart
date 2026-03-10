import 'package:admin_panel/features/workers/domain/entity/get_all_workers_entity.dart';
import 'package:admin_panel/features/workers/domain/repository/worker_repositories.dart';

class GetAllWorkersUseCase {
  final WorkerRepositories repo;
  GetAllWorkersUseCase(this.repo);

  Future<GetAllWorkersEntity> call() => repo.getAllWorker();
}
