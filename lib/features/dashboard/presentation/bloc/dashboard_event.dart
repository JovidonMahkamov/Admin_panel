abstract class DashboardEvent {
  const DashboardEvent();
}

class GetDashboardE extends DashboardEvent {
  const GetDashboardE();
}

class FinishSalesE extends DashboardEvent {
  const FinishSalesE();
}

class WorkerDetailE extends DashboardEvent {
  final String sana;
  final int id;
  const WorkerDetailE({required this.sana, required this.id});
}