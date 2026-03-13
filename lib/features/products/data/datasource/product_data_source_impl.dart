import 'package:admin_panel/core/networks/api_urls.dart';
import 'package:admin_panel/core/networks/dio_client.dart';
import 'package:admin_panel/core/utils/logger.dart';
import 'package:admin_panel/features/products/data/datasource/product_data_source.dart';
import 'package:admin_panel/features/products/data/model/create_product_response_model.dart';
import 'package:admin_panel/features/products/data/model/delete_product_model.dart';
import 'package:admin_panel/features/products/data/model/product_model.dart';
import 'package:admin_panel/features/products/domain/entity/create_product_params.dart';
import 'package:dio/dio.dart';

class ProductDataSourceImpl implements ProductDataSource {
  final DioClient dioClient = DioClient();

  ProductDataSourceImpl();

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dioClient.get(ApiUrls.getProducts);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> dataList = response.data['data'] as List<dynamic>? ?? [];

        return dataList
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('products failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during get products: $e');
      rethrow;
    }
  }

  @override
  Future<CreateProductResponseModel> createProduct({
    required CreateProductParams create,
  }) async {
    try {
      final formMap = <String, dynamic>{
        'nomi': create.nomi,
        if (create.narxDona != null && create.narxDona!.trim().isNotEmpty)
          'narx_dona': create.narxDona,
        if (create.narxMetr != null && create.narxMetr!.trim().isNotEmpty)
          'narx_metr': create.narxMetr,
        if (create.narxPochka != null && create.narxPochka!.trim().isNotEmpty)
          'narx_pochka': create.narxPochka,
        if (create.pochka != null && create.pochka!.trim().isNotEmpty)
          'pochka': create.pochka,
        if (create.metr != null && create.metr!.trim().isNotEmpty)
          'metr': create.metr,
        if (create.miqdor != null && create.miqdor!.trim().isNotEmpty)
          'miqdor': create.miqdor,
        if (create.kelganNarx != null && create.kelganNarx!.trim().isNotEmpty)
          'kelgan_narx': create.kelganNarx,
        if (create.jamiNarx != null && create.jamiNarx!.trim().isNotEmpty)
          'jami_narx': create.jamiNarx,
      };

      if (create.rasm != null) {
        formMap['rasm'] = await MultipartFile.fromFile(
          create.rasm!.path,
          filename: create.rasm!.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(formMap);

      final response = await dioClient.post(
        ApiUrls.createProduct,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateProductResponseModel.fromJson(response.data);
      } else {
        throw Exception('create product failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during create product: $e');
      rethrow;
    }
  }

  @override
  Future<DeleteProductModel> deleteProduct({required int id}) async{
    try{
      final response = await dioClient.delete("${ApiUrls.delete}/$id");
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return DeleteProductModel.fromJson(response.data);
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