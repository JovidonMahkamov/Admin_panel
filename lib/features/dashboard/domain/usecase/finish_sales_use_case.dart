import 'package:admin_panel/features/dashboard/domain/entity/finish_sales_entity.dart';
import 'package:admin_panel/features/dashboard/domain/repository/dashboard_repositories.dart';

class FinishSalesUseCase{
  final DashboardRepositories repo;
  FinishSalesUseCase(this.repo);

  Future<FinishSalesEntity> call() => repo.finishSales();
}
