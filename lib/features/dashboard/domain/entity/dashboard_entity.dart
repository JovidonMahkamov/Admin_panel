class DashboardEntity {
  final String message;
  final DashboardDataEntity data;
  final int status;

  DashboardEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}

class DashboardDataEntity {
  final int naqd;
  final int terminal;
  final int click;
  final int jami;
  final List<dynamic> ishchilar;
  final List<dynamic> sotuvlar;

  DashboardDataEntity({
    required this.naqd,
    required this.terminal,
    required this.click,
    required this.jami,
    required this.ishchilar,
    required this.sotuvlar,
  });
}