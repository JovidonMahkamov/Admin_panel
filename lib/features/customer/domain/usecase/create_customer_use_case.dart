import 'package:admin_panel/features/customer/domain/entity/create_customer_request_entity.dart';
import 'package:admin_panel/features/customer/domain/entity/create_customer_response_entity.dart';
import 'package:admin_panel/features/customer/domain/repository/customer_repositories.dart';

class CreateCustomerUseCase {
  final CustomerRepositories repo;
  CreateCustomerUseCase(this.repo);

  Future<CreateCustomerResponseEntity> call({required CreateCustomerRequestEntity createCustomer}) async{
    return await repo.createCustomer(createCustomer: createCustomer);
  }
}
