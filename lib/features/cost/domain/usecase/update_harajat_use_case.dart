import 'package:admin_panel/features/cost/domain/repository/cost_repo.dart';
import '../entity/update_expense_entity.dart';

class UpdateHarajatUseCase {
  final CostRepo repo;

  UpdateHarajatUseCase(this.repo);

  Future<UpdateExpenseEntity> call({
    required int id,
    required int ishchiId,
    required String izoh,
    required bool sms,
    required num summa,
    required String tolovTuri,
  }) => repo.updateHarajat(
    id: id,
    ishchiId: ishchiId,
    izoh: izoh,
    sms: sms,
    summa: summa,
    tolovTuri: tolovTuri,
  );
}
