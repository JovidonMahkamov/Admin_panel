import 'package:admin_panel/features/customer/domain/entity/delete_customer_response_entity.dart';
import '../entity/create_customer_response_entity.dart';
import '../entity/get_all_customers_entity.dart';

abstract class CustomerRepositories{
  Future<GetAllCustomersEntity> getAllCustomers();
  Future<CreateCustomerResponseEntity> createCustomer({required String fish, required String manzil, required String telefon});
  Future<DeleteCustomerResponseEntity> deleteCustomer({required int id});

}