import 'package:admin_panel/features/cost/data/model/cost_model.dart';
import 'package:admin_panel/features/cost/data/model/delete_expense_model.dart';
import 'package:admin_panel/features/cost/data/model/dokon_chiqim_model.dart';
import 'package:admin_panel/features/cost/data/model/expense_response_model.dart';
import 'package:admin_panel/features/cost/data/model/update_cash_expense_model.dart';
import 'package:admin_panel/features/cost/data/model/update_expense_data_model.dart';
import 'package:admin_panel/features/cost/domain/entity/create_expense_request_model.dart';
import '../model/create_cash_expense_model.dart';
import '../model/delete_cash_expense_model.dart';
import '../model/get_cash_expense_model.dart';

abstract class CostDataSource {
  Future<CostModel> getHarajatlar();

  Future<ExpenseResponseModel> postHarajat({
    required CreateExpenseRequestModel request,
  });

  Future<DeleteExpenseModel> deleteHarajat({required int id});

  Future<UpdateExpenseModel> updateHarajat({
    required int id,
    required int ishchiId,
    required String izoh,
    required bool sms,
    required num summa,
    required String tolovTuri,
  });

  Future<GetCashExpenseModel> getKassa({required String tur});

  Future<CreateCashExpenseModel> postKassa({
    required String doKon,
    required String izoh,
    required String mahsulotNomi,
    required bool sms,
    required num summa,
    required String tolovTuri,
  });

  Future<DeleteCashExpenseModel> deleteKassa({required int id});

  Future<UpdateCashExpenseModel> updateKassa({
    required int id,
    required String doKon,
    required String izoh,
    required String mahsulotNomi,
    required bool sms,
    required num summa,
    required String tolovTuri,
  });

  // DokonChiqim
  Future<List<DokonChiqimModel>> getDokonChiqim({String? tolovTuri});

  Future<CreateDokonChiqimModel> postDokonChiqim({
    required String tolovTuri,
    required double summa,
    String? izoh,
    String? tavsif,
  });

  Future<CreateDokonChiqimModel> patchDokonChiqim({
    required int id,
    String? tolovTuri,
    double? summa,
    String? izoh,
    String? tavsif,
  });

  Future<DeleteDokonChiqimModel> deleteDokonChiqim({required int id});
}