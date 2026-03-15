import 'package:admin_panel/features/cost/domain/entity/delete_expense_entity.dart';

abstract class DeleteHarajatState {
  const DeleteHarajatState();
}

class DeleteHarajatInitial extends DeleteHarajatState {}

class DeleteHarajatLoading extends DeleteHarajatState {}

class DeleteHarajatSuccess extends DeleteHarajatState {
  final DeleteExpenseEntity deleteExpenseEntity;

  const DeleteHarajatSuccess({required this.deleteExpenseEntity});
}

class DeleteHarajatError extends DeleteHarajatState {
  final String message;

  const DeleteHarajatError({required this.message});
}
