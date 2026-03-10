import 'package:admin_panel/features/workers/data/model/delete_worker_model.dart';
import 'package:admin_panel/features/workers/data/model/get_all_workers_model.dart';
import '../model/create_worker_response_model.dart';
import '../model/update_worker_response_model.dart';

abstract class WorkerDataSource{
  Future<GetAllWorkersModel> getAllWorker();
  Future<CreateWorkerResponseModel> createWorker({required String fish, required String login, required String parol, required String telefon});
  Future<DeleteWorkerResponseModel> deleteWorker({required int id});
  Future<UpdateWorkerResponseModel> updateWorker({required int id, required String fish, required String parol, required String login, required String telefon});

}