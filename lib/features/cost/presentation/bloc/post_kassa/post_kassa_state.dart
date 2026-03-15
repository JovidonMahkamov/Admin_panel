import 'package:admin_panel/features/cost/domain/entity/expense_entity.dart';

import '../../../domain/entity/create_cash_expense_entity.dart';

abstract class PostKassaState  {
  const PostKassaState();

  @override
  List<Object?> get props => [];
}

class PostKassaInitial extends PostKassaState {}

class PostKassaLoading extends PostKassaState {}

class PostKassaSuccess extends PostKassaState {
  final CreateCashExpenseEntity expense;

  const PostKassaSuccess({required this.expense});

  @override
  List<Object?> get props => [expense];
}

class PostKassaError extends PostKassaState {
  final String message;

  const PostKassaError({required this.message});

  @override
  List<Object?> get props => [message];
}