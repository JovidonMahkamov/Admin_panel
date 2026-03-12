import 'package:admin_panel/core/networks/api_urls.dart';
import 'package:admin_panel/core/networks/dio_client.dart';
import 'package:admin_panel/core/utils/logger.dart';
import 'package:admin_panel/features/products/data/datasource/product_data_source.dart';
import 'package:admin_panel/features/products/data/model/product_model.dart';

class ProductDataSourceImpl implements ProductDataSource {
  final DioClient dioClient = DioClient();

  ProductDataSourceImpl();

  @override
  Future<List<ProductModel>> getProducts() async{
    try {
      final response = await dioClient.get(ApiUrls.getProducts);
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        final data = response.data;
        final List<dynamic> dataList = response.data['data'] as List<dynamic>? ?? [];

        return dataList
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
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
