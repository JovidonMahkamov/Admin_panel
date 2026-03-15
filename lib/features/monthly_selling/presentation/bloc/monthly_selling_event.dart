abstract class MonthlySellingEvent {
  const MonthlySellingEvent();
}

class MonthlySellingE extends MonthlySellingEvent {
  const MonthlySellingE();
}

class FinishMonthlySellingE extends MonthlySellingEvent {
  final String oy;

  const FinishMonthlySellingE({required this.oy});
}