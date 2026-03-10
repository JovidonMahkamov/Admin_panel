import 'package:admin_panel/features/workers/domain/entity/create_worker_response_entity.dart';
import 'package:admin_panel/features/workers/domain/entity/delete_worker_entity.dart';
import 'package:admin_panel/features/workers/domain/entity/get_all_workers_entity.dart';
import '../entity/update_worker_request_entity.dart';
import '../entity/update_worker_response_entity.dart';

abstract class WorkerRepositories{
  Future<GetAllWorkersEntity> getAllWorker();
  Future<CreateWorkerResponseEntity> createWorker({required String fish, required String login, required String parol, required String telefon});
  Future<DeleteWorkerResponseEntity> deleteWorker({required int id});
  Future<UpdateWorkerResponseEntity > updateWorker(UpdateWorkerRequestEntity entity,
      );
}