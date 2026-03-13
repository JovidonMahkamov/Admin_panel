import 'package:admin_panel/features/customer/data/datasource/customer_data_source.dart';
import 'package:admin_panel/features/customer/domain/entity/create_customer_response_entity.dart';
import 'package:admin_panel/features/customer/domain/entity/get_all_customers_entity.dart';
import 'package:admin_panel/features/customer/domain/entity/update_customer_entity.dart';
import 'package:admin_panel/features/customer/domain/repository/customer_repositories.dart';
import '../../domain/entity/delete_customer_response_entity.dart';

class CustomerRepositoryImpl implements CustomerRepositories {
  final CustomerDataSource remote;

  CustomerRepositoryImpl({required this.remote});

  @override
  Future<GetAllCustomersEntity> getAllCustomers() => remote.getAllCustomers();

  @override
  Future<CreateCustomerResponseEntity> createCustomer({
    required String fish,
    required String manzil,
    required String telefon,
  }) {
    return remote.createCustomer(fish: fish, manzil: manzil, telefon: telefon);
  }

  @override
  Future<DeleteCustomerResponseEntity> deleteCustomer({required int id}) {
    return remote.deleteCustomer(id: id);
  }

  @override
  Future<UpdateCustomerEntity> updateCustomer({
    required int id,
    required String fish,
    required String manzil,
    required int qarzdorlik,
    required String telefon,
  }) {
    return remote.updateCustomer(
      id: id,
      fish: fish,
      qarzdorlik: qarzdorlik,
      manzil: manzil,
      telefon: telefon,
    );
  }
}
