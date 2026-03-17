import 'package:admin_panel/features/cost/presentation/widgets/expense_models.dart';
import 'package:admin_panel/features/cost/presentation/widgets/kassa_models.dart';
import 'package:flutter/material.dart';

class KassaExpenseFormDialogWg extends StatefulWidget {
  final String title;
  final KassaExpenseRowData? initial;

  const KassaExpenseFormDialogWg({
    super.key,
    required this.title,
    this.initial,
  });

  @override
  State<KassaExpenseFormDialogWg> createState() =>
      _KassaExpenseFormDialogWgState();
}

class _KassaExpenseFormDialogWgState extends State<KassaExpenseFormDialogWg> {
  final _formKey = GlobalKey<FormState>();

  late PaymentType _paymentType;
  late final TextEditingController _doKonCtrl;
  late final TextEditingController _summaCtrl;
  bool _sms = true;
  late final TextEditingController _izohCtrl;

  // Mahsulotlar uchun dinamik list
  final List<TextEditingController> _mahsulotCtrls = [];

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;

    _paymentType = initial?.paymentType ?? PaymentType.naqd;
    _doKonCtrl = TextEditingController(text: initial?.doKon ?? '');
    _summaCtrl = TextEditingController(
      text: initial != null ? formatAmount(initial.summa.toInt()) : '',
    );
    _sms = initial?.sms ?? true;
    _izohCtrl = TextEditingController(
      text: initial != null && initial.izoh != '-' ? initial.izoh : '',
    );

    // Mahsulotlarni boshlang'ich holat
    if (initial != null && initial.mahsulotlar.isNotEmpty) {
      for (final m in initial.mahsulotlar) {
        _mahsulotCtrls.add(TextEditingController(text: m));
      }
    } else {
      // Kamida bitta bo'sh field
      _mahsulotCtrls.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _doKonCtrl.dispose();
    _summaCtrl.dispose();
    _izohCtrl.dispose();
    for (final c in _mahsulotCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _addMahsulot() {
    setState(() {
      _mahsulotCtrls.add(TextEditingController());
    });
  }

  void _removeMahsulot(int index) {
    setState(() {
      _mahsulotCtrls[index].dispose();
      _mahsulotCtrls.removeAt(index);
    });
  }

  void _save() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final digits = _summaCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
    final summa = int.tryParse(digits) ?? 0;
    if (summa <= 0) return;

    final mahsulotlar = _mahsulotCtrls
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    // API ga bitta string yuboriladi
    final mahsulotNomi = mahsulotlar.join(', ');

    Navigator.pop(
      context,
      KassaExpenseFormResult(
        paymentType: _paymentType,
        doKon: _doKonCtrl.text.trim(),
        mahsulotNomi: mahsulotNomi.isEmpty ? '-' : mahsulotNomi,
        summa: summa,
        sms: _sms,
        izoh: _izohCtrl.text.trim().isEmpty ? '-' : _izohCtrl.text.trim(),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF474747),
                        ),
                      ),
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
                ),

                const SizedBox(height: 16),

                // To'lov turi tabs
                _DialogPaymentTabs(
                  selected: _paymentType,
                  onChanged: (v) => setState(() => _paymentType = v),
                ),

                const SizedBox(height: 14),

                // Do'kon nomi
                TextFormField(
                  controller: _doKonCtrl,
                  decoration: dialogInputDecoration(hintText: "Do'konni kiriting"),
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? "Do'kon nomini kiriting" : null,
                ),

                const SizedBox(height: 14),

                // Mahsulotlar — dinamik list
                ...List.generate(_mahsulotCtrls.length, (i) {
                  final isLast = i == _mahsulotCtrls.length - 1;
                  final showMinus = _mahsulotCtrls.length > 1;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _mahsulotCtrls[i],
                            decoration: dialogInputDecoration(
                                hintText: "Mahsulot nomini kiriting"),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Minus tugmasi (agar 1 dan ko'p bo'lsa)
                        if (showMinus)
                          _CircleIconBtn(
                            icon: Icons.remove,
                            color: Colors.red,
                            onTap: () => _removeMahsulot(i),
                          ),

                        // Plus tugmasi (faqat oxirgi qatorda)
                        if (isLast) ...[
                          if (showMinus) const SizedBox(width: 6),
                          _CircleIconBtn(
                            icon: Icons.add,
                            color: const Color(0xFF1877F2),
                            onTap: _addMahsulot,
                          ),
                        ],
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 4),

                // Summa
                TextFormField(
                  controller: _summaCtrl,
                  keyboardType: TextInputType.number,
                  decoration: dialogInputDecoration(hintText: "Summa kiriting"),
                  onChanged: (value) {
                    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (digits.isEmpty) {
                      if (_summaCtrl.text.isNotEmpty) {
                        _summaCtrl.value = const TextEditingValue();
                      }
                      return;
                    }
                    final formatted = formatAmount(int.parse(digits));
                    if (formatted != _summaCtrl.text) {
                      _summaCtrl.value = TextEditingValue(
                        text: formatted,
                        selection:
                        TextSelection.collapsed(offset: formatted.length),
                      );
                    }
                  },
                  validator: (v) {
                    final digits =
                    (v ?? '').replaceAll(RegExp(r'[^0-9]'), '');
                    if (digits.isEmpty) return "Summani kiriting";
                    final num = int.tryParse(digits) ?? 0;
                    if (num <= 0) return "Summa noto'g'ri";
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // SMS checkbox
                Row(
                  children: [
                    _CheckTile(
                      label: "SMS",
                      value: _sms,
                      onChanged: (v) => setState(() => _sms = v),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Izoh
                TextFormField(
                  controller: _izohCtrl,
                  maxLines: 2,
                  decoration: dialogInputDecoration(hintText: "Izoh qoldiring..."),
                ),

                const SizedBox(height: 18),

                // Tugmalar
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE3E6EB),
                            foregroundColor: const Color(0xFF646B75),
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Bekor qilish"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1877F2),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Saqlash"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===== Kichik widgetlar =====

class _CircleIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CircleIconBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _DialogPaymentTabs extends StatelessWidget {
  final PaymentType selected;
  final ValueChanged<PaymentType> onChanged;

  const _DialogPaymentTabs({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = PaymentType.values;
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFE9EAEC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: items.map((item) {
          final isSelected = item == selected;
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => onChanged(item),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF1877F2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: isSelected ? Colors.white : const Color(0xFF444444),
                    ),
                  ),
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

  const _CheckTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onChanged(!value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: value ? const Color(0xFF1877F2) : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value
                      ? const Color(0xFF1877F2)
                      : const Color(0xFFE2E5EA),
                ),
              ),
              child: value
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF2E2E2E))),
          ],
        ),
      ),
    );
  }
}