import 'package:admin_panel/features/dashboard/data/model/dashboard_model.dart';

abstract class DashboardDataSource {
  Future<DashboardDataModel> getDashboard();
}