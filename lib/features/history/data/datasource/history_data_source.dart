import 'package:admin_panel/features/history/data/model/History_model.dart';

abstract class HistoryDataSource {
  Future<HistoryModel> getHistory();

}