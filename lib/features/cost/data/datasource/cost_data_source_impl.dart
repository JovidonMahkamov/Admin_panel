import 'package:admin_panel/core/networks/api_urls.dart';
import 'package:admin_panel/core/networks/dio_client.dart';
import 'package:admin_panel/core/utils/logger.dart';
import 'package:admin_panel/features/cost/data/datasource/cost_data_source.dart';
import 'package:admin_panel/features/cost/data/model/cost_model.dart';
import 'package:admin_panel/features/cost/data/model/expense_response_model.dart';
import 'package:admin_panel/features/cost/domain/entity/create_expense_request_model.dart';

class CostDataSourceImpl implements CostDataSource {
  final DioClient dioClient = DioClient();

  CostDataSourceImpl();

  @override
  Future<CostModel> getHarajatlar() async {
    try {
      final response = await dioClient.get(ApiUrls.getHarajat);

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('getHarajatlar successful: ${response.data}');
        return CostModel.fromJson(response.data);
      } else {
        LoggerService.warning('getHarajatlar failed: ${response.statusCode}');
        throw Exception('getHarajatlar failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during getHarajatlar: $e');
      rethrow;
    }
  }

  @override
  Future<ExpenseResponseModel> postHarajat({
    required CreateExpenseRequestModel request,
  }) async {
    try {
      final response = await dioClient.post(
        ApiUrls.postHarajat,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('postHarajat successful: ${response.data}');
        return ExpenseResponseModel.fromJson(response.data);
      } else {
        LoggerService.warning('postHarajat failed: ${response.statusCode}');
        throw Exception('postHarajat failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during postHarajat: $e');
      rethrow;
    }
  }
}