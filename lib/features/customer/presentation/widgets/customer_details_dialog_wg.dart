import 'package:flutter/material.dart';
import '../pages/customer_page.dart';

class CustomerDebtItem {
  final String productName;
  final String metr;
  final String dona;
  final String packet;
  final String debtPrice;
  final String takenTime;
  final String imageAsset;

  const CustomerDebtItem({
    required this.productName,
    required this.metr,
    required this.dona,
    required this.packet,
    required this.debtPrice,
    required this.takenTime,
    required this.imageAsset,
  });
}

class CustomerDetailsDialog extends StatelessWidget {
  final CustomerRow customer;
  final List<CustomerDebtItem> rows;

  const CustomerDetailsDialog({
    super.key,
    required this.customer,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1150, minWidth: 900),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      customer.customerName,
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

              _CustomerInfoBar(customer: customer),

              const SizedBox(height: 12),

              Flexible(
                child: SingleChildScrollView(
                  child: _DebtTable(rows: rows),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerInfoBar extends StatelessWidget {
  final CustomerRow customer;

  const _CustomerInfoBar({required this.customer});

  @override
  Widget build(BuildContext context) {
    Widget infoChip(String label, String value) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Text(
                "$label: ",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        infoChip("Telefon", customer.phone),
        const SizedBox(width: 10),
        infoChip("Manzil", customer.address),
        const SizedBox(width: 10),
        infoChip("Qarzi", customer.debt),
      ],
    );
  }
}

class _DebtTable extends StatelessWidget {
  final List<CustomerDebtItem> rows;

  const _DebtTable({required this.rows});

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
              Expanded(flex: 5, child: Text("Tovar Nomi", style: headerStyle)),
              Expanded(flex: 2, child: Text("Metr", style: headerStyle)),
              Expanded(flex: 2, child: Text("Dona", style: headerStyle)),
              Expanded(flex: 2, child: Text("Pachka", style: headerStyle)),
              Expanded(flex: 3, child: Text("Qarz summasi", style: headerStyle)),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Olingan vaqti", style: headerStyle),
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                r.imageAsset,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return Container(
                                    width: 44,
                                    height: 44,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 18,
                                      color: Colors.grey.shade600,
                                    ),
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
                      Expanded(flex: 3, child: Text(r.debtPrice)),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(r.takenTime),
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