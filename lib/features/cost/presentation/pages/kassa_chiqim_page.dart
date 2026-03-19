import 'package:admin_panel/features/cost/domain/entity/get_cash_expense_entity.dart';
import 'package:admin_panel/features/cost/presentation/bloc/cost_event.dart';
import 'package:admin_panel/features/cost/presentation/bloc/delete_kassa/delete_kassa_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/delete_kassa/delete_kassa_state.dart';
import 'package:admin_panel/features/cost/presentation/bloc/get_kassa/get_kassa_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/post_kassa/post_kassa_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/post_kassa/post_kassa_state.dart';
import 'package:admin_panel/features/cost/presentation/bloc/update_kassa/update_kassa_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/update_kassa/update_kassa_state.dart';
import 'package:admin_panel/features/cost/presentation/widgets/expense_delete_dialog_wg.dart';
import 'package:admin_panel/features/cost/presentation/widgets/expense_models.dart';
import 'package:admin_panel/features/cost/presentation/widgets/kassa_expense_form_dialog_wg.dart';
import 'package:admin_panel/features/cost/presentation/widgets/kassa_models.dart';
import 'package:admin_panel/features/cost/presentation/widgets/payment_tabs_wg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KassaChiqimPage extends StatefulWidget {
  const KassaChiqimPage({super.key});

  @override
  State<KassaChiqimPage> createState() => _KassaChiqimPageState();
}

class _KassaChiqimPageState extends State<KassaChiqimPage> {
  int selectedTab = 0;

  // Har bir tab uchun alohida ma'lumotlar
  List<KassaExpenseRowData> _naqdRows = [];
  List<KassaExpenseRowData> _terminalRows = [];
  List<KassaExpenseRowData> _clickRows = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  // 3 ta to'lov turini parallel yuklaymiz
  Future<void> _loadAll() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final useCase = context.read<GetKassaBloc>().getKassaUseCase;

      final results = await Future.wait([
        useCase(tur: 'naqd'),
        useCase(tur: 'terminal'),
        useCase(tur: 'click'),
      ]);

      if (!mounted) return;

      setState(() {
        _naqdRows = _toRows(results[0]);
        _terminalRows = _toRows(results[1]);
        _clickRows = _toRows(results[2]);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Ma'lumotlarni yuklashda xatolik";
        _isLoading = false;
      });
    }
  }

  List<KassaExpenseRowData> _toRows(GetCashExpenseEntity entity) {
    return entity.data.map((e) {
      PaymentType paymentType;
      switch (e.tolovTuri) {
        case 'terminal':
          paymentType = PaymentType.terminal;
          break;
        case 'click':
          paymentType = PaymentType.click;
          break;
        default:
          paymentType = PaymentType.naqd;
      }

      return KassaExpenseRowData(
        id: e.id.toString(),
        sana: DateTime.tryParse(e.sana) ?? DateTime.now(),
        paymentType: paymentType,
        doKon: e.doKon,
        mahsulotlar: e.mahsulotNomi.isNotEmpty ? e.mahsulotNomi.split(', ') : [],
        summa: e.summa,
        sms: e.sms,
        izoh: e.izoh,
      );
    }).toList();
  }

  // Tanlangan tabga mos rowlar
  List<KassaExpenseRowData> get _currentRows {
    switch (selectedTab) {
      case 0:
        return _naqdRows;
      case 1:
        return _terminalRows;
      case 2:
        return _clickRows;
      case 3:
        return [..._naqdRows, ..._terminalRows, ..._clickRows];
      default:
        return _naqdRows;
    }
  }

  Future<void> onAdd() async {
    final result = await showDialog<KassaExpenseFormResult>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const KassaExpenseFormDialogWg(
        title: "Yangi chiqim qo'shish",
      ),
    );

    if (result == null || !mounted) return;

    context.read<PostKassaBloc>().add(PostKassaE(
      doKon: result.doKon,
      izoh: result.izoh,
      mahsulotNomi: result.mahsulotNomi,
      sms: result.sms,
      summa: result.summa,
      tolovTuri: result.paymentType.name,
    ));
  }

  Future<void> onEdit(KassaExpenseRowData row) async {
    final result = await showDialog<KassaExpenseFormResult>(
      context: context,
      barrierDismissible: true,
      builder: (_) => KassaExpenseFormDialogWg(
        title: "Chiqimni tahrirlash",
        initial: row,
      ),
    );

    if (result == null || !mounted) return;

    context.read<UpdateKassaBloc>().add(UpdateKassaE(
      id: int.tryParse(row.id) ?? 0,
      doKon: result.doKon,
      izoh: result.izoh,
      mahsulotNomi: result.mahsulotNomi,
      sms: result.sms,
      summa: result.summa,
      tolovTuri: result.paymentType.name,
    ));
  }

  Future<void> onDelete(KassaExpenseRowData row) async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const ExpenseDeleteDialogWg(),
    );

    if (ok != true || !mounted) return;

    context
        .read<DeleteKassaBloc>()
        .add(DeleteKassaE(id: int.tryParse(row.id) ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PostKassaBloc, PostKassaState>(
          listener: (context, state) {
            if (state is PostKassaSuccess) {
              _loadAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Kassa chiqim qo'shildi")),
              );
            } else if (state is PostKassaError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        BlocListener<DeleteKassaBloc, DeleteKassaState>(
          listener: (context, state) {
            if (state is DeleteKassaSuccess) {
              _loadAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Kassa chiqim o'chirildi")),
              );
            } else if (state is DeleteKassaState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Xatolik yuz berdi")),
              );
            }
          },
        ),
        BlocListener<UpdateKassaBloc, UpdateKassaState>(
          listener: (context, state) {
            if (state is UpdateKassaSuccess) {
              _loadAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Kassa chiqim yangilandi")),
              );
            } else if (state is UpdateKassaError) {
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
                        Icon(Icons.arrow_back_ios_new_rounded,
                            size: 16, color: Color(0xFF1877F2)),
                        SizedBox(width: 6),
                        Text("Orqaga",
                            style: TextStyle(
                                color: Color(0xFF1877F2),
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text("Kassa chiqim",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                            ),
                            SizedBox(
                              width: 180,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: onAdd,
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
                          selectedIndex: selectedTab,
                          onChanged: (i) => setState(() => selectedTab = i),
                        ),
                        const SizedBox(height: 14),
                        if (_isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        if (_errorMessage != null && !_isLoading)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Text(_errorMessage!,
                                      style:
                                      const TextStyle(color: Colors.red)),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: _loadAll,
                                    child: const Text("Qayta urinish"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (!_isLoading && _errorMessage == null)
                          _KassaTableWg(
                            rows: _currentRows,
                            onEdit: onEdit,
                            onDelete: onDelete,
                          ),
                      ],
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

class _KassaTableWg extends StatelessWidget {
  final List<KassaExpenseRowData> rows;
  final ValueChanged<KassaExpenseRowData> onEdit;
  final ValueChanged<KassaExpenseRowData> onDelete;

  const _KassaTableWg({
    required this.rows,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade700,
      fontSize: 12,
    );

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
                  SizedBox(width: 150, child: Text("Do'kon nomi", style: headerStyle)),
                  SizedBox(width: 180, child: Text("Mahsulot", style: headerStyle)),
                  SizedBox(width: 120, child: Text("Summa", style: headerStyle)),
                  SizedBox(width: 180, child: Text("Izoh", style: headerStyle)),
                  const SizedBox(width: 70),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey.shade300),
            if (rows.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: Text("Ma'lumot yo'q",
                    style: TextStyle(color: Colors.grey.shade600)),
              )
            else
              ...rows.map((r) => _KassaRow(
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

class _KassaRow extends StatelessWidget {
  final KassaExpenseRowData row;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _KassaRow({required this.row, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 90, child: Text(formatDate(row.sana), style: const TextStyle(fontSize: 12))),
              SizedBox(width: 110, child: Text(row.paymentType.label, style: const TextStyle(fontSize: 12))),
              SizedBox(width: 150, child: Text(row.doKon, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
              SizedBox(width: 180, child: Text(row.mahsulotlar.join(', '), style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
              SizedBox(width: 120, child: Text(formatAmount(row.summa), style: const TextStyle(fontSize: 12))),
              SizedBox(width: 180, child: Text(row.izoh, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
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