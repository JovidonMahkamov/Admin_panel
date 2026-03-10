import 'package:admin_panel/features/workers/data/datasource/worker_data_source.dart';
import 'package:admin_panel/features/workers/domain/entity/create_worker_response_entity.dart';
import 'package:admin_panel/features/workers/domain/entity/delete_worker_entity.dart';
import 'package:admin_panel/features/workers/domain/entity/get_all_workers_entity.dart';
import 'package:admin_panel/features/workers/domain/entity/update_worker_request_entity.dart';
import 'package:admin_panel/features/workers/domain/entity/update_worker_response_entity.dart';
import 'package:admin_panel/features/workers/domain/repository/worker_repositories.dart';

class WorkerRepositoryImpl implements WorkerRepositories {
  final WorkerDataSource remote;

  WorkerRepositoryImpl({
    required this.remote,
  });

  @override
  Future<GetAllWorkersEntity> getAllWorker() => remote.getAllWorker();

  @override
  Future<CreateWorkerResponseEntity> createWorker({required String fish, required String login, required String parol, required String telefon}) {
    return remote.createWorker(fish: fish, login: login, parol: parol, telefon: telefon);
  }

  @override
  Future<DeleteWorkerResponseEntity> deleteWorker({required int id}) {
    return remote.deleteWorker(id: id);
  }

  @override
  Future<UpdateWorkerResponseEntity> updateWorker(UpdateWorkerRequestEntity entity) {
    return remote.updateWorker(id: entity.id, fish: entity.fish, parol: entity.parol, login: entity.login, telefon: entity.telefon);
  }

}