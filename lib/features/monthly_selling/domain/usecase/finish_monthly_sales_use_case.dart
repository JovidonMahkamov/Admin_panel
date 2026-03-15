import 'package:admin_panel/features/monthly_selling/domain/entity/finish_monthly_sales_entity.dart';
import 'package:admin_panel/features/monthly_selling/domain/repository/monthly_selling_repositories.dart';

class FinishMonthlySalesUseCase {
  final MonthlySellingRepositories repo;
  FinishMonthlySalesUseCase(this.repo);

  Future<FinishMonthlySalesEntity> call({required String oy}) async{
    return await repo.finishMonthlySelling(oy: oy);
  }
}
