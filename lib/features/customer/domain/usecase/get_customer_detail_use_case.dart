import 'package:admin_panel/features/customer/domain/entity/get_customer_detail_entity.dart';
import 'package:admin_panel/features/customer/domain/repository/customer_repositories.dart';

class GetCustomerDetailUseCase {
  final CustomerRepositories repo;
  GetCustomerDetailUseCase(this.repo);

  Future<GetCustomerDetailEntity> call({required int id}) => repo.getCustomer(id: id);
}
