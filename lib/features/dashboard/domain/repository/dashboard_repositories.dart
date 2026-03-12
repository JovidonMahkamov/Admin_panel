import 'package:admin_panel/features/dashboard/domain/entity/dashboard_entity.dart';

abstract class DashboardRepositories {
  Future<DashboardDataEntity> getDashboard();
}