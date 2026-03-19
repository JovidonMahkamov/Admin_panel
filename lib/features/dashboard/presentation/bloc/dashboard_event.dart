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

class UpdateTransferE extends DashboardEvent {
  final String dan;
  final String ga;
  final num summa;
  const UpdateTransferE({required this.dan, required this.ga,required this.summa});
}