import 'package:admin_panel/features/dashboard/data/datasource/dashboard_data_source.dart';
import 'package:admin_panel/features/dashboard/domain/entity/dashboard_entity.dart';
import 'package:admin_panel/features/dashboard/domain/entity/finish_sales_entity.dart';
import 'package:admin_panel/features/dashboard/domain/entity/worker_detail_entity.dart';
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

  @override
  Future<FinishSalesEntity> finishSales() {
    return remote.finishSales();
  }

  @override
  Future<WorkerDetailEntity> workerDetail({required String sana, required int id}) {
    return remote.workerDetail(sana: sana, id: id);
  }
}