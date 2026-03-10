import 'package:admin_panel/features/customer/presentation/pages/customer_page.dart';
import 'package:admin_panel/features/dashboard/presentation/widgets/elvated_button_wg.dart';
import 'package:flutter/material.dart';


class EditCustomerDialog extends StatefulWidget {
  final String title;
  final CustomerRow? initial; // edit uchun
  final ValueChanged<CustomerRow> onSave;

  const EditCustomerDialog({
    super.key,
    required this.title,
    required this.onSave,
    this.initial,
  });

  @override
  State<EditCustomerDialog> createState() => _EditCustomerDialogState();
}

class _EditCustomerDialogState extends State<EditCustomerDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _debtCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl  = TextEditingController(text: widget.initial?.customerName ?? "");
    _phoneCtrl = TextEditingController(text: widget.initial?.phone ?? "");
    _addressCtrl = TextEditingController(text: widget.initial?.address ?? "");
    _debtCtrl  = TextEditingController(text: widget.initial?.debt ?? "");
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _debtCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSave(
      CustomerRow(
        customerName: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        debt: _debtCtrl.text.trim(),
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
        constraints: const BoxConstraints(maxWidth: 880, minWidth: 720),
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

                const SizedBox(height: 16),

                LayoutBuilder(
                  builder: (context, c) {
                    final wide = c.maxWidth >= 760;

                    Widget fieldGrid() {
                      if (wide) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _LabeledField(
                                    label: "F.I.Sh",
                                    hint: "AAA BBB CCC",
                                    controller: _nameCtrl,
                                    validator: _required,
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: _LabeledField(
                                    label: "Telefon",
                                    hint: "+998 XX XXXX XX XX",
                                    controller: _phoneCtrl,
                                    validator: _required,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: _LabeledField(
                                    label: "Manzil",
                                    hint: "manzil kiriting",
                                    controller: _addressCtrl,
                                    validator: _required,
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: _LabeledField(
                                    label: "Qarzdorligi",
                                    hint: "sum/\$",
                                    controller: _debtCtrl,
                                    validator: _required,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          _LabeledField(
                            label: "F.I.Sh",
                            hint: "AAA BBB CCC",
                            controller: _nameCtrl,
                            validator: _required,
                          ),
                          const SizedBox(height: 18),
                          _LabeledField(
                            label: "Telefon",
                            hint: "+998 XX XXX XX XX",
                            controller: _phoneCtrl,
                            validator: _required,
                          ),
                          const SizedBox(height: 18),
                          _LabeledField(
                            label: "Manzil",
                            hint: "manzil kiriting",
                            controller: _addressCtrl,
                            validator: _required,
                          ),
                          const SizedBox(height: 18),
                          _LabeledField(
                            label: "Qarzdorligi",
                            hint: "sum/\$",
                            controller: _debtCtrl,
                            obscureText: true,
                            validator: _required,
                          ),
                          const SizedBox(height: 18),
                        ],
                      );
                    }

                    return fieldGrid();
                  },
                ),

                const SizedBox(height: 26),

                Align(
                  alignment: Alignment.centerRight,
                  child:  ElevatedWidget(
                    size: 250,
                    onPressed: _save,
                    text: isEdit ? "Yangilash" : "Saqlash",
                    backgroundColor: Colors.blueAccent,
                    textColor: Colors.white,
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
class _LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;

  const _LabeledField({
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
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
          obscureText: obscureText,
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
