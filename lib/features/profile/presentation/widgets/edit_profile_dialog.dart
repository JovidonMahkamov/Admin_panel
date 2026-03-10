import 'dart:io';

import 'package:admin_panel/features/profile/presentation/widgets/profile_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class EditProfileDialog extends StatefulWidget {
  final ProfileData initial;
  final ValueChanged<ProfileData> onSave;

  const EditProfileDialog({
    super.key,
    required this.initial,
    required this.onSave,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController _name;
  late final TextEditingController _phone;

  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial.name);
    _phone = TextEditingController(text: widget.initial.phone);
    _imagePath = widget.initial.imagePath;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    final path = res?.files.single.path;
    if (path == null) return;
    setState(() => _imagePath = path);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1050),
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
                      "Profilni tahrirlash",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.red),
                  )
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // image
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Do‘kon rasmi", style: TextStyle(color: Colors.grey.shade600)),
                        const SizedBox(height: 8),
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _pickImage,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 220,
                              height: 220,
                              color: Colors.grey.shade200,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (_imagePath != null)
                                    Positioned.fill(
                                      child: Image.file(
                                        File(_imagePath!),
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const SizedBox(),
                                      ),
                                    ),
                                  const Icon(Icons.cloud_upload_outlined, size: 44),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),

                  // fields
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _field("Do‘kon nomi", _name)),
                            const SizedBox(width: 14),
                            Expanded(child: _field("Telefon raqami", _phone)),
                          ],
                        ),
                        const SizedBox(height: 22),

                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 260,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () {
                                final updated = widget.initial.copyWith(
                                  name: _name.text.trim(),
                                  phone: _phone.text.trim(),
                                  imagePath: _imagePath,
                                );
                                widget.onSave(updated);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text("Saqlash"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade700)),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          decoration: InputDecoration(
            hintText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
