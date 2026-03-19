import 'package:admin_panel/features/dashboard/domain/entity/dashboard_entity.dart';
import 'package:admin_panel/features/dashboard/domain/entity/finish_sales_entity.dart';
import 'package:admin_panel/features/dashboard/domain/entity/transfer_response_entity.dart';

import '../entity/worker_detail_entity.dart';

abstract class DashboardRepositories {
  Future<DashboardDataEntity> getDashboard();
  Future<FinishSalesEntity> finishSales();
  Future<WorkerDetailEntity> workerDetail({required String sana, required int id});
  Future<TransferResponseEntity> updateTransfer({required String dan, required String ga,required num summa});
}