import 'package:admin_panel/features/workers/domain/repository/worker_repositories.dart';
import '../entity/update_worker_request_entity.dart';
import '../entity/update_worker_response_entity.dart';

class UpdateWorkerUseCase {
  final WorkerRepositories repo;
  UpdateWorkerUseCase(this.repo);

  Future<UpdateWorkerResponseEntity> call(UpdateWorkerRequestEntity entity,
      ) async{
    return await repo.updateWorker(entity);
  }
}
