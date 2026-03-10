import 'package:admin_panel/features/workers/domain/entity/get_worker_entity.dart';

class GetAllWorkersEntity {
  final String message;
  final List<GetWorkerEntity> data;
  final int status;

  const GetAllWorkersEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}