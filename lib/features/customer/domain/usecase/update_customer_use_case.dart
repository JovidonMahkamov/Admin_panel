import 'package:admin_panel/features/customer/domain/entity/create_customer_response_entity.dart';
import 'package:admin_panel/features/customer/domain/entity/update_customer_entity.dart';
import 'package:admin_panel/features/customer/domain/repository/customer_repositories.dart';

class UpdateCustomerUseCase {
  final CustomerRepositories repo;
  UpdateCustomerUseCase(this.repo);

  Future<UpdateCustomerEntity> call({required int id, required String fish, required int qarzdorlik, required String manzil, required String telefon}) async{
    return await repo.updateCustomer(id: id, fish: fish, manzil: manzil, qarzdorlik: qarzdorlik, telefon: telefon);
  }
}
