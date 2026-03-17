import 'package:admin_panel/features/customer/domain/entity/create_customer_request_entity.dart';
import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/elvated_button_wg.dart';

class CreateCustomerModel {
  final CreateCustomerRequestEntity createCustomer;

  const CreateCustomerModel({
    required this.createCustomer
  });
}

class CreateCustomerDialog extends StatefulWidget {
  final ValueChanged<CreateCustomerModel> onSave;

  const CreateCustomerDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<CreateCustomerDialog> createState() =>
      _CreateCustomerDialogState();
}

class _CreateCustomerDialogState extends State<CreateCustomerDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _typeCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final entity = CreateCustomerRequestEntity(
      fish: _nameCtrl.text.trim(),
      telefon: _phoneCtrl.text.trim(),
      manzil: _addressCtrl.text.trim(),
      mijozTuri: _typeCtrl.text.trim(),
    );

    widget.onSave(
      CreateCustomerModel(createCustomer: entity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// HEADER
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Mijoz qo‘shish",
                        style: TextStyle(
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

                const SizedBox(height: 20),

                /// INPUTLAR
                _buildField(
                  label: "F.I.Sh",
                  hint: "AAA BBB CCC",
                  controller: _nameCtrl,
                ),

                const SizedBox(height: 14),

                _buildField(
                  label: "Telefon",
                  hint: "+998 XX XXX XX XX",
                  controller: _phoneCtrl,
                ),

                const SizedBox(height: 14),

                _buildField(
                  label: "Manzil",
                  hint: "Manzil kiriting",
                  controller: _addressCtrl,
                ),

                const SizedBox(height: 14),

                _buildField(
                  label: "Mijoz turi",
                  hint: "optom / retail",
                  controller: _typeCtrl,
                ),

                const SizedBox(height: 24),

                /// BUTTON
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedWidget(
                    size: 200,
                    onPressed: _save,
                    text: "Saqlash",
                    backgroundColor: Colors.blue,
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

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: (v) =>
          v == null || v.trim().isEmpty ? "Majburiy" : null,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}