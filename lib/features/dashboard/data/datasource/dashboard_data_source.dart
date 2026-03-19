import 'package:admin_panel/features/dashboard/data/model/dashboard_model.dart';
import 'package:admin_panel/features/dashboard/data/model/finish_sales_model.dart';
import 'package:admin_panel/features/dashboard/data/model/transfer_response_model.dart';
import 'package:admin_panel/features/dashboard/data/model/worker_detail_model.dart';

abstract class DashboardDataSource {
  Future<DashboardDataModel> getDashboard();
  Future<FinishSalesModel> finishSales();
  Future<WorkerDetailModel> workerDetail({required String sana, required int id});
  Future<TransferResponseModel> updateTransfer({required String dan, required String ga,required num summa});

}