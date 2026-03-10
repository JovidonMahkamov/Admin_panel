import 'package:admin_panel/features/profile/presentation/widgets/password_service.dart';
import 'package:flutter/material.dart';

class SetPasswordDialog extends StatefulWidget {
  final VoidCallback onSaved;
  const SetPasswordDialog({super.key, required this.onSaved});

  @override
  State<SetPasswordDialog> createState() => _SetPasswordDialogState();
}

class _SetPasswordDialogState extends State<SetPasswordDialog> {
  final _p1 = TextEditingController();
  final _p2 = TextEditingController();
  bool _o1 = true, _o2 = true;

  String? err1;
  String? err2;

  final _service = PasswordService();

  @override
  void dispose() {
    _p1.dispose();
    _p2.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final a = _p1.text.trim();
    final b = _p2.text.trim();

    setState(() {
      err1 = null;
      err2 = null;
    });

    if (a.length < 4) {
      setState(() => err1 = "Parol kamida 4 ta belgidan iborat bo‘lishi kerak");
      return;
    }
    if (a != b) {
      setState(() => err2 = "Parollar mos kelmadi");
      return;
    }

    await _service.setPassword(a);

    if (!mounted) return;
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    return _BasePasswordDialog(
      title: "Tizim parolini o‘rnatish",
      subtitle: "Parol tizimga kirishda ishlatiladi.",
      fields: [
        _passField("Yangi parol", _p1, _o1, () => setState(() => _o1 = !_o1), err1),
        const SizedBox(height: 12),
        _passField("Parolni tasdiqlash", _p2, _o2, () => setState(() => _o2 = !_o2), err2),
      ],
      onSave: _save,
    );
  }

  Widget _passField(String hint, TextEditingController c, bool obscure, VoidCallback onEye, String? err) {
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

class _BasePasswordDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> fields;
  final VoidCallback onSave;

  const _BasePasswordDialog({
    required this.title,
    required this.subtitle,
    required this.fields,
    required this.onSave,
  });

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
                  Expanded(
                    child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.red)),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.red),
                  )
                ],
              ),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 16),

              ...fields,

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
                        onPressed: onSave,
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
}
