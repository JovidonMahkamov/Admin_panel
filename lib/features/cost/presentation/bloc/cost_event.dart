import 'package:admin_panel/features/cost/domain/entity/create_expense_request_model.dart';

abstract class CostEvent {
  const CostEvent();
}

class GetHarajatE extends CostEvent {
  const GetHarajatE();
}

class PostHarajatE extends CostEvent {
  final CreateExpenseRequestModel request;

  const PostHarajatE({required this.request});
}

class DeleteHarajatE extends CostEvent {
  const DeleteHarajatE({required int id});
}

class UpdateHarajatE extends CostEvent {
  const UpdateHarajatE({
    required int id,
    required int ishchiId,
    required String izoh,
    required bool sms,
    required num summa,
    required String tolovTuri,
  });
}

class GetKassaE extends CostEvent {
  const GetKassaE({required String tur});
}


class PostKassaE extends CostEvent {
  final String doKon;
  final String izoh;
  final String mahsulotNomi;
  final bool sms;
  final num summa;
  final String tolovTuri;

  PostKassaE({
    required this.doKon,
    required this.izoh,
    required this.mahsulotNomi,
    required this.sms,
    required this.summa,
    required this.tolovTuri,
  });
}

class DeleteKassaE extends CostEvent {
  const DeleteKassaE({required int id});
}

class UpdateKassaE extends CostEvent {
  const UpdateKassaE({
    required int id,
    required String doKon,
    required String izoh,
    required String mahsulotNomi,
    required bool sms,
    required num summa,
    required String tolovTuri,
  });
}

