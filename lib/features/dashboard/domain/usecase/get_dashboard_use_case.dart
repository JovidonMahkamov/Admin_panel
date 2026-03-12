import 'package:admin_panel/features/dashboard/domain/entity/dashboard_entity.dart';
import 'package:admin_panel/features/dashboard/domain/repository/dashboard_repositories.dart';

class GetDashboardUseCase {
  final DashboardRepositories repo;
  GetDashboardUseCase(this.repo);

  Future<DashboardDataEntity> call() => repo.getDashboard();
}
