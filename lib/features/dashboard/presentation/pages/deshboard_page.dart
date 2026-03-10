import 'package:admin_panel/features/dashboard/presentation/widgets/worker_detail_dialog_wg.dart';
import 'package:admin_panel/features/sales/presentation/controllers/sales_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardPage extends StatefulWidget {
  final SalesStore salesStore;

  const DashboardPage({super.key, required this.salesStore});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  void _openWorkerDetails(WorkerRow worker) {
    final workerData = widget.salesStore.getTodayWorkerById(worker.id);
    if (workerData == null) return;

    final rows = workerData.items.map((e) {
      final hh = e.soldAt.hour.toString().padLeft(2, '0');
      final mm = e.soldAt.minute.toString().padLeft(2, '0');

      // quantityText dan metr/dona/pachka ajratib beramiz
      String metr = "-";
      String dona = "-";
      String packet = "-";

      final q = e.quantityText.toLowerCase().trim();
      if (q.contains('metr') || q.contains('m')) {
        metr = e.quantityText;
      } else if (q.contains('dona')) {
        dona = e.quantityText;
      } else if (q.contains('pachka') || q.contains('packet')) {
        packet = e.quantityText;
      }

      return WorkerDta(
        productName: e.productName,
        metr: metr,
        dona: dona,
        packet: packet,
        soldPrice: '${e.amountUsd.toStringAsFixed(0)}\$',
        soldTime: '$hh:$mm',
        imageAsset: 'assets/details/product.png', // sizdagi default image
      );
    }).toList();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => WorkerDetailsDialog(worker: worker, rows: rows),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.salesStore,
      builder: (context, _) {
        final todayWorkers = widget.salesStore.todayWorkers;

        final workerRows = todayWorkers.map((w) {
          return WorkerRow(
            id: w.workerId,
            name: w.workerName,
            phone: w.phone,
            amount: '${w.totalUsd.toStringAsFixed(0)}\$',
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
                                  if (widget.salesStore.todayWorkers.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Bugungi savdo bo'sh"),
                                      ),
                                    );
                                    return;
                                  }

                                  widget.salesStore.closeToday();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Bugungi savdo yakunlandi va oylik savdoga o'tdi",
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
                        SizedBox(height: 20.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsetsGeometry.only(left: 24,right: 24),
                              width: 340.w,
                              height: 45.h,
                              decoration: BoxDecoration(
                                color: Color(0xffF2F7FF),
                                borderRadius: BorderRadiusGeometry.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Naqt:",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  Text(
                                    "200\$",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsetsGeometry.only(left: 24,right: 24),
                              width: 340.w,
                              height: 45.h,
                              decoration: BoxDecoration(
                                color: Color(0xffF2F7FF),
                                borderRadius: BorderRadiusGeometry.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Terminal:",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  Text(
                                    "200\$",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsetsGeometry.only(left: 24,right: 24),
                              width: 340.w,
                              height: 45.h,
                              decoration: BoxDecoration(
                                color: Color(0xffF2F7FF),
                                borderRadius: BorderRadiusGeometry.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Click:",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  Text(
                                    "200\$",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1),
                        const SizedBox(height: 10),

                        _WorkersTable(
                          rows: workerRows,
                          onRowTap: _openWorkerDetails,
                        ),

                        if (workerRows.isEmpty) ...[
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
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
      },
    );
  }
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
        // HEADER
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 70, child: Text("S/N", style: headerStyle)),
              Expanded(flex: 4, child: Text("Ishchi", style: headerStyle)),
              Expanded(
                flex: 3,
                child: Text("Ishchining nomeri", style: headerStyle),
              ),
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

        // ROWS
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
