import 'package:admin_panel/features/customer/domain/entity/get_all_customers_entity.dart';
import 'package:admin_panel/features/dashboard/domain/entity/dashboard_entity.dart';

abstract class GetDashboardState {
  const GetDashboardState();
}

class GetDashboardInitial extends GetDashboardState {}

class GetDashboardLoading extends GetDashboardState {}

class GetDashboardSuccess extends GetDashboardState {
  final DashboardDataEntity dashboardDataEntity;

  const GetDashboardSuccess({required this.dashboardDataEntity});
}

class GetDashboardError extends GetDashboardState {
  final String message;

  const GetDashboardError({required this.message});
}
