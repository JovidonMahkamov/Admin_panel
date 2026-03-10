import 'package:admin_panel/features/workers/domain/entity/update_worker_response_entity.dart';

abstract class UpdateWorkerState {
  const UpdateWorkerState();
}

class UpdateWorkerInitial extends UpdateWorkerState {}

class UpdateWorkerLoading extends UpdateWorkerState {}

class UpdateWorkerSuccess extends UpdateWorkerState {
  final UpdateWorkerResponseEntity updateWorkerResponseEntity;

  const UpdateWorkerSuccess({required this.updateWorkerResponseEntity});
}

class UpdateWorkerError extends UpdateWorkerState {
  final String message;

  const UpdateWorkerError({required this.message});
}
