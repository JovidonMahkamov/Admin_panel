import 'package:admin_panel/features/cost/domain/entity/update_expense_entity.dart';

abstract class UpdateHarajatState {
  const UpdateHarajatState();
}

class UpdateHarajatInitial extends UpdateHarajatState {}

class UpdateHarajatLoading extends UpdateHarajatState {}

class UpdateHarajatSuccess extends UpdateHarajatState {
  final UpdateExpenseEntity updateExpenseEntity;

  const UpdateHarajatSuccess({required this.updateExpenseEntity});
}

class UpdateHarajatError extends UpdateHarajatState {
  final String message;

  const UpdateHarajatError({required this.message});
}
