import 'package:admin_panel/features/workers/domain/repository/worker_repositories.dart';
import '../entity/create_worker_response_entity.dart';

class CreateWorkerUseCase {
  final WorkerRepositories repo;
  CreateWorkerUseCase(this.repo);

  Future<CreateWorkerResponseEntity> call({required String fish, required String login, required String parol, required String telefon}) async{
    return await repo.createWorker(fish: fish, login: login, parol: parol, telefon: telefon);
  }
}
