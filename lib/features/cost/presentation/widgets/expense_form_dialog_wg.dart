import 'package:admin_panel/features/cost/presentation/widgets/expense_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpenseFormDialogWg extends StatefulWidget {
  final String title;
  final List<WorkerOption> workers;
  final ExpenseRowData? initial;

  const ExpenseFormDialogWg({
    super.key,
    required this.title,
    required this.workers,
    this.initial,
  });

  @override
  State<ExpenseFormDialogWg> createState() => _ExpenseFormDialogWgState();
}

class _ExpenseFormDialogWgState extends State<ExpenseFormDialogWg> {
  final _formKey = GlobalKey<FormState>();

  late PaymentType _paymentType;
  String? _workerId;
  late final TextEditingController _summaCtrl;
  CurrencyType? _currency;

  bool _convertatsiya = false;
  bool _foyda = false;
  bool _sms = true;

  late final TextEditingController _izohCtrl;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;

    _paymentType = initial?.paymentType ?? PaymentType.naqd;

    final workerIds = widget.workers.map((w) => w.id).toSet();
    _workerId = (initial?.workerId != null && workerIds.contains(initial!.workerId))
        ? initial.workerId
        : null;

    _summaCtrl = TextEditingController(
      text: initial != null ? _formatDisplay(initial.summa) : '',
    );
    _convertatsiya = initial?.convertatsiya ?? false;
    _foyda = initial?.foyda ?? false;
    _sms = initial?.sms ?? true;
    _izohCtrl = TextEditingController(
      text: initial != null && initial.izoh != '-' ? initial.izoh : '',
    );
  }

  String _formatDisplay(double value) {
    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _summaCtrl.dispose();
    _izohCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final raw = _summaCtrl.text.replaceAll(' ', '').replaceAll(',', '.');
    final summa = double.tryParse(raw) ?? 0;
    if (summa <= 0) return;

    Navigator.pop(
      context,
      ExpenseFormResult(
        paymentType: _paymentType,
        workerId: _workerId!,
        summa: summa,
        currency: _currency!,
        convertatsiya: _convertatsiya,
        foyda: _foyda,
        sms: _sms,
        izoh: _izohCtrl.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Header(title: widget.title),
                const SizedBox(height: 16),

                _DialogPaymentTabs(
                  selected: _paymentType,
                  onChanged: (v) => setState(() => _paymentType = v),
                ),
                const SizedBox(height: 14),

                DropdownButtonFormField<String>(
                  value: _workerId,
                  decoration: dialogInputDecoration(hintText: "Ishchini tanlang"),
                  items: widget.workers
                      .map((w) => DropdownMenuItem<String>(
                    value: w.id,
                    child: Text(w.name, overflow: TextOverflow.ellipsis),
                  ))
                      .toList(),
                  onChanged: (v) => setState(() => _workerId = v),
                  validator: (v) => v == null ? "Ishchini tanlang" : null,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _summaCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                        ],
                        decoration: dialogInputDecoration(hintText: "Summa (12563.50)"),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "Summani kiriting";
                          final raw = v.replaceAll(',', '.');
                          final n = double.tryParse(raw) ?? 0;
                          if (n <= 0) return "Summa noto'g'ri";
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<CurrencyType>(
                        value: _currency,
                        decoration: dialogInputDecoration(hintText: "Valyuta"),
                        items: CurrencyType.values
                            .map((c) => DropdownMenuItem<CurrencyType>(
                          value: c,
                          child: Text(c.label),
                        ))
                            .toList(),
                        onChanged: (v) => setState(() => _currency = v),
                        validator: (v) => v == null ? "Tanlang" : null,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _CheckTile(
                        label: "Konvertatsiya",
                        value: _convertatsiya,
                        onChanged: (v) => setState(() => _convertatsiya = v),
                      ),
                    ),
                    Expanded(
                      child: _CheckTile(
                        label: "Foyda",
                        value: _foyda,
                        onChanged: (v) => setState(() => _foyda = v),
                      ),
                    ),
                    Expanded(
                      child: _CheckTile(
                        label: "SMS",
                        value: _sms,
                        onChanged: (v) => setState(() => _sms = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _izohCtrl,
                  maxLines: 2,
                  decoration: dialogInputDecoration(hintText: "Izoh qoldiring..."),
                ),
                const SizedBox(height: 18),

                _BottomButtons(onCancel: () => Navigator.pop(context), onSave: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF474747))),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.close, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}

class _DialogPaymentTabs extends StatelessWidget {
  final PaymentType selected;
  final ValueChanged<PaymentType> onChanged;

  const _DialogPaymentTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
          color: const Color(0xFFE9EAEC), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: PaymentType.values.map((item) {
          final isSelected = item == selected;
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => onChanged(item),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1877F2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(item.label,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: isSelected ? Colors.white : const Color(0xFF444))),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CheckTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CheckTile({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onChanged(!value),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: value ? const Color(0xFF1877F2) : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: value ? const Color(0xFF1877F2) : const Color(0xFFE2E5EA)),
              ),
              child: value ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF2E2E2E))),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomButtons extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _BottomButtons({required this.onCancel, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE3E6EB),
                  foregroundColor: const Color(0xFF646B75),
                  elevation: 0,
                  shape: const StadiumBorder()),
              child: const Text("Bekor qilish"),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1877F2),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const StadiumBorder()),
              child: const Text("Saqlash"),
            ),
          ),
        ),
      ],
    );
  }
}