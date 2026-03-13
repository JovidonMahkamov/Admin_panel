import 'package:admin_panel/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/finish_sales/finish_sales_bloc.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/finish_sales/finish_sales_state.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/get_dashboard/get_dashboard_bloc.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/get_dashboard/get_dashboard_state.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/worker_detail/worker_detail_bloc.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/worker_detail/worker_detail_state.dart';
import 'package:admin_panel/features/dashboard/presentation/widgets/elvated_button_wg.dart';
import 'package:admin_panel/features/dashboard/presentation/widgets/worker_detail_dialog_wg.dart';
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
    context.read<GetDashboardBloc>().add(const GetDashboardE());
  }

  void _onFinishTap() {
    final finishState = context.read<FinishSalesBloc>().state;
    if (finishState is FinishSalesLoading) return;

    context.read<FinishSalesBloc>().add(const FinishSalesE());
  }

  void _onWorkerTap(WorkerRow worker) {
    final workerState = context.read<WorkerDetailBloc>().state;
    if (workerState is WorkerDetailLoading) return;

    final sana = _resolveSana();
    context.read<WorkerDetailBloc>().add(
      WorkerDetailE(
        sana: sana,
        id: worker.id,
      ),
    );
  }

  String _resolveSana() {
    final state = context.read<GetDashboardBloc>().state;

    if (state is GetDashboardSuccess) {
      if (state.dashboardDataEntity.sotuvlar.isNotEmpty) {
        final fullDate = state.dashboardDataEntity.sotuvlar.first.sana;
        if (fullDate.length >= 10) {
          return fullDate.substring(0, 10);
        }
      }
    }

    final now = DateTime.now();
    final y = now.year.toString();
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _formatAmount(num value) {
    return "$value\$";
  }

  void _showWorkerDetailDialog(WorkerDetailSuccess state) {
    final data = state.workerDetailEntity.data;

    final dialogWorker = WorkerDialogInfo(
      name: data.fish,
      phone: data.telefon,
      amount: "${data.jamiSumma}\$",
      sana: data.sana,
    );

    final rows = data.mahsulotlar.map((e) {
      return WorkerDta(
        productName: e.tovarNomi,
        metr: e.metr == 0 ? "-" : e.metr.toString(),
        dona: e.miqdor == 0 ? "-" : e.miqdor.toString(),
        packet: e.pochka == 0 ? "-" : e.pochka.toString(),
        soldPrice: "${e.narx}\$",
        soldTime: e.vaqt,
      );
    }).toList();

    showDialog(
      context: context,
      builder: (_) => WorkerDetailsDialog(
        worker: dialogWorker,
        rows: rows,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FinishSalesBloc, FinishSalesState>(
          listener: (context, state) {
            if (state is FinishSalesSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    state.finishSalesEntity.message.isNotEmpty
                        ? state.finishSalesEntity.message
                        : "Savdolar yakunlandi",
                  ),
                ),
              );

              context.read<GetDashboardBloc>().add(const GetDashboardE());
            }

            if (state is FinishSalesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  content: Text(state.message),
                ),
              );
            }
          },
        ),
        BlocListener<WorkerDetailBloc, WorkerDetailState>(
          listener: (context, state) {
            if (state is WorkerDetailSuccess) {
              _showWorkerDetailDialog(state);
            }

            if (state is WorkerDetailError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  content: Text(state.message),
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<GetDashboardBloc, GetDashboardState>(
        builder: (context, state) {
          final isFinishing =
          context.watch<FinishSalesBloc>().state is FinishSalesLoading;
          final isWorkerLoading =
          context.watch<WorkerDetailBloc>().state is WorkerDetailLoading;

          if (state is GetDashboardLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GetDashboardError) {
            return Center(
              child: Container(
                padding: EdgeInsets.all(20.w),
                margin: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 52.sp,
                      color: Colors.redAccent,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "Xatolik yuz berdi",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<GetDashboardBloc>().add(
                          const GetDashboardE(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B74E5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: const Text("Qayta urinish"),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is GetDashboardSuccess) {
            final data = state.dashboardDataEntity;

            final workerRows = data.ishchilar.map<WorkerRow>((w) {
              return WorkerRow(
                id: w.ishchiId,
                name: w.fish,
                phone: w.telefon,
                amount: _formatAmount(w.jamiSumma),
              );
            }).toList();

            return SizedBox.expand(
              child: Align(
                alignment: Alignment.topLeft,
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<GetDashboardBloc>().add(
                      const GetDashboardE(),
                    );
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                      top: 40,
                      left: 20,
                      right: 20,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DashboardTopBar(
                            onFinish: _onFinishTap,
                            isFinishing: isFinishing,
                          ),
                          SizedBox(height: 18.h),
                          _DashboardSummarySection(
                            naqd: _formatAmount(data.naqd),
                            terminal: _formatAmount(data.terminal),
                            click: _formatAmount(data.click),
                            jami: _formatAmount(data.jami),
                          ),
                          SizedBox(height: 20.h),
                          if (isWorkerLoading)
                            Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: LinearProgressIndicator(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                          _DashboardWorkersSection(
                            rows: workerRows,
                            onRowTap: _onWorkerTap,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _DashboardTopBar extends StatelessWidget {
  final VoidCallback onFinish;
  final bool isFinishing;

  const _DashboardTopBar({
    required this.onFinish,
    required this.isFinishing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Dashboard",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF111827),
              ),
            ),
          ),
          isFinishing
              ? SizedBox(
            width: 140.w,
            height: 46.h,
            child: ElevatedButton(
              onPressed: null,
              child: SizedBox(
                width: 18.w,
                height: 18.w,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
              : ElevatedWidget(
            onPressed: onFinish,
            text: "Yakunlash",
            backgroundColor: Colors.blue,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _DashboardSummarySection extends StatelessWidget {
  final String naqd;
  final String terminal;
  final String click;
  final String jami;

  const _DashboardSummarySection({
    required this.naqd,
    required this.terminal,
    required this.click,
    required this.jami,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bugungi savdosi",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 16.h),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 700) {
                return Column(
                  children: [
                    _MoneyCard(title: "Naqd", amount: naqd),
                    SizedBox(height: 12.h),
                    _MoneyCard(title: "Terminal", amount: terminal),
                    SizedBox(height: 12.h),
                    _MoneyCard(title: "Click", amount: click),
                    SizedBox(height: 12.h),
                    _MoneyCard(
                      title: "Jami",
                      amount: jami,
                      isPrimary: true,
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: _MoneyCard(title: "Naqd", amount: naqd)),
                  SizedBox(width: 12.w),
                  Expanded(child: _MoneyCard(title: "Terminal", amount: terminal)),
                  SizedBox(width: 12.w),
                  Expanded(child: _MoneyCard(title: "Click", amount: click)),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _MoneyCard(
                      title: "Jami",
                      amount: jami,
                      isPrimary: true,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MoneyCard extends StatelessWidget {
  final String title;
  final String amount;
  final bool isPrimary;

  const _MoneyCard({
    required this.title,
    required this.amount,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
    isPrimary ? const Color(0xFF0B74E5) : const Color(0xFFF2F7FF);

    final textColor = isPrimary ? Colors.white : const Color(0xFF0B74E5);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 10.w),
          Flexible(
            child: Text(
              amount,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: textColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class WorkerRow {
  final int id;
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

class _DashboardWorkersSection extends StatelessWidget {
  final List<WorkerRow> rows;
  final ValueChanged<WorkerRow> onRowTap;

  const _DashboardWorkersSection({
    required this.rows,
    required this.onRowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ishchilar bo‘yicha savdo",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 16.h),
          if (rows.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 48.sp,
                    color: Colors.grey.shade500,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Bugungi savdo hali yo‘q",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 800) {
                  return Column(
                    children: rows
                        .map(
                          (worker) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _WorkerMobileCard(
                          worker: worker,
                          onTap: () => onRowTap(worker),
                        ),
                      ),
                    )
                        .toList(),
                  );
                }

                return _WorkersTable(
                  rows: rows,
                  onRowTap: onRowTap,
                );
              },
            ),
        ],
      ),
    );
  }
}

class _WorkersTable extends StatelessWidget {
  final List<WorkerRow> rows;
  final ValueChanged<WorkerRow> onRowTap;

  const _WorkersTable({
    required this.rows,
    required this.onRowTap,
  });

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 14.sp,
      color: Colors.grey.shade800,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 60.w,
                  child: Text("S/N", style: headerStyle),
                ),
                Expanded(
                  flex: 3,
                  child: Text("Ishchi", style: headerStyle),
                ),
                Expanded(
                  flex: 3,
                  child: Text("Telefon", style: headerStyle),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text("Summa", style: headerStyle),
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(rows.length, (index) {
            final worker = rows[index];
            final sn = (index + 1).toString().padLeft(2, '0');
            final isLast = index == rows.length - 1;

            return _ClickableRow(
              onTap: () => onRowTap(worker),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : Border(
                    top: BorderSide(
                      color: const Color(0xFFE5E7EB),
                      width: 1.w,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60.w,
                      child: Text(
                        sn,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        worker.name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF111827),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        worker.phone,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          worker.amount,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0B74E5),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _WorkerMobileCard extends StatelessWidget {
  final WorkerRow worker;
  final VoidCallback onTap;

  const _WorkerMobileCard({
    required this.worker,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _ClickableRow(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              worker.name,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              worker.phone,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3FF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                worker.amount,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0B74E5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClickableRow extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _ClickableRow({
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        hoverColor: Colors.black.withOpacity(0.03),
        splashColor: Colors.black.withOpacity(0.05),
        child: child,
      ),
    );
  }
}