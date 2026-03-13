import 'package:admin_panel/features/monthly_selling/data/model/monthly_sales_model.dart';

abstract class MonthlySellingDataSource {
  Future<MonthlySalesModel> getMonthlySelling();
}