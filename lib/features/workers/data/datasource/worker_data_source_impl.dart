import 'package:admin_panel/core/networks/api_urls.dart';
import 'package:admin_panel/core/networks/dio_client.dart';
import 'package:admin_panel/core/utils/logger.dart';
import 'package:admin_panel/features/workers/data/datasource/worker_data_source.dart';
import 'package:admin_panel/features/workers/data/model/create_worker_response_model.dart';
import 'package:admin_panel/features/workers/data/model/delete_worker_model.dart';
import 'package:admin_panel/features/workers/data/model/get_all_workers_model.dart';
import 'package:admin_panel/features/workers/data/model/update_worker_response_model.dart';

class WorkerDataSourceImpl implements WorkerDataSource {
  final DioClient dioClient = DioClient();

  WorkerDataSourceImpl();

  @override
  Future<GetAllWorkersModel> getAllWorker() async {
    try {
      final response = await dioClient.get(ApiUrls.getAllWorker);
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return GetAllWorkersModel.fromJson(response.data);
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
  Future<CreateWorkerResponseModel> createWorker({
    required String fish,
    required String login,
    required String parol,
    required String telefon,
  }) async {
    try {
      final response = await dioClient.post(
        ApiUrls.createWorker,
        data: {
          "fish": fish,
          "login": login,
          "parol": parol,
          "telefon": telefon,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return CreateWorkerResponseModel.fromJson(response.data);
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
  Future<DeleteWorkerResponseModel> deleteWorker({required int id}) async {
    try {
      final response = await dioClient.delete("${ApiUrls.deleteWorker}/$id");
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return DeleteWorkerResponseModel.fromJson(response.data);
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
  Future<UpdateWorkerResponseModel> updateWorker({
    required int id,
    required String fish,
    required String parol,
    required String login,
    required String telefon,
  }) async {
    try {
      final response = await dioClient.patch(
        "${ApiUrls.updateWorker}/$id",
        data: {
          "fish": fish,
          "parol": parol,
          "telefon": telefon,
          "login": login,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return UpdateWorkerResponseModel.fromJson(response.data);
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
