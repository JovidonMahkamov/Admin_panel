import 'package:admin_panel/features/cost/domain/entity/create_expense_request_model.dart';
import 'package:admin_panel/features/cost/domain/entity/expense_entity.dart';
import 'package:admin_panel/features/cost/domain/repository/cost_repo.dart';

class PostHarajatUseCase {
  final CostRepo repo;
  PostHarajatUseCase(this.repo);

  Future<ExpenseEntity> call({required CreateExpenseRequestModel request}) => repo.postHarajat(request: request);
}
