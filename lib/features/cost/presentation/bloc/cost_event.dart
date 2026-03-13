import 'package:admin_panel/features/cost/domain/entity/create_expense_request_model.dart';

abstract class CostEvent {
  const CostEvent();
}

class GetHarajatE extends CostEvent {
  const GetHarajatE();
}

class PostHarajatE extends CostEvent {
  final CreateExpenseRequestModel request;

  const PostHarajatE({required this.request});}

