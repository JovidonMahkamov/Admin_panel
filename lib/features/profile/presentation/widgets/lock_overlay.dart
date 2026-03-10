import 'package:admin_panel/features/profile/presentation/widgets/lock_controller.dart';
import 'package:flutter/material.dart';

class LockOverlay extends StatefulWidget {
  final LockController lock;
  const LockOverlay({super.key, required this.lock});

  @override
  State<LockOverlay> createState() => _LockOverlayState();
}

class _LockOverlayState extends State<LockOverlay> {
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  String? _errorText;
  bool _busy = false;

  @override
  void dispose() {
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.black.withOpacity(0.45),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: AnimatedBuilder(
                animation: widget.lock,
                builder: (context, _) {
                  return FutureBuilder<DateTime?>(
                    future: widget.lock.lockedUntil(),
                    builder: (context, snap) {
                      final until = snap.data;
                      final locked = until != null;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tizimga kirish",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            locked
                                ? "Ko‘p xato kiritildi. Qayta urinish: ${_fmtTime(until)}"
                                : "Davom etish uchun parolni kiriting",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 18),

                          TextField(
                            controller: _passCtrl,
                            obscureText: _obscure,
                            enabled: !locked && !_busy,
                            decoration: InputDecoration(
                              hintText: "Parolni kiriting",
                              prefixIcon: const Icon(Icons.lock_outline),
                              errorText: _errorText,
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => _obscure = !_obscure),
                                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onSubmitted: (_) => _tryUnlock(locked),
                          ),

                          const SizedBox(height: 14),

                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: locked || _busy ? null : () => _tryUnlock(false),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: _busy
                                  ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                                  : const Text("Kirish"),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _fmtTime(DateTime? dt) {
    if (dt == null) return "-";
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return "${dt.hour}:$m:$s";
  }

  Future<void> _tryUnlock(bool locked) async {
    if (locked) return;

    final pass = _passCtrl.text.trim();
    if (pass.isEmpty) {
      setState(() => _errorText = "Parolni kiriting");
      return;
    }

    setState(() {
      _busy = true;
      _errorText = null;
    });

    final ok = await widget.lock.unlockWithPassword(pass);

    setState(() => _busy = false);

    if (!ok) {
      setState(() => _errorText = "Parol noto‘g‘ri");
    } else {
      _passCtrl.clear();
      setState(() => _errorText = null);
    }
  }
}
