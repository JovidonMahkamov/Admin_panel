import 'package:admin_panel/features/workers/domain/entity/delete_worker_entity.dart';
import 'package:admin_panel/features/workers/domain/repository/worker_repositories.dart';

class DeleteWorkerUseCase {
  final WorkerRepositories repo;
  DeleteWorkerUseCase(this.repo);

  Future<DeleteWorkerResponseEntity> call({required int id}) async{
    return await repo.deleteWorker(id: id);
  }
}
