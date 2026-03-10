import 'package:admin_panel/features/dashboard/presentation/pages/deshboard_page.dart';
import 'package:flutter/material.dart';

// Product savdo qatori (dialog ichidagi jadval uchun)
class WorkerDta {
  final String productName;
  final String metr;      // masalan: "50M" yoki "-"
  final String dona;      // masalan: "50" yoki "-"
  final String packet;    // masalan: "-" yoki "2"
  final String soldPrice; // masalan: "70$" yoki "500 000 sum"
  final String soldTime;  // masalan: "12:15"
  final String imageAsset; // asset path: "assets/images/product.png"

  const WorkerDta({
    required this.productName,
    required this.metr,
    required this.dona,
    required this.packet,
    required this.soldPrice,
    required this.soldTime,
    required this.imageAsset,
  });
}

class WorkerDetailsDialog extends StatelessWidget {
  final WorkerRow worker;
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
          maxWidth: 1150,   // skrinshotga o'xshash katta dialog
          minWidth: 900,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TOP BAR
              Row(
                children: [
                  Expanded(
                    child: Text(
                      worker.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.close, color: Colors.red, size: 18),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // TABLE (scroll if needed)
              Flexible(
                child: SingleChildScrollView(
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
        // HEADER
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(flex: 5, child: Text("Tovar Nomi", style: headerStyle)),
              Expanded(flex: 2, child: Text("Metr", style: headerStyle)),
              Expanded(flex: 2, child: Text("Dona", style: headerStyle)),
              Expanded(flex: 2, child: Text("Pachka", style: headerStyle)),
              Expanded(flex: 3, child: Text("Sotilgan narxi", style: headerStyle)),
              Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: Text("Sotilgan vaqti", style: headerStyle))),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade300),

        // ROWS
        ...List.generate(rows.length, (index) {
          final r = rows[index];

          return _HoverRow(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      // Product column (image + name)
                      Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                r.imageAsset,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  // agar asset topilmasa, placeholder
                                  return Container(
                                    width: 44,
                                    height: 44,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.image_not_supported, size: 18, color: Colors.grey.shade600),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                r.productName,
                                style: const TextStyle(fontWeight: FontWeight.w500),
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
