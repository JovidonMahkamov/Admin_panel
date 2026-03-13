import 'package:admin_panel/core/networks/api_urls.dart';
import 'package:admin_panel/core/networks/dio_client.dart';
import 'package:admin_panel/core/utils/logger.dart';
import 'package:admin_panel/features/history/data/datasource/history_data_source.dart';
import 'package:admin_panel/features/history/data/model/History_model.dart';

class HistoryDataSourceImpl implements HistoryDataSource {
  final DioClient dioClient = DioClient();

  HistoryDataSourceImpl();

  @override
  Future<HistoryModel> getHistory() async {
    try {
      final response = await dioClient.get(ApiUrls.getHistory);
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return HistoryModel.fromJson(response.data);
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