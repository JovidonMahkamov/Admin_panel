import 'package:admin_panel/features/cost/domain/entity/cost_entity.dart';
import 'package:admin_panel/features/cost/domain/entity/create_expense_request_model.dart';
import 'package:admin_panel/features/cost/domain/entity/expense_entity.dart';

abstract class CostRepo {
  Future<CostEntity> getHarajatlar();
  Future<ExpenseEntity> postHarajat({required CreateExpenseRequestModel request});
}