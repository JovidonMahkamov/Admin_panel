import 'package:admin_panel/features/monthly_selling/domain/entity/finish_monthly_sales_entity.dart';

abstract class FinishMonthlySellingState {
  const FinishMonthlySellingState();
}

class FinishMonthlySellingInitial extends FinishMonthlySellingState {}

class FinishMonthlySellingLoading extends FinishMonthlySellingState {}

class FinishMonthlySellingSuccess extends FinishMonthlySellingState {
  final FinishMonthlySalesEntity finishMonthlySalesEntity;

  const FinishMonthlySellingSuccess({required this.finishMonthlySalesEntity});
}

class FinishMonthlySellingError extends FinishMonthlySellingState {
  final String message;

  const FinishMonthlySellingError({required this.message});
}
