import 'package:admin_panel/features/customer/domain/entity/create_customer_response_entity.dart';
import 'package:admin_panel/features/customer/domain/repository/customer_repositories.dart';

class CreateCustomerUseCase {
  final CustomerRepositories repo;
  CreateCustomerUseCase(this.repo);

  Future<CreateCustomerResponseEntity> call({required String fish, required String manzil, required String telefon}) async{
    return await repo.createCustomer(fish: fish, manzil: manzil, telefon: telefon);
  }
}
