import 'package:flutter/material.dart';

class ExpenseRowData {
  final String sana;
  final String tolovTuri;
  final String person;
  final String summa;
  final String valyuta;
  final String izoh;

  const ExpenseRowData({
    required this.sana,
    required this.tolovTuri,
    required this.person,
    required this.summa,
    required this.valyuta,
    required this.izoh,
  });
}

class PaymentTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const PaymentTabs({
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ["Naqd", "Terminal", "Click", "Barchasi"];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final selected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => onChanged(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: selected
                          ? const Color(0xFF1877F2)
                          : const Color(0xFF2D2D2D),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ExpenseTable extends StatelessWidget {
  final List<ExpenseRowData> rows;
  final String personHeader;
  final ValueChanged<ExpenseRowData> onEdit;
  final ValueChanged<ExpenseRowData> onDelete;

  const ExpenseTable({
    required this.rows,
    required this.personHeader,
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(flex: 2, child: Text("Sana", style: headerStyle)),
              Expanded(flex: 2, child: Text("To'lov turi", style: headerStyle)),
              Expanded(flex: 4, child: Text(personHeader, style: headerStyle)),
              Expanded(flex: 2, child: Text("Summa", style: headerStyle)),
              Expanded(flex: 1, child: Text("Valyuta", style: headerStyle)),
              Expanded(flex: 3, child: Text("Izoh", style: headerStyle)),
              const SizedBox(width: 56), // edit/delete iconlar uchun
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade300),

        if (rows.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              "Ma'lumot yo'q",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          )
        else
          ...List.generate(rows.length, (index) {
            final r = rows[index];

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text(r.sana, style: const TextStyle(fontSize: 12))),
                      Expanded(flex: 2, child: Text(r.tolovTuri, style: const TextStyle(fontSize: 12))),
                      Expanded(flex: 4, child: Text(r.person, style: const TextStyle(fontSize: 12))),
                      Expanded(flex: 2, child: Text(r.summa, style: const TextStyle(fontSize: 12))),
                      Expanded(flex: 1, child: Text(r.valyuta, style: const TextStyle(fontSize: 12))),
                      Expanded(flex: 3, child: Text(r.izoh, style: const TextStyle(fontSize: 12))),
                      SizedBox(
                        width: 56,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(6),
                              onTap: () => onEdit(r),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 16,
                                  color: Color(0xFF1877F2),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              borderRadius: BorderRadius.circular(6),
                              onTap: () => onDelete(r),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  size: 16,
                                  color: Colors.red,
                                ),
                              ),
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
          }),
      ],
    );
  }
}