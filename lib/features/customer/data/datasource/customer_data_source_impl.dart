import 'package:admin_panel/core/networks/api_urls.dart';
import 'package:admin_panel/core/networks/dio_client.dart';
import 'package:admin_panel/core/utils/logger.dart';
import 'package:admin_panel/features/customer/data/datasource/customer_data_source.dart';
import 'package:admin_panel/features/customer/data/model/create_customer_response_model.dart';
import 'package:admin_panel/features/customer/data/model/delete_customer_response_model.dart';
import 'package:admin_panel/features/customer/data/model/get_all_customers_model.dart';

class CustomerDataSourceImpl implements CustomerDataSource {
  final DioClient dioClient = DioClient();

  CustomerDataSourceImpl();
  @override
  Future<GetAllCustomersModel> getAllCustomers() async {
    try {
      final response = await dioClient.get(ApiUrls.getAllCustomers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return GetAllCustomersModel.fromJson(response.data);
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
  Future<CreateCustomerResponseModel> createCustomer({required String fish, required String manzil, required String telefon})async {
    try {
      final response = await dioClient.post(ApiUrls.createCustomer);
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return CreateCustomerResponseModel.fromJson(response.data);
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
  Future<DeleteCustomerResponseModel> deleteCustomer({required int id})async {
    try {
      final response = await dioClient.delete("ApiUrls.deleteCustomer/$id");
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return DeleteCustomerResponseModel.fromJson(response.data);
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
