import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'security_keys.dart';

class PasswordService {
  Future<bool> hasPassword() async {
    final sp = await SharedPreferences.getInstance();
    return (sp.getString(SecurityKeys.passHash) ?? '').isNotEmpty &&
        (sp.getString(SecurityKeys.passSalt) ?? '').isNotEmpty;
  }

  Future<void> setPassword(String plain) async {
    final sp = await SharedPreferences.getInstance();
    final salt = _randomSalt(16);
    final hash = _hash(plain, salt);

    await sp.setString(SecurityKeys.passSalt, salt);
    await sp.setString(SecurityKeys.passHash, hash);

    // reset lock info
    await sp.setInt(SecurityKeys.failCount, 0);
    await sp.setInt(SecurityKeys.lockUntil, 0);
  }

  Future<bool> verifyPassword(String plain) async {
    final sp = await SharedPreferences.getInstance();
    final salt = sp.getString(SecurityKeys.passSalt) ?? '';
    final savedHash = sp.getString(SecurityKeys.passHash) ?? '';
    if (salt.isEmpty || savedHash.isEmpty) return true; // parol o‘rnatilmagan bo‘lsa "true"

    final hash = _hash(plain, salt);
    return hash == savedHash;
  }

  Future<bool> changePassword({
    required String oldPlain,
    required String newPlain,
  }) async {
    final ok = await verifyPassword(oldPlain);
    if (!ok) return false;
    await setPassword(newPlain);
    return true;
  }

  String _randomSalt(int len) {
    final r = Random.secure();
    final bytes = List<int>.generate(len, (_) => r.nextInt(256));
    return base64UrlEncode(bytes);
  }

  String _hash(String plain, String salt) {
    final bytes = utf8.encode('$salt::$plain');
    return sha256.convert(bytes).toString();
  }
}
