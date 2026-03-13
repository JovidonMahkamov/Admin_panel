import 'dart:io';

import 'package:admin_panel/features/products/presentation/bloc/products_event.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dashboard/presentation/widgets/elvated_button_wg.dart';
import '../../domain/entity/create_product_params.dart';
import '../bloc/create_product/create_product_bloc.dart';
import '../bloc/create_product/create_product_state.dart';
import 'product_qr_dialog.dart';

class AddEditProductDialog extends StatefulWidget {
  final String title;

  const AddEditProductDialog({
    super.key,
    required this.title,
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
  late final TextEditingController _kelganCtrl;
  late final TextEditingController _jaminarxCtrl;

  String _imagePath = '';

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _metrCtrl = TextEditingController();
    _donaCtrl = TextEditingController();
    _packetCtrl = TextEditingController();
    _pachkaCtrl = TextEditingController();
    _metriCtrl = TextEditingController();
    _miqdoriCtrl = TextEditingController();
    _kelganCtrl = TextEditingController();
    _jaminarxCtrl = TextEditingController();
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
    _kelganCtrl.dispose();
    _jaminarxCtrl.dispose();
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

    final params = CreateProductParams(
      nomi: _nameCtrl.text.trim(),
      narxDona: _emptyToNull(_donaCtrl.text),
      narxMetr: _emptyToNull(_metrCtrl.text),
      narxPochka: _emptyToNull(_packetCtrl.text),
      pochka: _emptyToNull(_pachkaCtrl.text),
      metr: _emptyToNull(_metriCtrl.text),
      miqdor: _emptyToNull(_miqdoriCtrl.text),
      kelganNarx: _emptyToNull(_kelganCtrl.text),
      jamiNarx: _emptyToNull(_jaminarxCtrl.text),
      rasm: _imagePath.trim().isEmpty ? null : File(_imagePath),
    );

    context.read<CreateProductBloc>().add(
      CreateProductE(create: params),
    );
  }

  String? _emptyToNull(String? value) {
    if (value == null) return null;
    final v = value.trim();
    return v.isEmpty ? null : v;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateProductBloc, CreateProductState>(
      listener: (context, state) async {
        if (state is CreateProductError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }

        if (state is CreateProductSuccess) {
          Navigator.pop(context);

          await showDialog(
            context: context,
            builder: (_) => ProductQrDialog(
              productName: state.productEntity.nomi,
              qrCodePath: state.productEntity.qrKod ?? '',
            ),
          );
        }
      },
      child: Dialog(
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
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      _DialogImagePreview(path: _imagePath),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rasm",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
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
                                    style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
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

                      Widget row2(Widget a, Widget b) {
                        return Row(
                          children: [
                            Expanded(child: a),
                            const SizedBox(width: 18),
                            Expanded(child: b),
                          ],
                        );
                      }

                      if (wide) {
                        return Column(
                          children: [
                            row2(
                              _LabeledField(
                                label: "Tovar nomi",
                                hint: "parda",
                                controller: _nameCtrl,
                                validator: _required,
                              ),
                              _LabeledField(
                                label: "Narx metr",
                                hint: "12000",
                                controller: _metrCtrl,
                              ),
                            ),
                            const SizedBox(height: 14),
                            row2(
                              _LabeledField(
                                label: "Narx dona",
                                hint: "10000",
                                controller: _donaCtrl,
                              ),
                              _LabeledField(
                                label: "Narx pochka",
                                hint: "50000",
                                controller: _packetCtrl,
                              ),
                            ),
                            const SizedBox(height: 14),
                            row2(
                              _LabeledField(
                                label: "Pochka",
                                hint: "10",
                                controller: _pachkaCtrl,
                              ),
                              _LabeledField(
                                label: "Metr",
                                hint: "20",
                                controller: _metriCtrl,
                              ),
                            ),
                            const SizedBox(height: 14),
                            row2(
                              _LabeledField(
                                label: "Miqdor",
                                hint: "100",
                                controller: _miqdoriCtrl,
                              ),
                              _LabeledField(
                                label: "Kelgan narx",
                                hint: "9000",
                                controller: _kelganCtrl,
                              ),
                            ),
                            const SizedBox(height: 14),
                            row2(
                              _LabeledField(
                                label: "Jami narx",
                                hint: "900000",
                                controller: _jaminarxCtrl,
                              ),
                              const SizedBox.shrink(),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          _LabeledField(
                            label: "Tovar nomi",
                            hint: "parda",
                            controller: _nameCtrl,
                            validator: _required,
                          ),
                          const SizedBox(height: 14),
                          _LabeledField(
                            label: "Narx metr",
                            hint: "12000",
                            controller: _metrCtrl,
                          ),
                          const SizedBox(height: 14),
                          _LabeledField(
                            label: "Narx dona",
                            hint: "10000",
                            controller: _donaCtrl,
                          ),
                          const SizedBox(height: 14),
                          _LabeledField(
                            label: "Narx pochka",
                            hint: "50000",
                            controller: _packetCtrl,
                          ),
                          const SizedBox(height: 14),
                          _LabeledField(
                            label: "Pochka",
                            hint: "10",
                            controller: _pachkaCtrl,
                          ),
                          const SizedBox(height: 14),
                          _LabeledField(
                            label: "Metr",
                            hint: "20",
                            controller: _metriCtrl,
                          ),
                          const SizedBox(height: 14),
                          _LabeledField(
                            label: "Miqdor",
                            hint: "100",
                            controller: _miqdoriCtrl,
                          ),
                          const SizedBox(height: 14),
                          _LabeledField(
                            label: "Kelgan narx",
                            hint: "9000",
                            controller: _kelganCtrl,
                          ),
                          const SizedBox(height: 14),
                          _LabeledField(
                            label: "Jami narx",
                            hint: "900000",
                            controller: _jaminarxCtrl,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 22),

                  BlocBuilder<CreateProductBloc, CreateProductState>(
                    builder: (context, state) {
                      final isLoading = state is CreateProductLoading;

                      return Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 320,
                          height: 46,
                          child: ElevatedWidget(
                            onPressed: isLoading ? null : _save,
                            size: 250,
                            text: isLoading ? "Saqlanmoqda..." : "Saqlash",
                            backgroundColor: Colors.blueAccent,
                            textColor: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
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
          ? Image.file(
        File(path),
        width: 96,
        height: 96,
        fit: BoxFit.cover,
      )
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
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}