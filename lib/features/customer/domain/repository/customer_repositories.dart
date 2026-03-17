import 'package:admin_panel/features/customer/domain/entity/create_customer_request_entity.dart';
import 'package:admin_panel/features/customer/domain/entity/delete_customer_response_entity.dart';
import 'package:admin_panel/features/customer/domain/entity/get_customer_detail_entity.dart';
import 'package:admin_panel/features/customer/domain/entity/update_customer_entity.dart';
import '../entity/create_customer_response_entity.dart';
import '../entity/get_all_customers_entity.dart';

abstract class CustomerRepositories{
  Future<GetAllCustomersEntity> getAllCustomers();
  Future<GetCustomerDetailEntity> getCustomer({required int id});
  Future<CreateCustomerResponseEntity> createCustomer({required CreateCustomerRequestEntity createCustomer});
  Future<DeleteCustomerResponseEntity> deleteCustomer({required int id});
  Future<UpdateCustomerEntity> updateCustomer({required int id,required String fish, required String manzil, required int qarzdorlik, required String telefon});

}