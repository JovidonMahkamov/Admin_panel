import 'package:admin_panel/core/networks/api_urls.dart';
import 'package:admin_panel/core/networks/dio_client.dart';
import 'package:admin_panel/core/utils/logger.dart';
import 'package:admin_panel/features/dashboard/data/datasource/dashboard_data_source.dart';
import 'package:admin_panel/features/dashboard/data/model/dashboard_model.dart';
import 'package:admin_panel/features/dashboard/data/model/finish_sales_model.dart';
import 'package:admin_panel/features/dashboard/data/model/transfer_response_model.dart';
import 'package:admin_panel/features/dashboard/data/model/worker_detail_model.dart';

class DashboardDataSourceImpl implements DashboardDataSource {
  final DioClient dioClient = DioClient();

  DashboardDataSourceImpl();

  @override
  Future<DashboardDataModel> getDashboard() async {
    try {
      final response = await dioClient.get(ApiUrls.getDashboard);

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');

        return DashboardDataModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
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
  Future<FinishSalesModel> finishSales() async {
    try {
      final response = await dioClient.post(ApiUrls.finishSales);

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('finish sales successful: ${response.data}');
        return FinishSalesModel.fromJson(response.data);
      } else {
        LoggerService.warning("finish sales failed:${response.statusCode}");
        throw Exception('finish sales failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during finish sales: $e');
      rethrow;
    }
  }

  @override
  Future<WorkerDetailModel> workerDetail({
    required String sana,
    required int id,
  }) async {
    try {
      final response = await dioClient.get(
        ApiUrls.workerDeail,
        queryParams: {
          "sana": sana,
          "ishchi_id": id,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('worker detail successful: ${response.data}');
        return WorkerDetailModel.fromJson(response.data);
      } else {
        LoggerService.warning("worker detail failed:${response.statusCode}");
        throw Exception('worker detail failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during worker detail: $e');
      rethrow;
    }
  }

  @override
  Future<TransferResponseModel> updateTransfer({required String dan, required String ga, required num summa}) async{
    try {
      final response = await dioClient.patch(
        ApiUrls.updateTransfer,
        data: {
          "dan": dan,
          "ga": ga,
          "summa": summa,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('worker detail successful: ${response.data}');
        return TransferResponseModel.fromJson(response.data);
      } else {
        LoggerService.warning("worker detail failed:${response.statusCode}");
        throw Exception('worker detail failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during worker detail: $e');
      rethrow;
    }
  }
}