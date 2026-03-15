import 'package:admin_panel/features/cost/domain/entity/update_cash_expense_entity.dart';
import 'package:admin_panel/features/cost/domain/repository/cost_repo.dart';

class UpdateKassaUseCase {
  final CostRepo repo;

  UpdateKassaUseCase(this.repo);

  Future<UpdateCashExpenseEntity> call({
    required int id,
    required String doKon,
    required String izoh,
    required String mahsulotNomi,
    required bool sms,
    required num summa,
    required String tolovTuri,
  }) => repo.updateKassa(
    id: id,
    doKon: doKon,
    izoh: izoh,
    mahsulotNomi: mahsulotNomi,
    sms: sms,
    summa: summa,
    tolovTuri: tolovTuri,
  );
}
