import 'package:admin_panel/features/cost/domain/entity/dokon_chiqim_entity.dart';
import 'package:admin_panel/features/cost/presentation/bloc/cost_event.dart';
import 'package:admin_panel/features/cost/presentation/bloc/dokon_chiqim/dokon_chiqim_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/dokon_chiqim/dokon_chiqim_state.dart';
import 'package:admin_panel/features/cost/presentation/widgets/expense_delete_dialog_wg.dart';
import 'package:admin_panel/features/cost/presentation/widgets/expense_models.dart';
import 'package:admin_panel/features/cost/presentation/widgets/payment_tabs_wg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DokonChiqimPage extends StatefulWidget {
  const DokonChiqimPage({super.key});

  @override
  State<DokonChiqimPage> createState() => _DokonChiqimPageState();
}

class _DokonChiqimPageState extends State<DokonChiqimPage> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<GetDokonChiqimBloc>().add(const GetDokonChiqimE());
  }

  List<DokonChiqimEntity> _filterRows(List<DokonChiqimEntity> items) {
    if (_selectedTab == 3) return items;
    final type = switch (_selectedTab) {
      0 => 'naqd',
      1 => 'terminal',
      2 => 'click',
      _ => 'naqd',
    };
    return items.where((e) => e.tolovTuri == type).toList();
  }

  Future<void> _onAdd() async {
    final result = await showDialog<_DokonChiqimFormResult>(
      context: context,
      builder: (_) => const _DokonChiqimFormDialog(title: "Yangi chiqim qo'shish"),
    );
    if (result == null || !mounted) return;
    context.read<PostDokonChiqimBloc>().add(PostDokonChiqimE(
      tolovTuri: result.tolovTuri,
      summa: result.summa,
      izoh: result.izoh,
      tavsif: result.tavsif,
    ));
  }

  Future<void> _onEdit(DokonChiqimEntity row) async {
    final result = await showDialog<_DokonChiqimFormResult>(
      context: context,
      builder: (_) => _DokonChiqimFormDialog(
        title: "Chiqimni tahrirlash",
        initial: row,
      ),
    );
    if (result == null || !mounted) return;
    context.read<PatchDokonChiqimBloc>().add(PatchDokonChiqimE(
      id: row.id,
      tolovTuri: result.tolovTuri,
      summa: result.summa,
      izoh: result.izoh,
      tavsif: result.tavsif,
    ));
  }

  Future<void> _onDelete(DokonChiqimEntity row) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => const ExpenseDeleteDialogWg(),
    );
    if (ok != true || !mounted) return;
    context.read<DeleteDokonChiqimBloc>().add(DeleteDokonChiqimE(id: row.id));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PostDokonChiqimBloc, PostDokonChiqimState>(
          listener: (context, state) {
            if (state is PostDokonChiqimSuccess) {
              _load();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Chiqim qo'shildi")),
              );
            } else if (state is PostDokonChiqimError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        BlocListener<PatchDokonChiqimBloc, PatchDokonChiqimState>(
          listener: (context, state) {
            if (state is PatchDokonChiqimSuccess) {
              _load();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Chiqim yangilandi")),
              );
            } else if (state is PatchDokonChiqimError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        BlocListener<DeleteDokonChiqimBloc, DeleteDokonChiqimState>(
          listener: (context, state) {
            if (state is DeleteDokonChiqimSuccess) {
              _load();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Chiqim o'chirildi")),
              );
            } else if (state is DeleteDokonChiqimError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        body: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 6),
              // Orqaga tugmasi
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF1877F2)),
                        SizedBox(width: 6),
                        Text("Orqaga",
                            style: TextStyle(
                                color: Color(0xFF1877F2), fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: BlocBuilder<GetDokonChiqimBloc, GetDokonChiqimState>(
                      builder: (context, state) {
                        final items = state is GetDokonChiqimSuccess ? state.items : <DokonChiqimEntity>[];
                        final filtered = _filterRows(items);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header
                            Row(
                              children: [
                                const Expanded(
                                  child: Text("Do'kon chiqim",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                                ),
                                SizedBox(
                                  width: 180,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: _onAdd,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1877F2),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: const StadiumBorder(),
                                    ),
                                    child: const Text("Chiqim qo'shish"),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            PaymentTabsWg(
                              selectedIndex: _selectedTab,
                              onChanged: (i) => setState(() => _selectedTab = i),
                            ),
                            const SizedBox(height: 14),

                            if (state is GetDokonChiqimLoading)
                              const Center(
                                  child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: CircularProgressIndicator())),

                            if (state is GetDokonChiqimError)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Text(state.message,
                                          style: const TextStyle(color: Colors.red)),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: _load,
                                        child: const Text("Qayta urinish"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            if (state is GetDokonChiqimSuccess)
                              _DokonChiqimTable(
                                rows: filtered,
                                onEdit: _onEdit,
                                onDelete: _onDelete,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== JADVAL =====
class _DokonChiqimTable extends StatelessWidget {
  final List<DokonChiqimEntity> rows;
  final ValueChanged<DokonChiqimEntity> onEdit;
  final ValueChanged<DokonChiqimEntity> onDelete;

  const _DokonChiqimTable({required this.rows, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
        fontWeight: FontWeight.w700, color: Colors.grey.shade700, fontSize: 12);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 900),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  SizedBox(width: 90, child: Text("Sana", style: headerStyle)),
                  SizedBox(width: 110, child: Text("To'lov turi", style: headerStyle)),
                  SizedBox(width: 130, child: Text("Summa", style: headerStyle)),
                  SizedBox(width: 200, child: Text("Izoh", style: headerStyle)),
                  SizedBox(width: 250, child: Text("Tavsif", style: headerStyle)),
                  const SizedBox(width: 70),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey.shade300),
            if (rows.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: Text("Ma'lumot yo'q", style: TextStyle(color: Colors.grey.shade600)),
              )
            else
              ...rows.map((r) => _DokonChiqimRow(
                row: r,
                onEdit: () => onEdit(r),
                onDelete: () => onDelete(r),
              )),
          ],
        ),
      ),
    );
  }
}

class _DokonChiqimRow extends StatelessWidget {
  final DokonChiqimEntity row;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DokonChiqimRow({required this.row, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final sana = DateTime.tryParse(row.sana) ?? DateTime.now();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 90, child: Text(formatDate(sana), style: const TextStyle(fontSize: 12))),
              SizedBox(width: 110, child: Text(row.tolovTuri, style: const TextStyle(fontSize: 12))),
              SizedBox(width: 130, child: Text(formatAmount(row.summa), style: const TextStyle(fontSize: 12))),
              SizedBox(
                  width: 200,
                  child: Text(row.izoh ?? '-',
                      style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
              SizedBox(
                  width: 250,
                  child: Text(row.tavsif ?? '-',
                      style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
              SizedBox(
                width: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _IconInk(icon: Icons.edit_outlined, color: const Color(0xFF1877F2), onTap: onEdit),
                    const SizedBox(width: 4),
                    _IconInk(icon: Icons.delete_outline_rounded, color: Colors.red, onTap: onDelete),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }
}

class _IconInk extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IconInk({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}

// ===== FORMA DIALOGI =====
class _DokonChiqimFormResult {
  final String tolovTuri;
  final double summa;
  final String? izoh;
  final String? tavsif;

  const _DokonChiqimFormResult({
    required this.tolovTuri,
    required this.summa,
    this.izoh,
    this.tavsif,
  });
}

class _DokonChiqimFormDialog extends StatefulWidget {
  final String title;
  final DokonChiqimEntity? initial;

  const _DokonChiqimFormDialog({required this.title, this.initial});

  @override
  State<_DokonChiqimFormDialog> createState() => _DokonChiqimFormDialogState();
}

class _DokonChiqimFormDialogState extends State<_DokonChiqimFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _tolovTuri;
  late final TextEditingController _summaCtrl;
  late final TextEditingController _izohCtrl;
  late final TextEditingController _tavsifCtrl;

  @override
  void initState() {
    super.initState();
    _tolovTuri = widget.initial?.tolovTuri ?? 'naqd';
    _summaCtrl = TextEditingController(
      text: widget.initial != null ? widget.initial!.summa.toString() : '',
    );
    _izohCtrl = TextEditingController(text: widget.initial?.izoh ?? '');
    _tavsifCtrl = TextEditingController(text: widget.initial?.tavsif ?? '');
  }

  @override
  void dispose() {
    _summaCtrl.dispose();
    _izohCtrl.dispose();
    _tavsifCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final raw = _summaCtrl.text.replaceAll(',', '.');
    final summa = double.tryParse(raw) ?? 0;
    if (summa <= 0) return;

    Navigator.pop(
      context,
      _DokonChiqimFormResult(
        tolovTuri: _tolovTuri,
        summa: summa,
        izoh: _izohCtrl.text.trim().isEmpty ? null : _izohCtrl.text.trim(),
        tavsif: _tavsifCtrl.text.trim().isEmpty ? null : _tavsifCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Text(widget.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF474747))),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close, color: Colors.red)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // To'lov turi
                Container(
                  height: 38,
                  decoration: BoxDecoration(
                      color: const Color(0xFFE9EAEC),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: ['naqd', 'terminal', 'click'].map((t) {
                      final selected = _tolovTuri == t;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _tolovTuri = t),
                          child: Container(
                            decoration: BoxDecoration(
                              color: selected ? const Color(0xFF1877F2) : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              t[0].toUpperCase() + t.substring(1),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: selected ? Colors.white : const Color(0xFF444)),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),

                // Summa
                TextFormField(
                  controller: _summaCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))],
                  decoration: dialogInputDecoration(hintText: "Summa (12563.50)"),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Summani kiriting";
                    final n = double.tryParse(v.replaceAll(',', '.')) ?? 0;
                    if (n <= 0) return "Summa noto'g'ri";
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Izoh
                TextFormField(
                  controller: _izohCtrl,
                  decoration: dialogInputDecoration(hintText: "Izoh (ixtiyoriy)"),
                ),
                const SizedBox(height: 14),

                // Tavsif
                TextFormField(
                  controller: _tavsifCtrl,
                  maxLines: 2,
                  decoration: dialogInputDecoration(
                      hintText: "Tavsif — do'kon nomi, kommunalka, gaz... (ixtiyoriy)"),
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
                          onPressed: _save,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}