import 'package:admin_panel/features/monthly_selling/data/datasource/monthly_selling_data_source.dart';
import 'package:admin_panel/features/monthly_selling/domain/entity/monthly_sales_entity.dart';
import 'package:admin_panel/features/monthly_selling/domain/repository/monthly_selling_repositories.dart';

class MonthlySellingRepositoryImpl implements MonthlySellingRepositories {
  final MonthlySellingDataSource remote;

  MonthlySellingRepositoryImpl({
    required this.remote,
  });

  @override
  Future<MonthlySalesEntity> getMonthlySelling() => remote.getMonthlySelling();
}