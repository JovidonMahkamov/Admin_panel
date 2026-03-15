import 'package:admin_panel/core/networks/api_urls.dart';
import 'package:admin_panel/core/networks/dio_client.dart';
import 'package:admin_panel/core/utils/logger.dart';
import 'package:admin_panel/features/cost/data/datasource/cost_data_source.dart';
import 'package:admin_panel/features/cost/data/model/cost_model.dart';
import 'package:admin_panel/features/cost/data/model/create_cash_expense_model.dart';
import 'package:admin_panel/features/cost/data/model/delete_cash_expense_model.dart';
import 'package:admin_panel/features/cost/data/model/delete_expense_model.dart';
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
        LoggerService.info('getHarajatlar successful: ${response.data}');
        return CostModel.fromJson(response.data);
      } else {
        LoggerService.warning('getHarajatlar failed: ${response.statusCode}');
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
      final response = await dioClient.post(
        ApiUrls.postHarajat,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('postHarajat successful: ${response.data}');
        return ExpenseResponseModel.fromJson(response.data);
      } else {
        LoggerService.warning('postHarajat failed: ${response.statusCode}');
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
      final response = await dioClient.delete("${ApiUrls.deleteHarajat}/$id");
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return DeleteExpenseModel.fromJson(response.data);
      } else {
        LoggerService.warning("statistics failed:${response.statusCode}");
        throw Exception('statistics failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during user statistics: $e');
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
        "${ApiUrls.updateHarajat}/$id",
        data: {
          "ishchi_id": ishchiId,
          "izoh": izoh,
          "sms": sms,
          "summa": summa,
          "tolov_turi": tolovTuri,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return UpdateExpenseModel.fromJson(response.data);
      } else {
        LoggerService.warning("statistics failed:${response.statusCode}");
        throw Exception('statistics failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during user statistics: $e');
      rethrow;
    }
  }

  @override
  Future<GetCashExpenseModel> getKassa({required String tur}) async {
    try {
      final response = await dioClient.get(
        ApiUrls.getKassa,
        queryParams: {"tur": tur},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return GetCashExpenseModel.fromJson(response.data);
      } else {
        LoggerService.warning("statistics failed:${response.statusCode}");
        throw Exception('statistics failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during user statistics: $e');
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
      final response = await dioClient.post(
        ApiUrls.postKassa,
        data: {"do_kon": doKon, "izoh": izoh, "mahsulot_nomi": mahsulotNomi, "sms": sms, "summa": summa, "tolov_turi": tolovTuri},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return CreateCashExpenseModel.fromJson(response.data);
      } else {
        LoggerService.warning("statistics failed:${response.statusCode}");
        throw Exception('statistics failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during user statistics: $e');
      rethrow;
    }
  }

  @override
  Future<DeleteCashExpenseModel> deleteKassa({required int id}) async{
    try {
      final response = await dioClient.delete("${ApiUrls.deleteKassa}/$id");
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return DeleteCashExpenseModel.fromJson(response.data);
      } else {
        LoggerService.warning("statistics failed:${response.statusCode}");
        throw Exception('statistics failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during user statistics: $e');
      rethrow;
    }
  }

  @override
  Future<UpdateCashExpenseModel> updateKassa({required int id, required String doKon, required String izoh, required String mahsulotNomi, required bool sms, required num summa, required String tolovTuri}) async{
    try {
      final response = await dioClient.patch(
        "${ApiUrls.updateKassa}/$id",
        data: {
          "kassa_id ": id,
          "do_kon": doKon,
          "izoh": izoh,
          "mahsulot_nomi": mahsulotNomi,
          "sms": sms,
          "summa": summa,
          "tolov_turi": tolovTuri,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('statistics successful: ${response.data}');
        return UpdateCashExpenseModel.fromJson(response.data);
      } else {
        LoggerService.warning("statistics failed:${response.statusCode}");
        throw Exception('statistics failed: ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error during user statistics: $e');
      rethrow;
    }
  }
}
