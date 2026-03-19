import 'package:admin_panel/core/networks/api_urls.dart';
import 'package:admin_panel/core/networks/dio_client.dart';
import 'package:admin_panel/core/utils/logger.dart';
import '../model/balans_model.dart';
import 'balans_data_source.dart';

class BalansDataSourceImpl implements BalansDataSource {
  final DioClient dioClient = DioClient();

  @override
  Future<BalansModel> getBalans() async {
    try {
      final response = await dioClient.get(ApiUrls.getBalans);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return BalansModel.fromJson(response.data);
      } else {
        throw Exception('getBalans failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during getBalans: $e');
      rethrow;
    }
  }
}