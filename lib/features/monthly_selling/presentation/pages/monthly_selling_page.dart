import 'package:admin_panel/features/sales/presentation/controllers/sales_store.dart';
import 'package:flutter/material.dart';

class MonthlySellingPage extends StatefulWidget {
  final SalesStore salesStore;

  const MonthlySellingPage({
    super.key,
    required this.salesStore,
  });

  @override
  State<MonthlySellingPage> createState() => _MonthlySellingPageState();
}

class _MonthlySellingPageState extends State<MonthlySellingPage> {
  String _formatDateMMDDYYYY(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    final yyyy = date.year.toString();
    return '$mm.$dd.$yyyy';
  }

  String _formatMoney(double value) {
    return '${value.toStringAsFixed(0)}\$';
  }

  String get _totalAmount {
    final days = widget.salesStore.closedDays;
    final total = days.fold<double>(0, (sum, d) => sum + d.totalUsd);
    return _formatMoney(total);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.salesStore,
      builder: (context, _) {
        final days = widget.salesStore.closedDays;

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
                        // TOP ROW (faqat title)
                        const Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Oylik savdo",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),
                        const Divider(height: 1),
                        const SizedBox(height: 10),

                        _MonthlyDailyTable(
                          days: days,
                          formatDate: _formatDateMMDDYYYY,
                          formatMoney: _formatMoney,
                          onRowTap: (day) => _showDayWorkersDialog(context, day),
                        ),

                        const SizedBox(height: 18),

                        // TOTAL CARD
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF4FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                "Umumiy summa:",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0B74E5),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _totalAmount,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0B74E5),
                                ),
                              ),
                            ],
                          ),
                        ),
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

  void _showDayWorkersDialog(BuildContext context, ClosedDaySale day) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Kunlik savdo (${_formatDateMMDDYYYY(day.date)})",
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  if (day.workers.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text("Bu kunda savdo yo‘q."),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: day.workers.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final w = day.workers[index];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Navigator.pop(context);
                                _showClosedWorkerItemsDialog(context, day, w);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 6,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        w.workerName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(w.phone),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          _formatMoney(w.totalUsd),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Jami: ${_formatMoney(day.totalUsd)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0B74E5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showClosedWorkerItemsDialog(
      BuildContext context,
      ClosedDaySale day,
      WorkerDailySales worker,
      ) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    worker.workerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(worker.phone),
                  const SizedBox(height: 4),
                  Text(
                    "Sana: ${_formatDateMMDDYYYY(day.date)}",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  if (worker.items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text("Savdo ma’lumoti yo‘q."),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: worker.items.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final e = worker.items[index];
                          final hh = e.soldAt.hour.toString().padLeft(2, '0');
                          final mm = e.soldAt.minute.toString().padLeft(2, '0');

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Expanded(flex: 4, child: Text(e.productName)),
                                Expanded(
                                  flex: 2,
                                  child: Text('$hh:$mm'),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(e.quantityText),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      _formatMoney(e.amountUsd),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Jami: ${_formatMoney(worker.totalUsd)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0B74E5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ===================== TABLE (kunlar bo'yicha) =====================

class _MonthlyDailyTable extends StatelessWidget {
  final List<ClosedDaySale> days;
  final String Function(DateTime) formatDate;
  final String Function(double) formatMoney;
  final ValueChanged<ClosedDaySale> onRowTap;

  const _MonthlyDailyTable({
    required this.days,
    required this.formatDate,
    required this.formatMoney,
    required this.onRowTap,
  });

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade700,
    );

    if (days.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                SizedBox(width: 70, child: Text("S/N", style: headerStyle)),
                Expanded(flex: 5, child: Text("Sana", style: headerStyle)),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text("Kunlik savdo summasi", style: headerStyle),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade300),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text("Hali yakunlangan kunlik savdolar yo‘q"),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 70, child: Text("S/N", style: headerStyle)),
              Expanded(flex: 5, child: Text("Sana", style: headerStyle)),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Kunlik savdo summasi", style: headerStyle),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade300),

        ...List.generate(days.length, (index) {
          final d = days[index];
          final sn = (index + 1).toString().padLeft(2, '0');

          return _ClickableRow(
            onTap: () => onRowTap(d),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 70, child: Text(sn)),
                      Expanded(flex: 5, child: Text(formatDate(d.date))),
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            formatMoney(d.totalUsd),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
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

  const _ClickableRow({
    required this.child,
    required this.onTap,
  });

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