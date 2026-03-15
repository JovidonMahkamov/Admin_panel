import 'package:admin_panel/features/cost/domain/repository/cost_repo.dart';
import '../entity/delete_cash_expense_entity.dart';

class DeleteKassaUseCase {
  final CostRepo repo;
  DeleteKassaUseCase(this.repo);

  Future<DeleteCashExpenseEntity> call({required int id}) => repo.deleteKassa(id: id);
}
