import 'package:admin_panel/features/customer/domain/entity/get_all_customers_entity.dart';
import 'package:admin_panel/features/dashboard/domain/entity/dashboard_entity.dart';
import 'package:admin_panel/features/dashboard/domain/entity/finish_sales_entity.dart';

abstract class FinishSalesState  {
  const FinishSalesState();
}

class FinishSalesInitial extends FinishSalesState {}

class FinishSalesLoading extends FinishSalesState {}

class FinishSalesSuccess extends FinishSalesState {
  final FinishSalesEntity finishSalesEntity;

  const FinishSalesSuccess({required this.finishSalesEntity});
}

class FinishSalesError extends FinishSalesState {
  final String message;

  const FinishSalesError({required this.message});
}
