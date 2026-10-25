import 'dart:io';

import 'package:admin_panel/features/products/presentation/bloc/products_event.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dashboard/presentation/widgets/elvated_button_wg.dart';
import '../../domain/entity/create_product_params.dart';
import '../bloc/create_product/create_product_bloc.dart';
import '../bloc/create_product/create_product_state.dart';
import '../bloc/update_product/update_product_bloc.dart';
import '../bloc/update_product/update_product_state.dart';
import '../pages/product_page.dart';
import 'product_qr_dialog.dart';

class AddEditProductDialog extends StatefulWidget {
  final String title;
  final ProductRow? initial;

  const AddEditProductDialog({super.key, required this.title, this.initial});

  @override
  State<AddEditProductDialog> createState() => _AddEditProductDialogState();
}

class _AddEditProductDialogState extends State<AddEditProductDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _metrCtrl;       // narx_metr (metr uchun sotib olingan narx $)
  late final TextEditingController _packetCtrl;     // narx_pochka
  late final TextEditingController _pachkaCtrl;     // pochka (dona soni)
  late final TextEditingController _metriCtrl;      // metr (ombordagi metr)
  late final TextEditingController _jaminarxCtrl;   // jami narx (avtohisob)
  late final TextEditingController _sotishNarxCtrl; // sotish narxi metr ($)
  late final TextEditingController _jamiSotishCtrl; // jami sotish narxi (avtohisob)

  String _imagePath = '';

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;

    _nameCtrl       = TextEditingController(text: p?.productName ?? '');
    _metrCtrl       = TextEditingController(text: p?.metrPrice ?? '');
    _packetCtrl     = TextEditingController(text: p?.packetPrice ?? '');
    _pachkaCtrl     = TextEditingController(text: p?.pachka ?? '');
    _metriCtrl      = TextEditingController(text: p?.metri ?? '');
    _jaminarxCtrl   = TextEditingController(text: p?.jamiNarx ?? '');
    _sotishNarxCtrl = TextEditingController(text: p?.sotishNarxMetr ?? '');
    _jamiSotishCtrl = TextEditingController(text: _initialJamiSotish(p));

    _metrCtrl.addListener(_autoCalcJamiNarx);
    _metriCtrl.addListener(_autoCalcJamiNarx);

    _sotishNarxCtrl.addListener(_autoCalcJamiSotish);
    _metriCtrl.addListener(_autoCalcJamiSotish);
  }

  String _initialJamiSotish(ProductRow? p) {
    if (p == null) return '';
    final sotishNarx = double.tryParse(p.sotishNarxMetr);
    final metr       = double.tryParse(p.metri);
    if (sotishNarx != null && metr != null && metr > 0) {
      return (sotishNarx * metr).toStringAsFixed(2);
    }
    return '';
  }

  void _autoCalcJamiNarx() {
    final metrNarx = double.tryParse(_metrCtrl.text.trim());
    final metr     = double.tryParse(_metriCtrl.text.trim());
    if (metrNarx != null && metr != null && metr > 0) {
      final calc = (metrNarx * metr).toStringAsFixed(2);
      if (_jaminarxCtrl.text != calc) {
        _jaminarxCtrl.text = calc;
        _jaminarxCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: _jaminarxCtrl.text.length),
        );
      }
    }
  }

  void _autoCalcJamiSotish() {
    final sotishNarx = double.tryParse(_sotishNarxCtrl.text.trim());
    final metr       = double.tryParse(_metriCtrl.text.trim());
    if (sotishNarx != null && metr != null && metr > 0) {
      final calc = (sotishNarx * metr).toStringAsFixed(2);
      if (_jamiSotishCtrl.text != calc) {
        _jamiSotishCtrl.text = calc;
        _jamiSotishCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: _jamiSotishCtrl.text.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _metrCtrl.dispose();
    _packetCtrl.dispose();
    _pachkaCtrl.dispose();
    _metriCtrl.dispose();
    _jaminarxCtrl.dispose();
    _sotishNarxCtrl.dispose();
    _jamiSotishCtrl.dispose();
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

    if (_isEdit) {
      context.read<UpdateProductBloc>().add(
        UpdateProductE(
          id: widget.initial!.id,
          nomi: _nameCtrl.text.trim(),
          narxMetr: _emptyToNull(_metrCtrl.text),
          narxPochka: _emptyToNull(_packetCtrl.text),
          pochka: _emptyToNull(_pachkaCtrl.text),
          metr: _emptyToNull(_metriCtrl.text),
          kelganNarx: _emptyToNull(_metrCtrl.text), // narx_metr = kelgan narx
          jamiNarx: _emptyToNull(_jaminarxCtrl.text),
          sotishNarxMetr: _emptyToNull(_sotishNarxCtrl.text),
          jamiSotishNarx: _emptyToNull(_jamiSotishCtrl.text),
          rasm: _imagePath.trim().isEmpty ? null : File(_imagePath),
        ),
      );
    } else {
      context.read<CreateProductBloc>().add(
        CreateProductE(
          create: CreateProductParams(
            nomi: _nameCtrl.text.trim(),
            narxMetr: _emptyToNull(_metrCtrl.text),
            narxPochka: _emptyToNull(_packetCtrl.text),
            pochka: _emptyToNull(_pachkaCtrl.text),
            metr: _emptyToNull(_metriCtrl.text),
            kelganNarx: _emptyToNull(_metrCtrl.text), // narx_metr = kelgan narx
            jamiNarx: _emptyToNull(_jaminarxCtrl.text),
            sotishNarxMetr: _emptyToNull(_sotishNarxCtrl.text),
            jamiSotishNarx: _emptyToNull(_jamiSotishCtrl.text),
            rasm: _imagePath.trim().isEmpty ? null : File(_imagePath),
          ),
        ),
      );
    }
  }

  String? _emptyToNull(String? value) {
    if (value == null) return null;
    final v = value.trim();
    return v.isEmpty ? null : v;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateProductBloc, CreateProductState>(
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
        ),
        BlocListener<UpdateProductBloc, UpdateProductState>(
          listener: (context, state) {
            if (state is UpdateProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is UpdateProductSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Tovar muvaffaqiyatli yangilandi"),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        ),
      ],
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
                  // Header
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

                  // Rasm picker
                  Row(
                    children: [
                      _DialogImagePreview(
                        localPath: _imagePath,
                        networkPath: _isEdit ? widget.initial!.imagePath : '',
                      ),
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

                  // Fieldlar — 2 ustun
                  LayoutBuilder(
                    builder: (context, c) {
                      final wide = c.maxWidth >= 860;

                      Widget row2(Widget a, Widget b) => Row(
                        children: [
                          Expanded(child: a),
                          const SizedBox(width: 18),
                          Expanded(child: b),
                        ],
                      );

                      if (wide) {
                        return Column(
                          children: [
                            // 1-qator: Tovar nomi | Kelgan narx (metr uchun $)
                            row2(
                              _LabeledField(
                                label: "Tovar nomi",
                                hint: "",
                                controller: _nameCtrl,
                                validator: _required,
                              ),
                              _LabeledField(
                                label: "Kelgan narx (metr \$)",
                                hint: "masalan: 5.0",
                                controller: _metrCtrl,
                              ),
                            ),
                            const SizedBox(height: 14),
                            // 2-qator: Narx pochka | Metr (ombordagi miqdor)
                            row2(
                              _LabeledField(
                                label: "Narx pochka",
                                hint: "",
                                controller: _packetCtrl,
                              ),
                              _LabeledField(
                                label: "Metr (ombordagi miqdor)",
                                hint: "masalan: 30.0",
                                controller: _metriCtrl,
                              ),
                            ),
                            const SizedBox(height: 14),
                            // 3-qator: Pachka | Jami narx (avtohisob)
                            row2(
                              _LabeledField(
                                label: "Pochka",
                                hint: "",
                                controller: _pachkaCtrl,
                              ),
                              _LabeledField(
                                label: "Jami narx (avtohisob ✦)",
                                hint: "kelgan narx × metr",
                                controller: _jaminarxCtrl,
                                readOnly: true,
                              ),
                            ),
                            const SizedBox(height: 14),
                            // 4-qator: Sotish narxi metr | Jami sotish narxi (avtohisob)
                            row2(
                              _LabeledField(
                                label: "Sotish narxi metr (\$)",
                                hint: "masalan: 6.0",
                                controller: _sotishNarxCtrl,
                              ),
                              _LabeledField(
                                label: "Jami sotish narxi (avtohisob ✦)",
                                hint: "sotish narxi × metr",
                                controller: _jamiSotishCtrl,
                                readOnly: true,
                              ),
                            ),
                          ],
                        );
                      }

                      // Tor ekran — bir ustun
                      return Column(
                        children: [
                          _LabeledField(label: "Tovar nomi", hint: "", controller: _nameCtrl, validator: _required),
                          const SizedBox(height: 14),
                          _LabeledField(label: "Kelgan narx (metr \$)", hint: "masalan: 5.0", controller: _metrCtrl),
                          const SizedBox(height: 14),
                          _LabeledField(label: "Narx pochka", hint: "", controller: _packetCtrl),
                          const SizedBox(height: 14),
                          _LabeledField(label: "Pochka", hint: "", controller: _pachkaCtrl),
                          const SizedBox(height: 14),
                          _LabeledField(label: "Metr (ombordagi miqdor)", hint: "masalan: 30.0", controller: _metriCtrl),
                          const SizedBox(height: 14),
                          _LabeledField(label: "Jami narx (avtohisob ✦)", hint: "kelgan narx × metr", controller: _jaminarxCtrl, readOnly: true),
                          const SizedBox(height: 14),
                          _LabeledField(label: "Sotish narxi metr (\$)", hint: "masalan: 6.0", controller: _sotishNarxCtrl),
                          const SizedBox(height: 14),
                          _LabeledField(label: "Jami sotish narxi (avtohisob ✦)", hint: "sotish narxi × metr", controller: _jamiSotishCtrl, readOnly: true),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 22),

                  _isEdit
                      ? BlocBuilder<UpdateProductBloc, UpdateProductState>(
                    builder: (context, state) {
                      final isLoading = state is UpdateProductLoading;
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
                  )
                      : BlocBuilder<CreateProductBloc, CreateProductState>(
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
  final String localPath;
  final String networkPath;

  const _DialogImagePreview({required this.localPath, required this.networkPath});

  @override
  Widget build(BuildContext context) {
    final hasLocal = localPath.trim().isNotEmpty && File(localPath).existsSync();
    final hasNetwork = networkPath.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: hasLocal
          ? Image.file(File(localPath), width: 96, height: 96, fit: BoxFit.cover)
          : hasNetwork
          ? Image.network(
        'https://olampardalar.uz/uploads/$networkPath',
        width: 96,
        height: 96,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      )
          : _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 96,
      height: 96,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Icon(Icons.image, color: Colors.grey.shade600),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool readOnly;

  const _LabeledField({
    required this.label,
    this.hint = '',
    required this.controller,
    this.validator,
    this.readOnly = false,
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
          readOnly: readOnly,
          style: readOnly
              ? TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600)
              : null,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            filled: readOnly,
            fillColor: readOnly ? Colors.grey.shade50 : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}