
class MonthlyHistoryItem {
  final String monthName; // "Yanvar", "Fevral"...
  final String totalAmount; // "20000$"
  final DateTime closedAt;

  const MonthlyHistoryItem({
    required this.monthName,
    required this.totalAmount,
    required this.closedAt,
  });
}

class MonthlyHistoryStore {
  static final List<MonthlyHistoryItem> items = [
    MonthlyHistoryItem(
      monthName: "Yanvar",
      totalAmount: "100000\$",
      closedAt: DateTime(2026, 1, 31),
    ),
     MonthlyHistoryItem(
      monthName: "Fevral",
      totalAmount: "103400\$",
      closedAt: DateTime(2026, 2, 28),
    ),
  ];

  static void add(MonthlyHistoryItem item) {
    items.add(item);
  }
}
