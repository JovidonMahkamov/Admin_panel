import 'package:admin_panel/features/cost/domain/repository/cost_repo.dart';
import '../entity/get_cash_expense_entity.dart';

class GetKassaUseCase {
  final CostRepo repo;
  GetKassaUseCase(this.repo);

  Future<GetCashExpenseEntity> call({required String tur}) => repo.getKassa(tur: tur);
}
