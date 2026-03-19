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
  final int id;
  const DeleteHarajatE({required this.id});
}
class UpdateHarajatE extends CostEvent {
  final int id;
  final int ishchiId;
  final String izoh;
  final bool sms;
  final num summa;
  final String tolovTuri;

  const UpdateHarajatE({
    required this.id,
    required this.ishchiId,
    required this.izoh,
    required this.sms,
    required this.summa,
    required this.tolovTuri,
  });
}

class GetKassaE extends CostEvent {
  final String tur;
  const GetKassaE({required this.tur});
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
  final int id;
  const DeleteKassaE({required this.id});
}

class UpdateKassaE extends CostEvent {
  final int id;
  final String doKon;
  final String izoh;
  final String mahsulotNomi;
  final bool sms;
  final num summa;
  final String tolovTuri;

  const UpdateKassaE({
    required this.id,
    required this.doKon,
    required this.izoh,
    required this.mahsulotNomi,
    required this.sms,
    required this.summa,
    required this.tolovTuri,
  });
}
abstract class DokonChiqimEvent {
  const DokonChiqimEvent();
}

class GetDokonChiqimE extends DokonChiqimEvent {
  final String? tolovTuri;
  const GetDokonChiqimE({this.tolovTuri});
}

class PostDokonChiqimE extends DokonChiqimEvent {
  final String tolovTuri;
  final double summa;
  final String? izoh;
  final String? tavsif;

  const PostDokonChiqimE({
    required this.tolovTuri,
    required this.summa,
    this.izoh,
    this.tavsif,
  });
}

class PatchDokonChiqimE extends DokonChiqimEvent {
  final int id;
  final String? tolovTuri;
  final double? summa;
  final String? izoh;
  final String? tavsif;

  const PatchDokonChiqimE({
    required this.id,
    this.tolovTuri,
    this.summa,
    this.izoh,
    this.tavsif,
  });
}

class DeleteDokonChiqimE extends DokonChiqimEvent {
  final int id;
  const DeleteDokonChiqimE({required this.id});
}

