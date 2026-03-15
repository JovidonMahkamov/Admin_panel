import 'package:admin_panel/features/cost/domain/entity/update_cash_expense_entity.dart';

abstract class UpdateKassaState {
  const UpdateKassaState();
}

class UpdateKassaInitial extends UpdateKassaState {}

class UpdateKassaLoading extends UpdateKassaState {}

class UpdateKassaSuccess extends UpdateKassaState {
  final UpdateCashExpenseEntity updateCashExpenseEntity;

  const UpdateKassaSuccess({required this.updateCashExpenseEntity});
}

class UpdateKassaError extends UpdateKassaState {
  final String message;

  const UpdateKassaError({required this.message});
}
