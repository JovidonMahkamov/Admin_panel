import 'package:admin_panel/features/workers/domain/entity/delete_worker_entity.dart';

abstract class DeleteWorkerState {
  const DeleteWorkerState();
}

class DeleteWorkerInitial extends DeleteWorkerState {}

class DeleteWorkerLoading extends DeleteWorkerState {}

class DeleteWorkerSuccess extends DeleteWorkerState {
  final DeleteWorkerResponseEntity deleteWorkerResponseEntity;

  const DeleteWorkerSuccess({required this.deleteWorkerResponseEntity});
}

class DeleteWorkerError extends DeleteWorkerState {
  final String message;

  const DeleteWorkerError({required this.message});
}
