
import 'package:admin_panel/features/dashboard/domain/entity/worker_detail_entity.dart';

abstract class WorkerDetailState {
  const WorkerDetailState();
}

class WorkerDetailInitial extends WorkerDetailState {}

class WorkerDetailLoading extends WorkerDetailState {}

class WorkerDetailSuccess extends WorkerDetailState {
  final WorkerDetailEntity workerDetailEntity;

  const WorkerDetailSuccess({required this.workerDetailEntity});
}

class WorkerDetailError extends WorkerDetailState {
  final String message;

  const WorkerDetailError({required this.message});
}
