import 'package:admin_panel/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/finish_sales/finish_sales_bloc.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/finish_sales/finish_sales_state.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/get_dashboard/get_dashboard_bloc.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/get_dashboard/get_dashboard_state.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/update_transfer/update_transfer_bloc.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/update_transfer/update_transfer_state.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/worker_detail/worker_detail_bloc.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/worker_detail/worker_detail_state.dart';
import 'package:admin_panel/features/dashboard/presentation/widgets/elvated_button_wg.dart';
import 'package:admin_panel/features/dashboard/presentation/widgets/worker_detail_dialog_wg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      WorkerDetailE(sana: sana, id: worker.id),
    );
  }

  String _resolveSana() {
    final state = context.read<GetDashboardBloc>().state;
    if (state is GetDashboardSuccess) {
      if (state.dashboardDataEntity.sotuvlar.isNotEmpty) {
        final fullDate = state.dashboardDataEntity.sotuvlar.first.sana;
        if (fullDate.length >= 10) return fullDate.substring(0, 10);
      }
    }
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String _formatAmount(num value) => "$value\$";

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
      builder: (_) => WorkerDetailsDialog(worker: dialogWorker, rows: rows),
    );
  }

  // ===== TO'LOV TURINI O'ZGARTIRISH DIALOGI =====
  void _showTransferDialog({
    required String dan,
    required num currentAmount,
  }) {
    final tolovTurlari = ['naqd', 'terminal', 'click'];
    String selectedGa = tolovTurlari.firstWhere((t) => t != dan);
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Icon(Icons.swap_horiz_rounded,
                      color: Color(0xFF0B74E5)),
                  const SizedBox(width: 10),
                  Text(
                    "${_label(dan)} → ko'chirish",
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mavjud: ${currentAmount.toStringAsFixed(2)}\$",
                    style: TextStyle(
                        color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  const Text("Summa kiriting:",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d*')),
                    ],
                    decoration: InputDecoration(
                      hintText: "0.00",
                      suffixText: "\$",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text("Ko'chirish turi:",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: tolovTurlari
                        .where((t) => t != dan)
                        .map((t) => ChoiceChip(
                      label: Text(_label(t)),
                      selected: selectedGa == t,
                      selectedColor:
                      const Color(0xFF0B74E5).withOpacity(0.15),
                      onSelected: (_) =>
                          setModalState(() => selectedGa = t),
                    ))
                        .toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Bekor qilish",
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final summa = num.tryParse(controller.text);
                    if (summa == null || summa <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("To'g'ri summa kiriting")),
                      );
                      return;
                    }
                    Navigator.pop(ctx);
                    context.read<UpdateTransferBloc>().add(
                      UpdateTransferE(
                          dan: dan, ga: selectedGa, summa: summa),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B74E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Ko'chirish"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _label(String key) {
    switch (key) {
      case 'naqd':
        return 'Naqd';
      case 'terminal':
        return 'Terminal';
      case 'click':
        return 'Click';
      default:
        return key;
    }
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
            if (state is WorkerDetailSuccess) _showWorkerDetailDialog(state);
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
        // ===== TRANSFER LISTENER =====
        BlocListener<UpdateTransferBloc, UpdateTransferState>(
          listener: (context, state) {
            if (state is UpdateTransferSuccess) {
              context.read<GetDashboardBloc>().add(const GetDashboardE());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                  content: Text("To'lov turi muvaffaqiyatli o'zgartirildi"),
                ),
              );
            }
            if (state is UpdateTransferError) {
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
          final isTransferLoading =
          context.watch<UpdateTransferBloc>().state is UpdateTransferLoading;

          if (state is GetDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
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
                    Icon(Icons.error_outline_rounded,
                        size: 52.sp, color: Colors.redAccent),
                    SizedBox(height: 12.h),
                    Text("Xatolik yuz berdi",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8.h),
                    Text(state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp, color: Colors.grey.shade700)),
                    SizedBox(height: 18.h),
                    ElevatedButton(
                      onPressed: () => context
                          .read<GetDashboardBloc>()
                          .add(const GetDashboardE()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B74E5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r)),
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
                    context
                        .read<GetDashboardBloc>()
                        .add(const GetDashboardE());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                        top: 40, left: 20, right: 20, bottom: 20),
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

                          // ===== SUMMARY (bosish mumkin) =====
                          _DashboardSummarySection(
                            naqd: data.naqd,
                            terminal: data.terminal,
                            click: data.click,
                            jami: data.jami,
                            isTransferLoading: isTransferLoading,
                            onCardTap: (tolovTuri, amount) {
                              _showTransferDialog(
                                dan: tolovTuri,
                                currentAmount: amount,
                              );
                            },
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

// ===== TOP BAR =====

class _DashboardTopBar extends StatelessWidget {
  final VoidCallback onFinish;
  final bool isFinishing;

  const _DashboardTopBar({required this.onFinish, required this.isFinishing});

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
                  color: const Color(0xFF111827)),
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
                child:
                const CircularProgressIndicator(strokeWidth: 2),
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

// ===== SUMMARY SECTION (bosiladigan kartochkalar) =====

class _DashboardSummarySection extends StatelessWidget {
  final num naqd;
  final num terminal;
  final num click;
  final num jami;
  final bool isTransferLoading;
  final void Function(String tolovTuri, num amount) onCardTap;

  const _DashboardSummarySection({
    required this.naqd,
    required this.terminal,
    required this.click,
    required this.jami,
    required this.isTransferLoading,
    required this.onCardTap,
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
          Row(
            children: [
              Text(
                "Bugungi savdosi",
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827)),
              ),
              if (isTransferLoading) ...[
                const SizedBox(width: 12),
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            "To'lov turini o'zgartirish uchun kartochkani bosing",
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
          ),
          SizedBox(height: 14.h),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 700) {
                return Column(
                  children: [
                    _TappableMoneyCard(
                      title: "Naqd",
                      amount: naqd,
                      onTap: () => onCardTap('naqd', naqd),
                    ),
                    SizedBox(height: 12.h),
                    _TappableMoneyCard(
                      title: "Terminal",
                      amount: terminal,
                      onTap: () => onCardTap('terminal', terminal),
                    ),
                    SizedBox(height: 12.h),
                    _TappableMoneyCard(
                      title: "Click",
                      amount: click,
                      onTap: () => onCardTap('click', click),
                    ),
                    SizedBox(height: 12.h),
                    _MoneyCard(
                      title: "Jami",
                      amount: "$jami\$",
                      isPrimary: true,
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: _TappableMoneyCard(
                      title: "Naqd",
                      amount: naqd,
                      onTap: () => onCardTap('naqd', naqd),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _TappableMoneyCard(
                      title: "Terminal",
                      amount: terminal,
                      onTap: () => onCardTap('terminal', terminal),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _TappableMoneyCard(
                      title: "Click",
                      amount: click,
                      onTap: () => onCardTap('click', click),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _MoneyCard(
                      title: "Jami",
                      amount: "$jami\$",
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

// ===== BOSILADIGAN KARTOCHKA (naqd, terminal, click) =====

class _TappableMoneyCard extends StatelessWidget {
  final String title;
  final num amount;
  final VoidCallback onTap;

  const _TappableMoneyCard({
    required this.title,
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF2F7FF),
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        hoverColor: const Color(0xFF0B74E5).withOpacity(0.08),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
                color: const Color(0xFF0B74E5).withOpacity(0.15), width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: const Color(0xFF0B74E5),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "$amount\$",
                      style: TextStyle(
                        color: const Color(0xFF0B74E5),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.swap_horiz_rounded,
                color: const Color(0xFF0B74E5).withOpacity(0.5),
                size: 18.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== ODDIY KARTOCHKA (Jami uchun) =====

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
                  fontWeight: FontWeight.w600),
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
                  fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ===== WORKERS =====

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
            "Ishchilar bo'yicha savdo",
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827)),
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
                  Icon(Icons.inventory_2_outlined,
                      size: 48.sp, color: Colors.grey.shade500),
                  SizedBox(height: 10.h),
                  Text(
                    "Bugungi savdo hali yo'q",
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700),
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
                        .map((worker) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _WorkerMobileCard(
                        worker: worker,
                        onTap: () => onRowTap(worker),
                      ),
                    ))
                        .toList(),
                  );
                }
                return _WorkersTable(rows: rows, onRowTap: onRowTap);
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

  const _WorkersTable({required this.rows, required this.onRowTap});

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14.sp,
        color: Colors.grey.shade800);

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
                SizedBox(width: 60.w, child: Text("S/N", style: headerStyle)),
                Expanded(flex: 3, child: Text("Ishchi", style: headerStyle)),
                Expanded(flex: 3, child: Text("Telefon", style: headerStyle)),
                Expanded(
                    flex: 2,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text("Summa", style: headerStyle))),
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
                          color: const Color(0xFFE5E7EB), width: 1.w)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                        width: 60.w,
                        child: Text(sn,
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF111827)))),
                    Expanded(
                        flex: 3,
                        child: Text(worker.name,
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF111827),
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis)),
                    Expanded(
                        flex: 3,
                        child: Text(worker.phone,
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade700),
                            overflow: TextOverflow.ellipsis)),
                    Expanded(
                        flex: 2,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(worker.amount,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0B74E5)),
                                overflow: TextOverflow.ellipsis))),
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

  const _WorkerMobileCard({required this.worker, required this.onTap});

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
            Text(worker.name,
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827))),
            SizedBox(height: 8.h),
            Text(worker.phone,
                style:
                TextStyle(fontSize: 13.sp, color: Colors.grey.shade700)),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3FF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(worker.amount,
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0B74E5))),
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

  const _ClickableRow({required this.child, required this.onTap});

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