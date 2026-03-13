import 'package:admin_panel/features/cost/domain/entity/cost_entity.dart';
import 'package:admin_panel/features/cost/domain/repository/cost_repo.dart';

class GetHarajatUseCase {
  final CostRepo repo;
  GetHarajatUseCase(this.repo);

  Future<CostEntity> call() => repo.getHarajatlar();
}
