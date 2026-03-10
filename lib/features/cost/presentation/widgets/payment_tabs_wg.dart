import 'package:flutter/material.dart';

class PaymentTabsWg extends StatelessWidget {
  final int selectedIndex; // 0-Naqd 1-Terminal 2-Click 3-Barchasi
  final ValueChanged<int> onChanged;

  const PaymentTabsWg({
    super.key,
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
                      color: selected ? const Color(0xFF1877F2) : const Color(0xFF2D2D2D),
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