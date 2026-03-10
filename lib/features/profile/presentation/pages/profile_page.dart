import 'dart:io';

import 'package:admin_panel/features/profile/presentation/widgets/change_password_dialog.dart';
import 'package:admin_panel/features/profile/presentation/widgets/edit_profile_dialog.dart';
import 'package:admin_panel/features/profile/presentation/widgets/password_service.dart';
import 'package:admin_panel/features/profile/presentation/widgets/profile_service.dart';
import 'package:admin_panel/features/profile/presentation/widgets/set_password_dialog.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _service = ProfileService();
  final _pass = PasswordService();

  ProfileData? data;
  bool hasPassword = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = await _service.load();
    final hp = await _pass.hasPassword();
    setState(() {
      data = d;
      hasPassword = hp;
    });
  }

  void _openEdit() {
    final d = data;
    if (d == null) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => EditProfileDialog(
        initial: d,
        onSave: (updated) async {
          await _service.save(updated);
          if (mounted) Navigator.pop(context);
          await _load();
        },
      ),
    );
  }

  void _openSetPassword() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => SetPasswordDialog(
        onSaved: () async {
          if (mounted) Navigator.pop(context);
          await _load();
        },
      ),
    );
  }

  void _openChangePassword() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => ChangePasswordDialog(
        onSaved: () async {
          if (mounted) Navigator.pop(context);
          await _load();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = data;

    return Padding(
      padding: const EdgeInsets.all(22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: Colors.black.withOpacity(0.06),
            ),
          ],
        ),
        child: d == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Profil",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
                SizedBox(
                  height: 38,
                  width: 160,
                  child: ElevatedButton(
                    onPressed: _openEdit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Text("Tahrirlash"),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // left image
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Do‘kon rasmi", style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 220,
                        height: 220,
                        color: Colors.grey.shade200,
                        child: d.imagePath == null
                            ? const Icon(Icons.storefront, size: 40)
                            : Image.file(
                          File(d.imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 26),

                // right info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow(label: "Do‘kon nomi:", value: d.name),
                        const SizedBox(height: 10),
                        _InfoRow(label: "Telefon raqami:", value: d.phone),
                        const SizedBox(height: 22),

                        SizedBox(
                          height: 38,
                          width: 240,
                          child: ElevatedButton(
                            onPressed: hasPassword ? _openChangePassword : _openSetPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: hasPassword ? Colors.blue : Colors.grey.shade300,
                              foregroundColor: hasPassword ? Colors.white : Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: Text(hasPassword ? "Parolni o‘zgartirish" : "Tizim parolini o‘rnatish"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w700)),
        const SizedBox(width: 10),
        Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
      ],
    );
  }
}
