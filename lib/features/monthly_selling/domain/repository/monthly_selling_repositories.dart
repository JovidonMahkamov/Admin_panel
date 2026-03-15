import '../entity/finish_monthly_sales_entity.dart';
import '../entity/monthly_sales_entity.dart';

abstract class MonthlySellingRepositories {
  Future<MonthlySalesEntity> getMonthlySelling();

  Future<FinishMonthlySalesEntity> finishMonthlySelling({required String oy});

}