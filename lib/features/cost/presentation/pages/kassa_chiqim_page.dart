import 'package:admin_panel/features/cost/presentation/widgets/expense_delete_dialog_wg.dart';
import 'package:admin_panel/features/cost/presentation/widgets/expense_models.dart';
import 'package:admin_panel/features/cost/presentation/widgets/kassa_expense_form_dialog_wg.dart';
import 'package:admin_panel/features/cost/presentation/widgets/kassa_models.dart';
import 'package:admin_panel/features/cost/presentation/widgets/payment_tabs_wg.dart';
import 'package:flutter/material.dart';

// Eslatma:
// ExpenseTableWg ichida "Ishchi" ustuni bor.
// Kassa chiqim rasmida "Mijoz" ustuni bor edi.
// Siz hali mijoz logikasini bermagansiz, shuning uchun hozircha jadval faqat summa/izoh fokusda.
// Agar xohlasangiz keyingi bosqichda "Mijoz" columnli alohida table ham ajratib beraman.

class KassaChiqimPage extends StatefulWidget {
  const KassaChiqimPage({super.key});

  @override
  State<KassaChiqimPage> createState() => _KassaChiqimPageState();
}

class _KassaChiqimPageState extends State<KassaChiqimPage> {
  int selectedTab = 1; // screenshotda Terminal tanlangan

  final List<KassaExpenseRowData> rows = [
    KassaExpenseRowData(
      id: 'k1',
      sana: DateTime(2026, 2, 19),
      paymentType: PaymentType.terminal,
      summa: 1000000,
      currency: CurrencyType.usd,
      izoh: "Mahsulot sotib olish",
      convertatsiya: true,
      foyda: true,
      sms: true,
    ),
    KassaExpenseRowData(
      id: 'k2',
      sana: DateTime(2026, 2, 29),
      paymentType: PaymentType.terminal,
      summa: 543000,
      currency: CurrencyType.uzs,
      izoh: "-",
      convertatsiya: false,
      foyda: false,
      sms: false,
    ),
  ];

  List<KassaExpenseRowData> get filteredRows {
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
    final result = await showDialog<KassaExpenseFormResult>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const KassaExpenseFormDialogWg(
        title: "Yangi chiqim qo’shish",
      ),
    );

    if (result == null) return;

    setState(() {
      rows.insert(
        0,
        KassaExpenseRowData(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          sana: DateTime.now(),
          paymentType: result.paymentType,
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
        SnackBar(content: Text("SMS (demo): ${formatAmount(result.summa)} ${result.currency.symbol} chiqim qilindi")),
      );
    }
  }

  Future<void> onEdit(KassaExpenseRowData row) async {
    final result = await showDialog<KassaExpenseFormResult>(
      context: context,
      barrierDismissible: true,
      builder: (_) => KassaExpenseFormDialogWg(
        title: "Chiqimni tahrirlash",
        initial: row,
      ),
    );

    if (result == null) return;

    setState(() {
      final i = rows.indexWhere((e) => e.id == row.id);
      if (i == -1) return;
      rows[i] = row.copyWith(
        paymentType: result.paymentType,
        summa: result.summa,
        currency: result.currency,
        convertatsiya: result.convertatsiya,
        foyda: result.foyda,
        sms: result.sms,
        izoh: result.izoh.trim().isEmpty ? "-" : result.izoh.trim(),
      );
    });
  }

  Future<void> onDelete(KassaExpenseRowData row) async {
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

            // Orqaga
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
                            child: Text("Kassa chiqim", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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

                      _KassaTableWg(
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

/* ===== Kassa jadval (Belgilar yo‘q) ===== */

class _KassaTableWg extends StatelessWidget {
  final List<KassaExpenseRowData> rows;
  final ValueChanged<KassaExpenseRowData> onEdit;
  final ValueChanged<KassaExpenseRowData> onDelete;

  const _KassaTableWg({
    required this.rows,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade700,
      fontSize: 12,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 900),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  SizedBox(width: 90, child: Text("Sana", style: headerStyle)),
                  SizedBox(width: 120, child: Text("To'lov turi", style: headerStyle)),
                  SizedBox(width: 140, child: Text("Summa", style: headerStyle)),
                  SizedBox(width: 90, child: Text("Valyuta", style: headerStyle)),
                  SizedBox(width: 240, child: Text("Izoh", style: headerStyle)),
                  const SizedBox(width: 70),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey.shade300),

            if (rows.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: Text("Ma'lumot yo'q", style: TextStyle(color: Colors.grey.shade600)),
              )
            else
              ...rows.map((r) => _KassaRow(
                row: r,
                onEdit: () => onEdit(r),
                onDelete: () => onDelete(r),
              )),
          ],
        ),
      ),
    );
  }
}

class _KassaRow extends StatelessWidget {
  final KassaExpenseRowData row;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _KassaRow({
    required this.row,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 90, child: Text(formatDate(row.sana), style: const TextStyle(fontSize: 12))),
              SizedBox(width: 120, child: Text(row.paymentType.label, style: const TextStyle(fontSize: 12))),
              SizedBox(width: 140, child: Text(formatAmount(row.summa), style: const TextStyle(fontSize: 12))),
              SizedBox(width: 90, child: Text(row.currency.label, style: const TextStyle(fontSize: 12))),
              SizedBox(
                width: 240,
                child: Text(row.izoh, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
              ),
              SizedBox(
                width: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _IconInk(
                      icon: Icons.edit_outlined,
                      color: const Color(0xFF1877F2),
                      onTap: onEdit,
                    ),
                    const SizedBox(width: 4),
                    _IconInk(
                      icon: Icons.delete_outline_rounded,
                      color: Colors.red,
                      onTap: onDelete,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }
}

class _IconInk extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IconInk({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}