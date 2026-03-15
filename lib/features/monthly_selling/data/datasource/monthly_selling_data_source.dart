import 'package:admin_panel/features/monthly_selling/data/model/finish_monthly_sales_data_model.dart';
import 'package:admin_panel/features/monthly_selling/data/model/monthly_sales_model.dart';

abstract class MonthlySellingDataSource {
  Future<MonthlySalesModel> getMonthlySelling();
  Future<FinishMonthlySalesModel> finishMonthlySelling({required String oy});
}