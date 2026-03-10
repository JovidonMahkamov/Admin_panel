import 'get_worker_entity.dart';

class CreateWorkerResponseEntity {
  final String message;
  final GetWorkerEntity data;
  final int status;

  const CreateWorkerResponseEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}