import 'package:admin_panel/features/customer/data/model/create_customer_response_model.dart';
import 'package:admin_panel/features/customer/data/model/delete_customer_response_model.dart';
import 'package:admin_panel/features/customer/data/model/get_all_customers_model.dart';

abstract class CustomerDataSource{
  Future<GetAllCustomersModel> getAllCustomers();
  Future<CreateCustomerResponseModel> createCustomer({required String fish, required String manzil, required String telefon});
  Future<DeleteCustomerResponseModel> deleteCustomer({required int id});

}