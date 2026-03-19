import '../entity/balans_entity.dart';

abstract class BalansRepository {
  Future<BalansEntity> getBalans();
}