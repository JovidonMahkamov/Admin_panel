import 'package:admin_panel/features/cost/domain/entity/cost_entity.dart';
import 'package:admin_panel/features/cost/domain/entity/create_expense_request_model.dart';
import 'package:admin_panel/features/cost/domain/entity/delete_expense_entity.dart';
import 'package:admin_panel/features/cost/domain/entity/dokon_chiqim_entity.dart';
import 'package:admin_panel/features/cost/domain/entity/expense_entity.dart';
import '../entity/create_cash_expense_entity.dart';
import '../entity/delete_cash_expense_entity.dart';
import '../entity/get_cash_expense_entity.dart';
import '../entity/update_cash_expense_entity.dart';
import '../entity/update_expense_entity.dart';

abstract class CostRepo {
  Future<CostEntity> getHarajatlar();

  Future<ExpenseEntity> postHarajat({required CreateExpenseRequestModel request});

  Future<DeleteExpenseEntity> deleteHarajat({required int id});

  Future<UpdateExpenseEntity> updateHarajat({
    required int id,
    required int ishchiId,
    required String izoh,
    required bool sms,
    required num summa,
    required String tolovTuri,
  });

  Future<GetCashExpenseEntity> getKassa({required String tur});

  Future<CreateCashExpenseEntity> postKassa({
    required String doKon,
    required String izoh,
    required String mahsulotNomi,
    required bool sms,
    required num summa,
    required String tolovTuri,
  });

  Future<DeleteCashExpenseEntity> deleteKassa({required int id});

  Future<UpdateCashExpenseEntity> updateKassa({
    required int id,
    required String doKon,
    required String izoh,
    required String mahsulotNomi,
    required bool sms,
    required num summa,
    required String tolovTuri,
  });

  // DokonChiqim
  Future<List<DokonChiqimEntity>> getDokonChiqim({String? tolovTuri});

  Future<CreateDokonChiqimEntity> postDokonChiqim({
    required String tolovTuri,
    required double summa,
    String? izoh,
    String? tavsif,
  });

  Future<CreateDokonChiqimEntity> patchDokonChiqim({
    required int id,
    String? tolovTuri,
    double? summa,
    String? izoh,
    String? tavsif,
  });

  Future<DeleteDokonChiqimEntity> deleteDokonChiqim({required int id});
}