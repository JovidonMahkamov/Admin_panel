import 'package:admin_panel/features/monthly_selling/domain/repository/monthly_selling_repositories.dart';
import '../entity/monthly_sales_entity.dart';

class GetMonthlySellingUseCase {
  final MonthlySellingRepositories repo;
  GetMonthlySellingUseCase(this.repo);

  Future<MonthlySalesEntity> call() async{
    return await repo.getMonthlySelling();
  }
}
