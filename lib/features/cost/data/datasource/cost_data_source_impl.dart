import 'package:admin_panel/core/networks/api_urls.dart';
import 'package:admin_panel/core/networks/dio_client.dart';
import 'package:admin_panel/core/utils/logger.dart';
import 'package:admin_panel/features/cost/data/datasource/cost_data_source.dart';
import 'package:admin_panel/features/cost/data/model/cost_model.dart';
import 'package:admin_panel/features/cost/data/model/create_cash_expense_model.dart';
import 'package:admin_panel/features/cost/data/model/delete_cash_expense_model.dart';
import 'package:admin_panel/features/cost/data/model/delete_expense_model.dart';
import 'package:admin_panel/features/cost/data/model/dokon_chiqim_model.dart';
import 'package:admin_panel/features/cost/data/model/expense_response_model.dart';
import 'package:admin_panel/features/cost/data/model/get_cash_expense_model.dart';
import 'package:admin_panel/features/cost/data/model/update_cash_expense_model.dart';
import 'package:admin_panel/features/cost/data/model/update_expense_data_model.dart';
import 'package:admin_panel/features/cost/domain/entity/create_expense_request_model.dart';

class CostDataSourceImpl implements CostDataSource {
  final DioClient dioClient = DioClient();

  CostDataSourceImpl();

  @override
  Future<CostModel> getHarajatlar() async {
    try {
      final response = await dioClient.get(ApiUrls.getHarajat);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CostModel.fromJson(response.data);
      } else {
        throw Exception('getHarajatlar failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during getHarajatlar: $e');
      rethrow;
    }
  }

  @override
  Future<ExpenseResponseModel> postHarajat({
    required CreateExpenseRequestModel request,
  }) async {
    try {
      final response = await dioClient.post(ApiUrls.postHarajat, data: request.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ExpenseResponseModel.fromJson(response.data);
      } else {
        throw Exception('postHarajat failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during postHarajat: $e');
      rethrow;
    }
  }

  @override
  Future<DeleteExpenseModel> deleteHarajat({required int id}) async {
    try {
      final response = await dioClient.delete('${ApiUrls.deleteHarajat}/$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeleteExpenseModel.fromJson(response.data);
      } else {
        throw Exception('deleteHarajat failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during deleteHarajat: $e');
      rethrow;
    }
  }

  @override
  Future<UpdateExpenseModel> updateHarajat({
    required int id,
    required int ishchiId,
    required String izoh,
    required bool sms,
    required num summa,
    required String tolovTuri,
  }) async {
    try {
      final response = await dioClient.patch(
        '${ApiUrls.updateHarajat}/$id',
        data: {'ishchi_id': ishchiId, 'izoh': izoh, 'sms': sms, 'summa': summa, 'tolov_turi': tolovTuri},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UpdateExpenseModel.fromJson(response.data);
      } else {
        throw Exception('updateHarajat failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during updateHarajat: $e');
      rethrow;
    }
  }

  @override
  Future<GetCashExpenseModel> getKassa({required String tur}) async {
    try {
      final response = await dioClient.get(ApiUrls.getKassa, queryParams: {'tur': tur});
      if (response.statusCode == 200 || response.statusCode == 201) {
        return GetCashExpenseModel.fromJson(response.data);
      } else {
        throw Exception('getKassa failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during getKassa: $e');
      rethrow;
    }
  }

  @override
  Future<CreateCashExpenseModel> postKassa({
    required String doKon,
    required String izoh,
    required String mahsulotNomi,
    required bool sms,
    required num summa,
    required String tolovTuri,
  }) async {
    try {
      final response = await dioClient.post(ApiUrls.postKassa, data: {
        'do_kon': doKon, 'izoh': izoh, 'mahsulot_nomi': mahsulotNomi,
        'sms': sms, 'summa': summa, 'tolov_turi': tolovTuri,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateCashExpenseModel.fromJson(response.data);
      } else {
        throw Exception('postKassa failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during postKassa: $e');
      rethrow;
    }
  }

  @override
  Future<DeleteCashExpenseModel> deleteKassa({required int id}) async {
    try {
      final response = await dioClient.delete('${ApiUrls.deleteKassa}/$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeleteCashExpenseModel.fromJson(response.data);
      } else {
        throw Exception('deleteKassa failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during deleteKassa: $e');
      rethrow;
    }
  }

  @override
  Future<UpdateCashExpenseModel> updateKassa({
    required int id,
    required String doKon,
    required String izoh,
    required String mahsulotNomi,
    required bool sms,
    required num summa,
    required String tolovTuri,
  }) async {
    try {
      final response = await dioClient.patch('${ApiUrls.updateKassa}/$id', data: {
        'do_kon': doKon, 'izoh': izoh, 'mahsulot_nomi': mahsulotNomi,
        'sms': sms, 'summa': summa, 'tolov_turi': tolovTuri,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UpdateCashExpenseModel.fromJson(response.data);
      } else {
        throw Exception('updateKassa failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during updateKassa: $e');
      rethrow;
    }
  }

  // ===== DokonChiqim =====

  @override
  Future<List<DokonChiqimModel>> getDokonChiqim({String? tolovTuri}) async {
    try {
      final response = await dioClient.get(
        ApiUrls.getDokonChiqim,
        queryParams: tolovTuri != null ? {'tolov_turi': tolovTuri} : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final list = response.data['data'] as List<dynamic>? ?? [];
        return list.map((e) => DokonChiqimModel.fromJson(e)).toList();
      } else {
        throw Exception('getDokonChiqim failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during getDokonChiqim: $e');
      rethrow;
    }
  }

  @override
  Future<CreateDokonChiqimModel> postDokonChiqim({
    required String tolovTuri,
    required double summa,
    String? izoh,
    String? tavsif,
  }) async {
    try {
      final response = await dioClient.post(ApiUrls.postDokonChiqim, data: {
        'tolov_turi': tolovTuri,
        'summa': summa,
        if (izoh != null) 'izoh': izoh,
        if (tavsif != null) 'tavsif': tavsif,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateDokonChiqimModel.fromJson(response.data);
      } else {
        throw Exception('postDokonChiqim failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during postDokonChiqim: $e');
      rethrow;
    }
  }

  @override
  Future<CreateDokonChiqimModel> patchDokonChiqim({
    required int id,
    String? tolovTuri,
    double? summa,
    String? izoh,
    String? tavsif,
  }) async {
    try {
      final response = await dioClient.patch(
        '${ApiUrls.patchDokonChiqim}$id',
        data: {
          if (tolovTuri != null) 'tolov_turi': tolovTuri,
          if (summa != null) 'summa': summa,
          if (izoh != null) 'izoh': izoh,
          if (tavsif != null) 'tavsif': tavsif,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateDokonChiqimModel.fromJson(response.data);
      } else {
        throw Exception('patchDokonChiqim failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during patchDokonChiqim: $e');
      rethrow;
    }
  }

  @override
  Future<DeleteDokonChiqimModel> deleteDokonChiqim({required int id}) async {
    try {
      final response = await dioClient.delete('${ApiUrls.deleteDokonChiqim}$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeleteDokonChiqimModel.fromJson(response.data);
      } else {
        throw Exception('deleteDokonChiqim failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during deleteDokonChiqim: $e');
      rethrow;
    }
  }
}