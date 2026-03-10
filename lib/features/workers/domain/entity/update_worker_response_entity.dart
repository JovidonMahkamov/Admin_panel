import 'get_worker_entity.dart';

class UpdateWorkerResponseEntity {
  final String message;
  final GetWorkerEntity data;
  final int status;

  const UpdateWorkerResponseEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}