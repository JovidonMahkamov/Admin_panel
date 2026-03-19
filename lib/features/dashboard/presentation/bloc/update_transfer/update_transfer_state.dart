
import 'package:admin_panel/features/dashboard/domain/entity/transfer_response_entity.dart';

abstract class UpdateTransferState {
  const UpdateTransferState();
}

class UpdateTransferInitial extends UpdateTransferState {}

class UpdateTransferLoading extends UpdateTransferState {}

class UpdateTransferSuccess extends UpdateTransferState {
  final TransferResponseEntity transferResponseEntity;

  const UpdateTransferSuccess({required this.transferResponseEntity});
}

class UpdateTransferError extends UpdateTransferState {
  final String message;

  const UpdateTransferError({required this.message});
}
