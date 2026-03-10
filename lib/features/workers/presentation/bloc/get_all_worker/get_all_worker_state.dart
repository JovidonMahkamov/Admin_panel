import 'package:admin_panel/features/workers/domain/entity/get_all_workers_entity.dart';

abstract class GetAllWorkerState {
  const GetAllWorkerState();
}

class GetAllWorkerInitial extends GetAllWorkerState {}

class GetAllWorkerLoading extends GetAllWorkerState {}

class GetAllWorkerSuccess extends GetAllWorkerState {
  final GetAllWorkersEntity getAllWorkersEntity;

  const GetAllWorkerSuccess({required this.getAllWorkersEntity});
}

class GetAllWorkerError extends GetAllWorkerState {
  final String message;

  const GetAllWorkerError({required this.message});
}
