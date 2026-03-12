import 'dart:io';

import 'package:admin_panel/features/dashboard/presentation/widgets/elvated_button_wg.dart';
import 'package:admin_panel/features/products/presentation/pages/product_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddEditProductDialog extends StatefulWidget {
  final String title;
  final ProductRow? initial;
  final ValueChanged<ProductRow> onSave;

  const AddEditProductDialog({
    super.key,
    required this.title,
    required this.onSave,
    this.initial,
  });

  @override
  State<AddEditProductDialog> createState() => _AddEditProductDialogState();
}

class _AddEditProductDialogState extends State<AddEditProductDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _metrCtrl;
  late final TextEditingController _donaCtrl;
  late final TextEditingController _packetCtrl;

  late final TextEditingController _pachkaCtrl;
  late final TextEditingController _metriCtrl;
  late final TextEditingController _miqdoriCtrl;

  String _imagePath = "";

  @override
  void initState() {
    super.initState();
    final i = widget.initial;

    _nameCtrl = TextEditingController(text: i?.productName ?? "");
    _metrCtrl = TextEditingController(text: i?.metrPrice ?? "");
    _donaCtrl = TextEditingController(text: i?.donaPrice ?? "");
    _packetCtrl = TextEditingController(text: i?.packetPrice ?? "");

    _pachkaCtrl = TextEditingController(text: i?.pachka ?? "");
    _metriCtrl = TextEditingController(text: i?.metri ?? "");
    _miqdoriCtrl = TextEditingController(text: i?.miqdori ?? "");

    _imagePath = i?.imagePath ?? "";
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _metrCtrl.dispose();
    _donaCtrl.dispose();
    _packetCtrl.dispose();
    _pachkaCtrl.dispose();
    _metriCtrl.dispose();
    _miqdoriCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null) return;

    setState(() => _imagePath = path);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    // final oldSold = widget.initial?.sotildi ?? 0;

    widget.onSave(
      ProductRow(
        productName: _nameCtrl.text.trim(),
        metrPrice: _metrCtrl.text.trim(),
        donaPrice: _donaCtrl.text.trim(),
        packetPrice: _packetCtrl.text.trim(),
        pachka: _pachkaCtrl.text.trim(),
        metri: _metriCtrl.text.trim(),
        miqdori: _miqdoriCtrl.text.trim(),

        // sotildi: oldSold,
        imagePath: _imagePath.trim(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980, minWidth: 820),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // IMAGE PICKER ROW
                Row(
                  children: [
                    _DialogImagePreview(path: _imagePath),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Rasm", style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.folder_open),
                                label: const Text("Fayldan tanlash"),
                              ),
                              const SizedBox(width: 12),
                              if (_imagePath.trim().isNotEmpty)
                                Text(
                                  "Tanlandi",
                                  style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                LayoutBuilder(
                  builder: (context, c) {
                    final wide = c.maxWidth >= 860;

                    Widget row2(Widget a, [Widget? b]) => Row(
                      children: [
                        Expanded(child: a),
                        const SizedBox(width: 18),
                        Expanded(child: b ?? const SizedBox.shrink()),
                      ],
                    );


                    if (wide) {
                      return Column(
                        children: [
                          row2(
                            _LabeledField(
                              label: "Tovar nomi",
                              hint: "0422 Senior",
                              controller: _nameCtrl,
                              validator: _required,
                            ),
                            _LabeledField(
                              label: "Narxi metr",
                              hint: "12\$",
                              controller: _metrCtrl,
                            ),
                          ),
                          const SizedBox(height: 14),
                          row2(
                            _LabeledField(
                              label: "Narxi dona",
                              hint: "12\$",
                              controller: _donaCtrl,
                            ),
                            _LabeledField(
                              label: "Narxi pachka",
                              hint: "700\$",
                              controller: _packetCtrl,
                            ),
                          ),
                          const SizedBox(height: 14),
                          row2(
                            _LabeledField(
                              label: "Pachka",
                              hint: "200",
                              controller: _pachkaCtrl,
                              validator: _required,
                            ),
                            _LabeledField(
                              label: "Metri",
                              hint: "190",
                              controller: _metriCtrl,
                              validator: _required,
                            ),
                          ),
                          const SizedBox(height: 14),
                          row2(
                            _LabeledField(
                              label: "Miqdori",
                              hint: "190",
                              controller: _miqdoriCtrl,
                              validator: _required,
                            ),

                          ),
                        ],
                      );
                    }

                    // small width layout
                    return Column(
                      children: [
                        _LabeledField(
                          label: "Tovar nomi",
                          hint: "0422 Senior",
                          controller: _nameCtrl,
                          validator: _required,
                        ),
                        const SizedBox(height: 14),
                        _LabeledField(label: "Narxi metr", hint: "12\$", controller: _metrCtrl),
                        const SizedBox(height: 14),
                        _LabeledField(label: "Narxi dona", hint: "12\$", controller: _donaCtrl),
                        const SizedBox(height: 14),
                        _LabeledField(label: "Narxi pachka", hint: "700\$", controller: _packetCtrl),
                        const SizedBox(height: 14),
                        _LabeledField(label: "Pachka", hint: "200", controller: _pachkaCtrl, validator: _required),
                        const SizedBox(height: 14),
                        _LabeledField(label: "Metri", hint: "190", controller: _metriCtrl, validator: _required),
                        const SizedBox(height: 14),
                        _LabeledField(label: "Miqdori", hint: "190", controller: _miqdoriCtrl, validator: _required),
                        const SizedBox(height: 14),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 22),

                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 320,
                    height: 46,
                    child: ElevatedWidget(
                      onPressed: _save,
                      size: 250,
                      text: isEdit ? "Yangilash" : "Saqlash",
                      backgroundColor: Colors.blueAccent,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _required(String? v) {
    if (v == null || v.trim().isEmpty) return "Majburiy";
    return null;
  }
}

class _DialogImagePreview extends StatelessWidget {
  final String path;

  const _DialogImagePreview({required this.path});

  @override
  Widget build(BuildContext context) {
    final hasFile = path.trim().isNotEmpty && File(path).existsSync();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: hasFile
          ? Image.file(File(path), width: 96, height: 96, fit: BoxFit.cover)
          : Container(
        width: 96,
        height: 96,
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Icon(Icons.image, color: Colors.grey.shade600),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const _LabeledField({
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
