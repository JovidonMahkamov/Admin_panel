import 'package:admin_panel/core/networks/api_urls.dart';
import 'package:admin_panel/core/networks/dio_client.dart';
import 'package:admin_panel/core/utils/logger.dart';
import 'package:admin_panel/features/dashboard/data/datasource/dashboard_data_source.dart';
import 'package:admin_panel/features/dashboard/data/model/dashboard_model.dart';

class DashboardDataSourceImpl implements DashboardDataSource {
  final DioClient dioClient = DioClient();

  DashboardDataSourceImpl();

  @override
  Future<DashboardDataModel> getDashboard() async {
    try {
      final response = await dioClient.get(ApiUrls.getDashboard);
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return DashboardDataModel.fromJson(response.data);
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
