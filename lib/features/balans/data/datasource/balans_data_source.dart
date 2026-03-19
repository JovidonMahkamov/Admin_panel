import '../model/balans_model.dart';

abstract class BalansDataSource {
  Future<BalansModel> getBalans();
}