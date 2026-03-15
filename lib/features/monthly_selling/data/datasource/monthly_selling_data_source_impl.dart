import 'package:admin_panel/features/monthly_selling/data/datasource/monthly_selling_data_source.dart';
import 'package:admin_panel/features/monthly_selling/data/model/finish_monthly_sales_data_model.dart';
import 'package:admin_panel/features/monthly_selling/data/model/monthly_sales_model.dart';
import '../../../../core/networks/api_urls.dart';
import '../../../../core/networks/dio_client.dart';
import '../../../../core/utils/logger.dart';

class MonthlySellingDataSourceImpl implements MonthlySellingDataSource {
  final DioClient dioClient = DioClient();

  MonthlySellingDataSourceImpl();

  @override
  Future<MonthlySalesModel> getMonthlySelling() async {
    try {
      final response = await dioClient.get(ApiUrls.getMonthlySelling);
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return MonthlySalesModel.fromJson(response.data);
      } else {
        LoggerService.warning("statistics failed:${response.statusCode}");
        throw Exception('statistics failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during user statistics: $e');
      rethrow;
    }
  }

  @override
  Future<FinishMonthlySalesModel> finishMonthlySelling({required String oy}) async{
    try {
      final response = await dioClient.post(
        ApiUrls.finishMonthlySelling,
        data: {
          "oy": oy,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return FinishMonthlySalesModel.fromJson(response.data);
      } else {
        LoggerService.warning("statistics failed:${response.statusCode}");
        throw Exception('statistics failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during user statistics: $e');
      rethrow;
    }
  }
}