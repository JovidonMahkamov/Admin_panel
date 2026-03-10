import 'package:admin_panel/features/customer/domain/entity/delete_customer_response_entity.dart';
import 'package:admin_panel/features/customer/domain/repository/customer_repositories.dart';

class DeleteCustomerUseCase {
  final CustomerRepositories repo;
  DeleteCustomerUseCase(this.repo);

  Future<DeleteCustomerResponseEntity> call({required int id}) async{
    return await repo.deleteCustomer(id: id);
  }
}
