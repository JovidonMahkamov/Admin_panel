import 'package:admin_panel/features/cost/domain/entity/delete_expense_entity.dart';
import 'package:admin_panel/features/cost/domain/repository/cost_repo.dart';

class DeleteHarajatUseCase {
  final CostRepo repo;
  DeleteHarajatUseCase(this.repo);

  Future<DeleteExpenseEntity> call({required int id}) => repo.deleteHarajat(id: id);
}
