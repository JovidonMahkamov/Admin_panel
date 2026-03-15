import '../../../domain/entity/delete_cash_expense_entity.dart';

abstract class DeleteKassaState {
  const DeleteKassaState();
}

class DeleteKassaInitial extends DeleteKassaState {}

class DeleteKassaLoading extends DeleteKassaState {}

class DeleteKassaSuccess extends DeleteKassaState {
  final DeleteCashExpenseEntity deleteCashExpenseEntity;

  const DeleteKassaSuccess({required this.deleteCashExpenseEntity});
}

class DeleteKassaError extends DeleteKassaState {
  final String message;

  const DeleteKassaError({required this.message});
}
