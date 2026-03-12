import 'package:admin_panel/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/get_dashboard/get_dashboard_bloc.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/get_dashboard/get_dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetDashboardBloc>().add(GetDashboardE());
  }

  void _onWorkerTap(WorkerRow worker) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${worker.name} bo‘yicha batafsil ma’lumot API da yo‘q"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetDashboardBloc, GetDashboardState>(
      builder: (context, state) {
        if (state is GetDashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetDashboardError) {
          return Center(child: Text(state.message));
        }

        if (state is GetDashboardSuccess) {
          final data = state.dashboardDataEntity;

          final naqd = data.naqd;
          final terminal = data.terminal;
          final click = data.click;

          final workerRows = data.ishchilar.map<WorkerRow>((w) {
            return WorkerRow(
              id: w.ishchiId.toString(),
              name: w.fish,
              phone: w.telefon,
              amount: '${w.jamiSumma}\$',
            );
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 18),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                            color: Colors.black.withOpacity(0.06),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "Bugungi savdosi",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 42,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0B74E5),
                                    foregroundColor: Colors.white,
                                    shape: const StadiumBorder(),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Yakunlash uchun backend API ulanishi kerak",
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text("Yakunlash"),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _moneyCard("Naqt:", "$naqd\$"),
                              _moneyCard("Terminal:", "$terminal\$"),
                              _moneyCard("Click:", "$click\$"),
                            ],
                          ),

                          const SizedBox(height: 14),
                          const Divider(height: 1),
                          const SizedBox(height: 10),

                          _WorkersTable(
                            rows: workerRows,
                            onRowTap: _onWorkerTap,
                          ),

                          if (workerRows.isEmpty) ...[
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE5E7EB)),
                              ),
                              child: const Text(
                                "Bugungi savdo hali yo‘q",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

Widget _moneyCard(String title, String amount) {
  return Container(
    padding: const EdgeInsets.only(left: 24, right: 24),
    width: 340.w,
    height: 45.h,
    decoration: BoxDecoration(
      color: const Color(0xffF2F7FF),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.blue)),
        Text(amount, style: const TextStyle(color: Colors.blue)),
      ],
    ),
  );
}

class WorkerRow {
  final String id;
  final String name;
  final String phone;
  final String amount;

  const WorkerRow({
    required this.id,
    required this.name,
    required this.phone,
    required this.amount,
  });
}

class _WorkersTable extends StatelessWidget {
  final List<WorkerRow> rows;
  final ValueChanged<WorkerRow> onRowTap;

  const _WorkersTable({required this.rows, required this.onRowTap});

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade800,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 70, child: Text("S/N", style: headerStyle)),
              Expanded(flex: 4, child: Text("Ishchi", style: headerStyle)),
              Expanded(flex: 3, child: Text("Ishchining nomeri", style: headerStyle)),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Bugungi savdo summasi", style: headerStyle),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade300),
        ...List.generate(rows.length, (index) {
          final r = rows[index];
          final sn = (index + 1).toString().padLeft(2, '0');

          return _ClickableRow(
            onTap: () => onRowTap(r),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 70, child: Text(sn)),
                      Expanded(flex: 4, child: Text(r.name)),
                      Expanded(flex: 3, child: Text(r.phone)),
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(r.amount),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey.shade200),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _ClickableRow extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _ClickableRow({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.black.withOpacity(0.03),
        splashColor: Colors.black.withOpacity(0.05),
        child: child,
      ),
    );
  }
}