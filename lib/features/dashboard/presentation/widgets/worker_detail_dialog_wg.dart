import 'package:flutter/material.dart';

class WorkerDialogInfo {
  final String name;
  final String phone;
  final String amount;
  final String sana;

  const WorkerDialogInfo({
    required this.name,
    required this.phone,
    required this.amount,
    required this.sana,
  });
}

class WorkerDta {
  final String productName;
  final String metr;
  final String dona;
  final String packet;
  final String soldPrice;
  final String soldTime;

  const WorkerDta({
    required this.productName,
    required this.metr,
    required this.dona,
    required this.packet,
    required this.soldPrice,
    required this.soldTime,
  });
}

class WorkerDetailsDialog extends StatelessWidget {
  final WorkerDialogInfo worker;
  final List<WorkerDta> rows;

  const WorkerDetailsDialog({
    super.key,
    required this.worker,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1150,
          minWidth: 900,
          maxHeight: 700,
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                runSpacing: 12,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        worker.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        worker.phone,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Sana: ${worker.sana}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF3FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          worker.amount,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0B74E5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.close, color: Colors.red, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: rows.isEmpty
                    ? Center(
                  child: Text(
                    "Bu ishchi bo‘yicha mahsulot topilmadi",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                    : SingleChildScrollView(
                  child: _SalesTable(rows: rows),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SalesTable extends StatelessWidget {
  final List<WorkerDta> rows;

  const _SalesTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 12.5,
      color: Colors.grey.shade700,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(flex: 5, child: Text("Tovar nomi", style: headerStyle)),
              Expanded(flex: 2, child: Text("Metr", style: headerStyle)),
              Expanded(flex: 2, child: Text("Dona", style: headerStyle)),
              Expanded(flex: 2, child: Text("Pachka", style: headerStyle)),
              Expanded(flex: 3, child: Text("Narx", style: headerStyle)),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Vaqt", style: headerStyle),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade300),
        ...List.generate(rows.length, (index) {
          final r = rows[index];

          return _HoverRow(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.inventory_2_outlined,
                                color: Colors.grey.shade600,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                r.productName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(flex: 2, child: Text(r.metr)),
                      Expanded(flex: 2, child: Text(r.dona)),
                      Expanded(flex: 2, child: Text(r.packet)),
                      Expanded(flex: 3, child: Text(r.soldPrice)),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(r.soldTime),
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

class _HoverRow extends StatelessWidget {
  final Widget child;

  const _HoverRow({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        hoverColor: Colors.black.withOpacity(0.03),
        splashColor: Colors.black.withOpacity(0.04),
        child: child,
      ),
    );
  }
}