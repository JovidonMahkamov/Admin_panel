import 'package:admin_panel/features/cost/data/model/cost_model.dart';
import 'package:admin_panel/features/cost/data/model/expense_response_model.dart';
import 'package:admin_panel/features/cost/domain/entity/create_expense_request_model.dart';

abstract class CostDataSource {
  Future<CostModel> getHarajatlar();
  Future<ExpenseResponseModel> postHarajat({required CreateExpenseRequestModel request});

}