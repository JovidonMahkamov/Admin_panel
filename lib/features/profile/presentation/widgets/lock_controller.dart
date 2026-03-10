import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'password_service.dart';
import 'security_keys.dart';

class LockController extends ChangeNotifier {
  final PasswordService _pass = PasswordService();

  bool initialized = false;
  bool isLocked = false;

  // inactivity
  Timer? _idleTimer;
  final Duration idleDuration;

  LockController({this.idleDuration = const Duration(minutes: 3)});

  Future<void> init() async {
    final has = await _pass.hasPassword();
    isLocked = has;
    initialized = true;
    notifyListeners();

    _startIdleTimer();
  }

  void recordActivity() {
    if (!initialized) return;
    _startIdleTimer();
  }

  void _startIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(idleDuration, () async {
      final has = await _pass.hasPassword();
      if (has) {
        isLocked = true;
        notifyListeners();
      }
    });
  }

  Future<DateTime?> lockedUntil() async {
    final sp = await SharedPreferences.getInstance();
    final ms = sp.getInt(SecurityKeys.lockUntil) ?? 0;
    if (ms <= 0) return null;
    final until = DateTime.fromMillisecondsSinceEpoch(ms);
    if (DateTime.now().isAfter(until)) return null;
    return until;
  }

  Future<int> failCount() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(SecurityKeys.failCount) ?? 0;
  }

  Future<bool> unlockWithPassword(String plain) async {
    final until = await lockedUntil();
    if (until != null) return false;

    final ok = await _pass.verifyPassword(plain);

    final sp = await SharedPreferences.getInstance();
    if (ok) {
      await sp.setInt(SecurityKeys.failCount, 0);
      await sp.setInt(SecurityKeys.lockUntil, 0);
      isLocked = false;
      notifyListeners();
      _startIdleTimer();
      return true;
    } else {
      final c = (sp.getInt(SecurityKeys.failCount) ?? 0) + 1;
      await sp.setInt(SecurityKeys.failCount, c);

      if (c >= 5) {
        final untilMs = DateTime.now()
            .add(const Duration(minutes: 5))
            .millisecondsSinceEpoch;
        await sp.setInt(SecurityKeys.lockUntil, untilMs);
      }
      notifyListeners();
      return false;
    }

  }

  void lockNow() async {
    final has = await _pass.hasPassword();
    if (!has) return;
    isLocked = true;
    notifyListeners();
  }
}
