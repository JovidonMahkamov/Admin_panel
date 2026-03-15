import 'package:admin_panel/features/cost/data/datasource/cost_data_source.dart';
import 'package:admin_panel/features/cost/domain/entity/cost_entity.dart';
import 'package:admin_panel/features/cost/domain/entity/create_cash_expense_entity.dart';
import 'package:admin_panel/features/cost/domain/entity/create_expense_request_model.dart';
import 'package:admin_panel/features/cost/domain/entity/delete_cash_expense_entity.dart';
import 'package:admin_panel/features/cost/domain/entity/delete_expense_entity.dart';
import 'package:admin_panel/features/cost/domain/entity/expense_entity.dart';
import 'package:admin_panel/features/cost/domain/entity/get_cash_expense_entity.dart';
import 'package:admin_panel/features/cost/domain/entity/update_cash_expense_entity.dart';
import 'package:admin_panel/features/cost/domain/entity/update_expense_entity.dart';
import 'package:admin_panel/features/cost/domain/repository/cost_repo.dart';

class CostRepoImpl implements CostRepo {
  final CostDataSource remote;

  CostRepoImpl({required this.remote});

  @override
  Future<CostEntity> getHarajatlar() => remote.getHarajatlar();

  @override
  Future<ExpenseEntity> postHarajat({
    required CreateExpenseRequestModel request,
  }) async {
    final response = await remote.postHarajat(request: request);
    return response.data;
  }

  @override
  Future<DeleteExpenseEntity> deleteHarajat({required int id}) {
    return remote.deleteHarajat(id: id);
  }

  @override
  Future<UpdateExpenseEntity> updateHarajat({required int id, required int ishchiId, required String izoh, required bool sms, required num summa, required String tolovTuri}) {
    return remote.updateHarajat(id: id, ishchiId: ishchiId, izoh: izoh, sms: sms, summa: summa, tolovTuri: tolovTuri);
  }

  @override
  Future<GetCashExpenseEntity> getKassa({required String tur}) {
    return remote.getKassa(tur: tur);
  }

  @override
  Future<CreateCashExpenseEntity> postKassa({required String doKon, required String izoh, required String mahsulotNomi, required bool sms, required num summa, required String tolovTuri}) {
    return remote.postKassa(doKon: doKon, izoh: izoh, mahsulotNomi: mahsulotNomi, sms: sms, summa: summa, tolovTuri: tolovTuri);
  }

  @override
  Future<DeleteCashExpenseEntity> deleteKassa({required int id}) {
    return remote.deleteKassa(id: id);
  }

  @override
  Future<UpdateCashExpenseEntity> updateKassa({required int id, required String doKon, required String izoh, required String mahsulotNomi, required bool sms, required num summa, required String tolovTuri}) {
    return remote.updateKassa(id: id, doKon: doKon, izoh: izoh, mahsulotNomi: mahsulotNomi, sms: sms, summa: summa, tolovTuri: tolovTuri);
  }
}
