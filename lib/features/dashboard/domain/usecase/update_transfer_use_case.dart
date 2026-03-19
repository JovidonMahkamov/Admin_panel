import 'package:admin_panel/features/dashboard/domain/entity/transfer_response_entity.dart';
import 'package:admin_panel/features/dashboard/domain/repository/dashboard_repositories.dart';

class UpdateTransferUseCase {
  final DashboardRepositories repo;
  UpdateTransferUseCase(this.repo);

  Future<TransferResponseEntity> call({required String dan, required String ga, required num summa}) => repo.updateTransfer(dan: dan, ga: ga,summa: summa);
}
