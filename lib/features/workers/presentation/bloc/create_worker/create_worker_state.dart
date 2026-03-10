import '../../../domain/entity/create_worker_response_entity.dart';

abstract class CreateWorkerState {
  const CreateWorkerState();
}

class CreateWorkerInitial extends CreateWorkerState {}

class CreateWorkerLoading extends CreateWorkerState {}

class CreateWorkerSuccess extends CreateWorkerState {
  final CreateWorkerResponseEntity createWorkerResponseEntity;

  const CreateWorkerSuccess({required this.createWorkerResponseEntity});
}

class CreateWorkerError extends CreateWorkerState {
  final String message;

  const CreateWorkerError({required this.message});
}
