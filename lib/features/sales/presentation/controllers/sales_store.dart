import 'package:flutter/foundation.dart';

class WorkerSaleEntry {
  final String productName;
  final DateTime soldAt;
  final double amountUsd;
  final String quantityText; // masalan: "2 dona", "5 metr"

  WorkerSaleEntry({
    required this.productName,
    required this.soldAt,
    required this.amountUsd,
    required this.quantityText,
  });
}

class WorkerDailySales {
  final String workerId;
  final String workerName;
  final String phone;
  final List<WorkerSaleEntry> items;

  WorkerDailySales({
    required this.workerId,
    required this.workerName,
    required this.phone,
    List<WorkerSaleEntry>? items,
  }) : items = items ?? [];

  double get totalUsd =>
      items.fold(0, (sum, e) => sum + e.amountUsd);
}

class ClosedDaySale {
  final DateTime date;
  final List<WorkerDailySales> workers;

  ClosedDaySale({
    required this.date,
    required this.workers,
  });

  double get totalUsd =>
      workers.fold(0, (sum, w) => sum + w.totalUsd);
}

class SalesStore extends ChangeNotifier {
  final List<WorkerDailySales> _todayWorkers = [];
  final List<ClosedDaySale> _closedDays = [];

  List<WorkerDailySales> get todayWorkers => List.unmodifiable(_todayWorkers);
  List<ClosedDaySale> get closedDays => List.unmodifiable(_closedDays);

  /// Demo ma'lumot (test uchun)
  void seedDemoIfEmpty() {
    if (_todayWorkers.isNotEmpty) return;

    _todayWorkers.addAll([
      WorkerDailySales(
        workerId: 'w1',
        workerName: 'Ali',
        phone: '+998 90 111 11 11',
        items: [
          WorkerSaleEntry(
            productName: '011M Turkiya',
            soldAt: DateTime.now().subtract(const Duration(hours: 3)),
            amountUsd: 1200,
            quantityText: '2 dona',
          ),
          WorkerSaleEntry(
            productName: 'Parda White',
            soldAt: DateTime.now().subtract(const Duration(hours: 1)),
            amountUsd: 800,
            quantityText: '5 metr',
          ),
        ],
      ),
      WorkerDailySales(
        workerId: 'w2',
        workerName: 'Vali',
        phone: '+998 91 222 22 22',
        items: [
          WorkerSaleEntry(
            productName: 'Blackout',
            soldAt: DateTime.now().subtract(const Duration(hours: 2)),
            amountUsd: 1500,
            quantityText: '1 pachka',
          ),
        ],
      ),
    ]);

    notifyListeners();
  }

  /// Keyin real kassa joyidan shu metod chaqiriladi
  void registerSale({
    required String workerId,
    required String workerName,
    required String phone,
    required String productName,
    required double amountUsd,
    required String quantityText,
    DateTime? soldAt,
  }) {
    final index = _todayWorkers.indexWhere((w) => w.workerId == workerId);

    final entry = WorkerSaleEntry(
      productName: productName,
      soldAt: soldAt ?? DateTime.now(),
      amountUsd: amountUsd,
      quantityText: quantityText,
    );

    if (index == -1) {
      _todayWorkers.add(
        WorkerDailySales(
          workerId: workerId,
          workerName: workerName,
          phone: phone,
          items: [entry],
        ),
      );
    } else {
      _todayWorkers[index].items.add(entry);
    }

    notifyListeners();
  }

  /// Kun oxirida bosiladi (Asosiydagi Yakunlash)
  void closeToday() {
    if (_todayWorkers.isEmpty) return;

    final now = DateTime.now();
    final dayOnly = DateTime(now.year, now.month, now.day);

    // deep copy
    final copiedWorkers = _todayWorkers.map((w) {
      return WorkerDailySales(
        workerId: w.workerId,
        workerName: w.workerName,
        phone: w.phone,
        items: w.items.map((e) {
          return WorkerSaleEntry(
            productName: e.productName,
            soldAt: e.soldAt,
            amountUsd: e.amountUsd,
            quantityText: e.quantityText,
          );
        }).toList(),
      );
    }).toList();

    // Agar bugungi sana allaqachon bo‘lsa (qayta yakunlash bosib yuborsa), ustiga qo‘shmasin:
    final sameDayIndex = _closedDays.indexWhere((d) =>
    d.date.year == dayOnly.year &&
        d.date.month == dayOnly.month &&
        d.date.day == dayOnly.day);

    if (sameDayIndex == -1) {
      _closedDays.insert(
        0,
        ClosedDaySale(date: dayOnly, workers: copiedWorkers),
      );
    } else {
      _closedDays[sameDayIndex] =
          ClosedDaySale(date: dayOnly, workers: copiedWorkers);
    }

    _todayWorkers.clear();
    notifyListeners();
  }

  WorkerDailySales? getTodayWorkerById(String workerId) {
    try {
      return _todayWorkers.firstWhere((w) => w.workerId == workerId);
    } catch (_) {
      return null;
    }
  }
}