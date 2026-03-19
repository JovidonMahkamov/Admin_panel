import 'package:admin_panel/features/balans/domain/repo/balans_repo.dart';

import '../entity/balans_entity.dart';

class GetBalansUseCase {
  final BalansRepository repository;

  GetBalansUseCase(this.repository);

  Future<BalansEntity> call() => repository.getBalans();
}