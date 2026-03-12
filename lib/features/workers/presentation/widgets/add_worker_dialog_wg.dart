import 'package:admin_panel/features/dashboard/presentation/widgets/elvated_button_wg.dart';
import 'package:admin_panel/features/workers/presentation/bloc/create_worker/create_worker_bloc.dart';
import 'package:admin_panel/features/workers/presentation/bloc/create_worker/create_worker_state.dart';
import 'package:admin_panel/features/workers/presentation/bloc/get_all_worker/get_all_worker_bloc.dart';
import 'package:admin_panel/features/workers/presentation/bloc/worker_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditWorkerDialog extends StatefulWidget {
  final WorkerFormData ? initial;
  final ValueChanged<WorkerFormData>? onSave;
  final String title;

  const AddEditWorkerDialog({
    super.key,
    required this.initial,
    required this.onSave,
    required this.title,
  });

  @override
  State<AddEditWorkerDialog> createState() => _AddEditWorkerDialogState();
}

class _AddEditWorkerDialogState extends State<AddEditWorkerDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _loginCtrl;
  late final TextEditingController _passCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.fish ?? "");
    _phoneCtrl = TextEditingController(text: widget.initial?.telefon ?? "");
    _loginCtrl = TextEditingController(text: widget.initial?.login ?? "");
    _passCtrl = TextEditingController(text: widget.initial?.parol ?? "");
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _loginCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final formData = WorkerFormData(
      id: widget.initial?.id,
      fish: _nameCtrl.text.trim(),
      telefon: _phoneCtrl.text.trim(),
      login: _loginCtrl.text.trim(),
      parol: _passCtrl.text.trim(),
    );

    final isEdit = widget.initial != null;

    if (isEdit) {
      widget.onSave?.call(formData);
      return;
    }

    context.read<CreateWorkerBloc>().add(
      CreateWorkerE(
        fish: formData.fish,
        login: formData.login,
        parol: formData.parol,
        telefon: formData.telefon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;

    return BlocConsumer<CreateWorkerBloc, CreateWorkerState>(
      listener: (context, state) {
        if (state is CreateWorkerSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.createWorkerResponseEntity.message),
            ),
          );

          widget.onSave?.call(
            WorkerFormData(
              fish: _nameCtrl.text.trim(),
              telefon: _phoneCtrl.text.trim(),
              login: _loginCtrl.text.trim(),
              parol: _passCtrl.text.trim(),
            ),
          );

          context.read<GetAllWorkerBloc>().add(const GetAllWorkerE());
          Navigator.pop(context);
        }

        if (state is CreateWorkerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateWorkerLoading;

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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: isLoading ? null : () => Navigator.pop(context),
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
                                        enabled: !isLoading,
                                      ),
                                    ),
                                    const SizedBox(width: 18),
                                    Expanded(
                                      child: _LabeledField(
                                        label: "Telefon",
                                        hint: "+998 XX XXXX XX XX",
                                        controller: _phoneCtrl,
                                        validator: _required,
                                        enabled: !isLoading,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _LabeledField(
                                        label: "Login",
                                        hint: "XXXXXXXX",
                                        controller: _loginCtrl,
                                        validator: _required,
                                        enabled: !isLoading,                                      ),
                                    ),
                                    const SizedBox(width: 18),
                                    Expanded(
                                      child: _LabeledField(
                                        label: "Parol",
                                        hint: "********",
                                        controller: _passCtrl,
                                        obscureText: true,
                                        validator: _required,
                                        enabled: !isLoading,
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
                                enabled: !isLoading,
                              ),
                              const SizedBox(height: 18),
                              _LabeledField(
                                label: "Telefon",
                                hint: "+998 XX XXX XX XX",
                                controller: _phoneCtrl,
                                validator: _required,
                                enabled: !isLoading,
                              ),
                              const SizedBox(height: 18),
                              _LabeledField(
                                label: "Login",
                                hint: "XXXXXXX",
                                controller: _loginCtrl,
                                validator: _required,
                                enabled: !isLoading,
                              ),
                              const SizedBox(height: 18),
                              _LabeledField(
                                label: "Parol",
                                hint: "********",
                                controller: _passCtrl,
                                obscureText: true,
                                validator: _required,
                                enabled: !isLoading,
                              ),
                            ],
                          );
                        }

                        return fieldGrid();
                      },
                    ),
                    const SizedBox(height: 26),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 250,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedWidget(
                          onPressed: _save,
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
      },
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
  final bool enabled;
  final String? Function(String?)? validator;

  const _LabeledField({
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.enabled = true,
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
          enabled: enabled,
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

class WorkerFormData {
  final int? id;
  final String fish;
  final String telefon;
  final String login;
  final String parol;

  const WorkerFormData({
    this.id,
    required this.fish,
    required this.telefon,
    required this.login,
    required this.parol,
  });
}