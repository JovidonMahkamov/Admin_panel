import 'package:admin_panel/features/cost/domain/entity/expense_entity.dart';

abstract class PostHarajatState  {
  const PostHarajatState();

  @override
  List<Object?> get props => [];
}

class PostHarajatInitial extends PostHarajatState {}

class PostHarajatLoading extends PostHarajatState {}

class PostHarajatSuccess extends PostHarajatState {
  final ExpenseEntity expense;

  const PostHarajatSuccess({required this.expense});

  @override
  List<Object?> get props => [expense];
}

class PostHarajatError extends PostHarajatState {
  final String message;

  const PostHarajatError({required this.message});

  @override
  List<Object?> get props => [message];
}