import 'package:admin_panel/features/monthly_selling/domain/entity/monthly_sales_entity.dart';
import 'package:admin_panel/features/monthly_selling/presentation/bloc/get_monthly_selling/get_monthly_selling_bloc.dart';
import 'package:admin_panel/features/monthly_selling/presentation/bloc/get_monthly_selling/get_monthly_selling_state.dart';
import 'package:admin_panel/features/monthly_selling/presentation/bloc/monthly_selling_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonthlySellingPage extends StatefulWidget {
  const MonthlySellingPage({super.key});

  @override
  State<MonthlySellingPage> createState() => _MonthlySellingPageState();
}

class _MonthlySellingPageState extends State<MonthlySellingPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetMonthlySellingBloc>().add(const MonthlySellingE());
  }

  String _formatDateMMDDYYYY(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    final yyyy = date.year.toString();
    return '$mm.$dd.$yyyy';
  }

  String _formatMoney(num value) {
    return '${value.toString()}\$';
  }

  DateTime _parseDate(String raw) {
    try {
      return DateTime.parse(raw);
    } catch (_) {
      return DateTime.now();
    }
  }

  List<ClosedDaySale> _mapMonthlyData(MonthlySalesEntity entity) {
    final Map<String, List<MonthlySaleEntity>> groupedByDay = {};

    for (final sale in entity.data.sotuvlar) {
      final date = _parseDate(sale.sana);
      final key =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      groupedByDay.putIfAbsent(key, () => []);
      groupedByDay[key]!.add(sale);
    }

    final List<ClosedDaySale> result = [];

    groupedByDay.forEach((key, salesOfDay) {
      final dayDate = _parseDate(salesOfDay.first.sana);

      final Map<int, List<MonthlySaleEntity>> groupedByWorker = {};
      for (final sale in salesOfDay) {
        groupedByWorker.putIfAbsent(sale.ishchiId, () => []);
        groupedByWorker[sale.ishchiId]!.add(sale);
      }

      final List<WorkerDailySales> workers = [];

      groupedByWorker.forEach((workerId, workerSales) {
        final first = workerSales.first;

        final List<ClosedWorkerSaleItem> workerItems = [];
        int workerTotal = 0;

        for (final sale in workerSales) {
          workerTotal += sale.jamiSumma;

          for (final item in sale.items) {
            workerItems.add(
              ClosedWorkerSaleItem(
                productName: item.tovarNomi,
                quantityText: _buildQuantityText(item),
                amountUsd: item.jami,
                soldAt: _parseDate(sale.sana),
              ),
            );
          }
        }

        workers.add(
          WorkerDailySales(
            workerId: first.ishchiId,
            workerName: first.ishchiFish,
            phone: '',
            totalUsd: workerTotal.toDouble(),
            items: workerItems,
          ),
        );
      });

      final totalDayAmount = salesOfDay.fold<int>(
        0,
            (sum, e) => sum + e.jamiSumma,
      );

      workers.sort((a, b) => b.totalUsd.compareTo(a.totalUsd));

      result.add(
        ClosedDaySale(
          date: dayDate,
          totalUsd: totalDayAmount.toDouble(),
          workers: workers,
        ),
      );
    });

    result.sort((a, b) => b.date.compareTo(a.date));
    return result;
  }

  String _buildQuantityText(MonthlySaleItemEntity item) {
    final parts = <String>[];

    if (item.miqdor > 0) parts.add('dona: ${item.miqdor}');
    if (item.pochka > 0) parts.add('pochka: ${item.pochka}');
    if (item.metr > 0) parts.add('metr: ${item.metr}');

    if (parts.isEmpty) return '-';
    return parts.join(' | ');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetMonthlySellingBloc, GetMonthlySellingState>(
      builder: (context, state) {
        if (state is GetMonthlySellingLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is GetMonthlySellingError) {
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 460),
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(20),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 44,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Xatolik yuz berdi",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<GetMonthlySellingBloc>()
                          .add(const MonthlySellingE());
                    },
                    child: const Text("Qayta urinish"),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is GetMonthlySellingSuccess) {
          final monthlyEntity = state.monthlySalesEntity;
          final days = _mapMonthlyData(monthlyEntity);
          final totalAmount = _formatMoney(monthlyEntity.data.jamiSumma);
          final monthLabel =
              "${monthlyEntity.data.oy.toString().padLeft(2, '0')}.${monthlyEntity.data.yil}";

          return Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 18),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<GetMonthlySellingBloc>()
                          .add(const MonthlySellingE());
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                                    "Oylik savdo",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAF4FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    monthLabel,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0B74E5),
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
                              onRowTap: (day) =>
                                  _showDayWorkersDialog(context, day),
                            ),
                            const SizedBox(height: 18),
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
                                    totalAmount,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0B74E5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Sotuvlar soni: ${monthlyEntity.data.sotuvlarSoni}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                                      child: Text(w.phone.isEmpty ? "-" : w.phone),
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
                  Text(worker.phone.isEmpty ? "-" : worker.phone),
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
                                  flex: 3,
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

class ClosedDaySale {
  final DateTime date;
  final double totalUsd;
  final List<WorkerDailySales> workers;

  const ClosedDaySale({
    required this.date,
    required this.totalUsd,
    required this.workers,
  });
}

class WorkerDailySales {
  final int workerId;
  final String workerName;
  final String phone;
  final double totalUsd;
  final List<ClosedWorkerSaleItem> items;

  const WorkerDailySales({
    required this.workerId,
    required this.workerName,
    required this.phone,
    required this.totalUsd,
    required this.items,
  });
}

class ClosedWorkerSaleItem {
  final String productName;
  final String quantityText;
  final int amountUsd;
  final DateTime soldAt;

  const ClosedWorkerSaleItem({
    required this.productName,
    required this.quantityText,
    required this.amountUsd,
    required this.soldAt,
  });
}

class _MonthlyDailyTable extends StatelessWidget {
  final List<ClosedDaySale> days;
  final String Function(DateTime) formatDate;
  final String Function(num) formatMoney;
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
              child: Text("Hali oylik savdolar yo‘q"),
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