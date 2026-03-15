import 'package:admin_panel/features/cost/domain/repository/cost_repo.dart';
import '../entity/create_cash_expense_entity.dart';

class PostKassaUseCase {
  final CostRepo repo;

  PostKassaUseCase(this.repo);

  Future<CreateCashExpenseEntity> call({
    required String doKon,
    required String izoh,
    required String mahsulotNomi,
    required bool sms,
    required num summa,
    required String tolovTuri,
  }) => repo.postKassa(
    doKon: doKon,
    izoh: izoh,
    mahsulotNomi: mahsulotNomi,
    sms: sms,
    summa: summa,
    tolovTuri: tolovTuri,
  );
}
