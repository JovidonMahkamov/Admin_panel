import '../entity/monthly_sales_entity.dart';

abstract class MonthlySellingRepositories {
  Future<MonthlySalesEntity> getMonthlySelling();

}