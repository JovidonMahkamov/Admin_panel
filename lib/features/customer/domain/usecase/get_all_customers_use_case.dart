import 'package:admin_panel/features/customer/domain/entity/get_all_customers_entity.dart';
import 'package:admin_panel/features/customer/domain/repository/customer_repositories.dart';

class GetAllCustomersUseCase {
  final CustomerRepositories repo;
  GetAllCustomersUseCase(this.repo);

  Future<GetAllCustomersEntity> call() => repo.getAllCustomers();
}
