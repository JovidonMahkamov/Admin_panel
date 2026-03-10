import 'package:admin_panel/features/cost/presentation/widgets/expense_delete_dialog_wg.dart';
import 'package:admin_panel/features/cost/presentation/widgets/expense_form_dialog_wg.dart';
import 'package:admin_panel/features/cost/presentation/widgets/expense_models.dart';
import 'package:admin_panel/features/cost/presentation/widgets/expense_table_wg.dart';
import 'package:admin_panel/features/cost/presentation/widgets/payment_tabs_wg.dart';
import 'package:flutter/material.dart';

class HarajatChiqimPage extends StatefulWidget {
  const HarajatChiqimPage({super.key});

  @override
  State<HarajatChiqimPage> createState() => _HarajatChiqimPageState();
}

class _HarajatChiqimPageState extends State<HarajatChiqimPage> {
  int selectedTab = 0;

  final workers = const [
    WorkerOption(id: 'w1', name: "Aliyev Anvar Alisher o‘g‘li", phone: "+998901112233"),
    WorkerOption(id: 'w2', name: "Nimadur", phone: "+998909998877"),
  ];

  final List<ExpenseRowData> rows = [
    ExpenseRowData(
      id: 'e1',
      sana: DateTime(2026, 2, 19),
      paymentType: PaymentType.naqd,
      workerId: 'w1',
      workerName: "Aliyev Anvar Alisher o‘g‘li",
      workerPhone: "+998901112233",
      summa: 1000000,
      currency: CurrencyType.usd,
      izoh: "Mahsulot sotib olish",
      convertatsiya: true,
      foyda: true,
      sms: true,
    ),
  ];

  List<ExpenseRowData> get filteredRows {
    if (selectedTab == 3) return rows;
    final type = switch (selectedTab) {
      0 => PaymentType.naqd,
      1 => PaymentType.terminal,
      2 => PaymentType.click,
      _ => PaymentType.naqd,
    };
    return rows.where((e) => e.paymentType == type).toList();
  }

  Future<void> onAdd() async {
    final result = await showDialog<ExpenseFormResult>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ExpenseFormDialogWg(
        title: "Yangi chiqim qo’shish",
        workers: workers,
      ),
    );

    if (result == null) return;
    final w = workers.firstWhere((x) => x.id == result.workerId);

    setState(() {
      rows.insert(
        0,
        ExpenseRowData(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          sana: DateTime.now(),
          paymentType: result.paymentType,
          workerId: w.id,
          workerName: w.name,
          workerPhone: w.phone,
          summa: result.summa,
          currency: result.currency,
          convertatsiya: result.convertatsiya,
          foyda: result.foyda,
          sms: result.sms,
          izoh: result.izoh.trim().isEmpty ? "-" : result.izoh.trim(),
        ),
      );
    });

    if (result.sms && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("SMS (demo): ${w.name} ${formatAmount(result.summa)} ${result.currency.symbol} oldi")),
      );
    }
  }

  Future<void> onEdit(ExpenseRowData row) async {
    final result = await showDialog<ExpenseFormResult>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ExpenseFormDialogWg(
        title: "Chiqimni tahrirlash",
        workers: workers,
        initial: row,
      ),
    );

    if (result == null) return;
    final w = workers.firstWhere((x) => x.id == result.workerId);

    setState(() {
      final i = rows.indexWhere((e) => e.id == row.id);
      if (i == -1) return;
      rows[i] = row.copyWith(
        paymentType: result.paymentType,
        workerId: w.id,
        workerName: w.name,
        workerPhone: w.phone,
        summa: result.summa,
        currency: result.currency,
        convertatsiya: result.convertatsiya,
        foyda: result.foyda,
        sms: result.sms,
        izoh: result.izoh.trim().isEmpty ? "-" : result.izoh.trim(),
      );
    });
  }

  Future<void> onDelete(ExpenseRowData row) async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const ExpenseDeleteDialogWg(),
    );

    if (ok != true) return;

    setState(() {
      rows.removeWhere((e) => e.id == row.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 6),

            // orqaga
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF1877F2)),
                      SizedBox(width: 6),
                      Text("Orqaga", style: TextStyle(color: Color(0xFF1877F2), fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text("Harajat chiqim", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          ),
                          SizedBox(
                            width: 180,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: onAdd,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1877F2),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: const StadiumBorder(),
                              ),
                              child: const Text("Chiqim qo'shish"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      PaymentTabsWg(
                        selectedIndex: selectedTab,
                        onChanged: (i) => setState(() => selectedTab = i),
                      ),

                      const SizedBox(height: 14),

                      ExpenseTableWg(
                        rows: filteredRows,
                        onEdit: onEdit,
                        onDelete: onDelete,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}