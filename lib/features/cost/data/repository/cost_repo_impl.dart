import 'package:admin_panel/features/cost/data/datasource/cost_data_source.dart';
import 'package:admin_panel/features/cost/domain/entity/cost_entity.dart';
import 'package:admin_panel/features/cost/domain/entity/create_expense_request_model.dart';
import 'package:admin_panel/features/cost/domain/entity/expense_entity.dart';
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
}
