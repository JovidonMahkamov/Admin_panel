import 'package:admin_panel/features/dashboard/data/datasource/dashboard_data_source.dart';
import 'package:admin_panel/features/dashboard/domain/entity/dashboard_entity.dart';
import 'package:admin_panel/features/dashboard/domain/repository/dashboard_repositories.dart';

class DashboardRepositoryImpl implements DashboardRepositories {
  final DashboardDataSource remote;

  DashboardRepositoryImpl({
    required this.remote,
  });

  @override
  Future<DashboardDataEntity> getDashboard() {
    return remote.getDashboard();

  }
}