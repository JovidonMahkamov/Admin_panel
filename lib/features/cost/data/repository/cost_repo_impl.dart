import 'package:admin_panel/features/cost/data/datasource/cost_data_source.dart';
import 'package:admin_panel/features/cost/domain/entity/cost_entity.dart';
import 'package:admin_panel/features/cost/domain/entity/create_cash_expense_entity.dart';
import 'package:admin_panel/features/cost/domain/entity/create_expense_request_model.dart';
import 'package:admin_panel/features/cost/domain/entity/delete_cash_expense_entity.dart';
import 'package:admin_panel/features/cost/domain/entity/delete_expense_entity.dart';
import 'package:admin_panel/features/cost/domain/entity/dokon_chiqim_entity.dart';
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
  Future<ExpenseEntity> postHarajat({required CreateExpenseRequestModel request}) async {
    final response = await remote.postHarajat(request: request);
    return response.data;
  }

  @override
  Future<DeleteExpenseEntity> deleteHarajat({required int id}) =>
      remote.deleteHarajat(id: id);

  @override
  Future<UpdateExpenseEntity> updateHarajat({
    required int id,
    required int ishchiId,
    required String izoh,
    required bool sms,
    required num summa,
    required String tolovTuri,
  }) =>
      remote.updateHarajat(
          id: id, ishchiId: ishchiId, izoh: izoh, sms: sms, summa: summa, tolovTuri: tolovTuri);

  @override
  Future<GetCashExpenseEntity> getKassa({required String tur}) =>
      remote.getKassa(tur: tur);

  @override
  Future<CreateCashExpenseEntity> postKassa({
    required String doKon,
    required String izoh,
    required String mahsulotNomi,
    required bool sms,
    required num summa,
    required String tolovTuri,
  }) =>
      remote.postKassa(
          doKon: doKon, izoh: izoh, mahsulotNomi: mahsulotNomi, sms: sms, summa: summa, tolovTuri: tolovTuri);

  @override
  Future<DeleteCashExpenseEntity> deleteKassa({required int id}) =>
      remote.deleteKassa(id: id);

  @override
  Future<UpdateCashExpenseEntity> updateKassa({
    required int id,
    required String doKon,
    required String izoh,
    required String mahsulotNomi,
    required bool sms,
    required num summa,
    required String tolovTuri,
  }) =>
      remote.updateKassa(
          id: id, doKon: doKon, izoh: izoh, mahsulotNomi: mahsulotNomi, sms: sms, summa: summa, tolovTuri: tolovTuri);

  // DokonChiqim
  @override
  Future<List<DokonChiqimEntity>> getDokonChiqim({String? tolovTuri}) =>
      remote.getDokonChiqim(tolovTuri: tolovTuri);

  @override
  Future<CreateDokonChiqimEntity> postDokonChiqim({
    required String tolovTuri,
    required double summa,
    String? izoh,
    String? tavsif,
  }) =>
      remote.postDokonChiqim(tolovTuri: tolovTuri, summa: summa, izoh: izoh, tavsif: tavsif);

  @override
  Future<CreateDokonChiqimEntity> patchDokonChiqim({
    required int id,
    String? tolovTuri,
    double? summa,
    String? izoh,
    String? tavsif,
  }) =>
      remote.patchDokonChiqim(id: id, tolovTuri: tolovTuri, summa: summa, izoh: izoh, tavsif: tavsif);

  @override
  Future<DeleteDokonChiqimEntity> deleteDokonChiqim({required int id}) =>
      remote.deleteDokonChiqim(id: id);
}