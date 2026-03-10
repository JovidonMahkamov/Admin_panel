

import 'package:flutter/material.dart';

import 'expense_models.dart';

class ExpenseTableWg extends StatelessWidget {
  final List<ExpenseRowData> rows;
  final ValueChanged<ExpenseRowData> onEdit;
  final ValueChanged<ExpenseRowData> onDelete;

  const ExpenseTableWg({
    super.key,
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
        constraints: const BoxConstraints(minWidth: 1050),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  SizedBox(width: 90, child: Text("Sana", style: headerStyle)),
                  SizedBox(width: 120, child: Text("To'lov turi", style: headerStyle)),
                  SizedBox(width: 250, child: Text("Ishchi", style: headerStyle)),
                  SizedBox(width: 140, child: Text("Summa", style: headerStyle)),
                  SizedBox(width: 90, child: Text("Valyuta", style: headerStyle)),
                  SizedBox(width: 190, child: Text("Izoh", style: headerStyle)),
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
              ...rows.map((r) => _ExpenseRow(
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

class _ExpenseRow extends StatelessWidget {
  final ExpenseRowData row;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ExpenseRow({
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
              SizedBox(
                width: 250,
                child: Text(
                  row.workerName,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 140, child: Text(formatAmount(row.summa), style: const TextStyle(fontSize: 12))),
              SizedBox(width: 90, child: Text(row.currency.label, style: const TextStyle(fontSize: 12))),
              SizedBox(
                width: 190,
                child: Text(
                  row.izoh,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
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