import 'package:admin_panel/features/cost/domain/entity/get_cash_expense_entity.dart';

abstract class GetKassaState {
  const GetKassaState();
}

class GetKassaInitial extends GetKassaState {}

class GetKassaLoading extends GetKassaState {}

class GetKassaSuccess extends GetKassaState {
  final GetCashExpenseEntity getCashExpenseEntity;

  const GetKassaSuccess({required this.getCashExpenseEntity});
}

class GetKassaError extends GetKassaState {
  final String message;

  const GetKassaError({required this.message});
}
