import '../../../domain/entity/monthly_sales_entity.dart';

abstract class GetMonthlySellingState {
  const GetMonthlySellingState();
}

class GetMonthlySellingInitial extends GetMonthlySellingState {}

class GetMonthlySellingLoading extends GetMonthlySellingState {}

class GetMonthlySellingSuccess extends GetMonthlySellingState {
  final MonthlySalesEntity monthlySalesEntity;

  const GetMonthlySellingSuccess({required this.monthlySalesEntity});
}

class GetMonthlySellingError extends GetMonthlySellingState {
  final String message;

  const GetMonthlySellingError({required this.message});
}
