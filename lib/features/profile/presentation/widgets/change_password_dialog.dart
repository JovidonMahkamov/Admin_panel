import 'package:admin_panel/features/profile/presentation/widgets/password_service.dart';
import 'package:flutter/material.dart';

class ChangePasswordDialog extends StatefulWidget {
  final VoidCallback onSaved;
  const ChangePasswordDialog({super.key, required this.onSaved});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _old = TextEditingController();
  final _p1 = TextEditingController();
  final _p2 = TextEditingController();

  bool o1 = true, o2 = true, o3 = true;

  String? eOld;
  String? e1;
  String? e2;

  final _service = PasswordService();

  @override
  void dispose() {
    _old.dispose();
    _p1.dispose();
    _p2.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      eOld = null;
      e1 = null;
      e2 = null;
    });

    final oldPass = _old.text.trim();
    final a = _p1.text.trim();
    final b = _p2.text.trim();

    if (oldPass.isEmpty) {
      setState(() => eOld = "Eski parolni kiriting");
      return;
    }
    if (a.length < 4) {
      setState(() => e1 = "Parol kamida 4 ta belgidan iborat bo‘lsin");
      return;
    }
    if (a != b) {
      setState(() => e2 = "Parollar mos kelmadi");
      return;
    }

    final ok = await _service.changePassword(oldPlain: oldPass, newPlain: a);
    if (!ok) {
      setState(() => eOld = "Eski parol noto‘g‘ri");
      return;
    }

    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Tizim parolini o‘zgartirish",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.red),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.red),
                  )
                ],
              ),
              Text("Parol tizimga kirishda ishlatiladi.", style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 16),

              _pass("Eski parol", _old, o1, () => setState(() => o1 = !o1), eOld),
              const SizedBox(height: 12),
              _pass("Yangi parol", _p1, o2, () => setState(() => o2 = !o2), e1),
              const SizedBox(height: 12),
              _pass("Parolni tasdiqlash", _p2, o3, () => setState(() => o3 = !o3), e2),

              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                        ),
                        child: const Text("Bekor qilish"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                        ),
                        child: const Text("Saqlash"),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _pass(String hint, TextEditingController c, bool obscure, VoidCallback onEye, String? err) {
    return TextField(
      controller: c,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        errorText: err,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: onEye,
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22)),
      ),
    );
  }
}
