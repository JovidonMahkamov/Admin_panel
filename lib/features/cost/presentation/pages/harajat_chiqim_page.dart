import 'package:admin_panel/features/cost/domain/entity/create_expense_request_model.dart';
import 'package:admin_panel/features/cost/presentation/bloc/cost_event.dart';
import 'package:admin_panel/features/cost/presentation/bloc/delete_harajat/delete_harajat_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/delete_harajat/delete_harajat_state.dart';
import 'package:admin_panel/features/cost/presentation/bloc/get_harajat/get_harajat_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/get_harajat/get_harajat_state.dart';
import 'package:admin_panel/features/cost/presentation/bloc/post_harajat/post_harajat_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/post_harajat/post_harajat_state.dart';
import 'package:admin_panel/features/cost/presentation/bloc/update_harajat/update_harajat_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/update_harajat/update_harajat_state.dart';
import 'package:admin_panel/features/cost/presentation/widgets/expense_delete_dialog_wg.dart';
import 'package:admin_panel/features/cost/presentation/widgets/expense_form_dialog_wg.dart';
import 'package:admin_panel/features/cost/presentation/widgets/expense_models.dart';
import 'package:admin_panel/features/cost/presentation/widgets/expense_table_wg.dart';
import 'package:admin_panel/features/cost/presentation/widgets/payment_tabs_wg.dart';
import 'package:admin_panel/features/workers/presentation/bloc/get_all_worker/get_all_worker_bloc.dart';
import 'package:admin_panel/features/workers/presentation/bloc/get_all_worker/get_all_worker_state.dart';
import 'package:admin_panel/features/workers/presentation/bloc/worker_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HarajatChiqimPage extends StatefulWidget {
  const HarajatChiqimPage({super.key});

  @override
  State<HarajatChiqimPage> createState() => _HarajatChiqimPageState();
}

class _HarajatChiqimPageState extends State<HarajatChiqimPage> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    // Sahifa ochilganda workerlar va harajatlarni yuklaymiz
    context.read<GetAllWorkerBloc>().add(const GetAllWorkerE());
    context.read<GetHarajatBloc>().add(const GetHarajatE());
  }

  // Workerlarni BlocState dan olamiz
  // GetAllWorkersEntity.data — List<GetWorkerEntity>
  List<WorkerOption> _getWorkers(BuildContext context) {
    final state = context.read<GetAllWorkerBloc>().state;
    if (state is GetAllWorkerSuccess) {
      return state.getAllWorkersEntity.data
          .map((w) => WorkerOption(
        id: w.id.toString(),
        name: w.fish,
        phone: w.telefon,
      ))
          .toList();
    }
    return [];
  }

  // API dan kelgan harajatlarni ExpenseRowData ga o'giramiz
  // CostEntity.data — List<CostItemEntity>
  List<ExpenseRowData> _buildRows(GetHarajatState state) {
    if (state is GetHarajatSuccess) {
      return state.costEntity.data.map((e) {
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

        return ExpenseRowData(
          id: e.id.toString(),
          sana: DateTime.tryParse(e.sana) ?? DateTime.now(),
          paymentType: paymentType,
          workerId: e.ishchiIdField,
          workerName: e.ishchiFish.isNotEmpty ? e.ishchiFish : e.ishchiIdField,
          workerPhone: '',
          summa: e.summa.toInt(),
          currency: CurrencyType.uzs,
          convertatsiya: false,
          foyda: false,
          sms: e.sms,
          izoh: e.izoh,
        );
      }).toList();
    }
    return [];
  }

  List<ExpenseRowData> _filterRows(List<ExpenseRowData> rows) {
    if (selectedTab == 3) return rows;
    final type = switch (selectedTab) {
      0 => PaymentType.naqd,
      1 => PaymentType.terminal,
      2 => PaymentType.click,
      _ => PaymentType.naqd,
    };
    return rows.where((e) => e.paymentType == type).toList();
  }

  Future<void> onAdd(List<WorkerOption> workers) async {
    if (workers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Ishchilar yuklanmadi, qayta urinib ko'ring")),
      );
      return;
    }

    final result = await showDialog<ExpenseFormResult>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ExpenseFormDialogWg(
        title: "Yangi chiqim qo'shish",
        workers: workers,
      ),
    );

    if (result == null || !mounted) return;

    context.read<PostCostBloc>().add(
      PostHarajatE(
        request: CreateExpenseRequestModel(
          ishchiIdField: result.workerId,
          izoh: result.izoh.trim().isEmpty ? '-' : result.izoh.trim(),
          sms: result.sms,
          summa: result.summa,
          tolovTuri: result.paymentType.name,
        ),
      ),
    );
  }

  Future<void> onEdit(ExpenseRowData row, List<WorkerOption> workers) async {
    final result = await showDialog<ExpenseFormResult>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ExpenseFormDialogWg(
        title: "Chiqimni tahrirlash",
        workers: workers,
        initial: row,
      ),
    );

    if (result == null || !mounted) return;

    context.read<UpdateHarajatBloc>().add(
      UpdateHarajatE(
        id: int.tryParse(row.id) ?? 0,
        ishchiId: int.tryParse(result.workerId) ?? 0,
        izoh: result.izoh.trim().isEmpty ? '-' : result.izoh.trim(),
        sms: result.sms,
        summa: result.summa,
        tolovTuri: result.paymentType.name,
      ),
    );
  }

  Future<void> onDelete(ExpenseRowData row) async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const ExpenseDeleteDialogWg(),
    );

    if (ok != true || !mounted) return;

    context.read<DeleteHarajatBloc>().add(
      DeleteHarajatE(id: int.tryParse(row.id) ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // POST muvaffaqiyatli bo'lsa ro'yxatni yangilaymiz
        BlocListener<PostCostBloc, PostHarajatState>(
          listener: (context, state) {
            if (state is PostHarajatSuccess) {
              context.read<GetHarajatBloc>().add(const GetHarajatE());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Harajat muvaffaqiyatli qo'shildi")),
              );
            } else if (state is PostHarajatError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        // DELETE muvaffaqiyatli bo'lsa ro'yxatni yangilaymiz
        BlocListener<DeleteHarajatBloc, DeleteHarajatState>(
          listener: (context, state) {
            if (state is DeleteHarajatSuccess) {
              context.read<GetHarajatBloc>().add(const GetHarajatE());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Harajat o'chirildi")),
              );
            } else if (state is DeleteHarajatError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        // UPDATE muvaffaqiyatli bo'lsa ro'yxatni yangilaymiz
        BlocListener<UpdateHarajatBloc, UpdateHarajatState>(
          listener: (context, state) {
            if (state is UpdateHarajatSuccess) {
              context.read<GetHarajatBloc>().add(const GetHarajatE());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Harajat yangilandi")),
              );
            } else if (state is UpdateHarajatError) {
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
                    child: BlocBuilder<GetHarajatBloc, GetHarajatState>(
                      builder: (context, harajatState) {
                        final workers = _getWorkers(context);
                        final allRows = _buildRows(harajatState);
                        final filteredRows = _filterRows(allRows);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text("Harajat chiqim",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700)),
                                ),
                                SizedBox(
                                  width: 180,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () => onAdd(workers),
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
                              onChanged: (i) =>
                                  setState(() => selectedTab = i),
                            ),
                            const SizedBox(height: 14),

                            // Loading holati
                            if (harajatState is GetHarajatLoading)
                              const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: CircularProgressIndicator(),
                                  )),

                            // Xatolik holati
                            if (harajatState is GetHarajatError)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Text(harajatState.message,
                                          style: const TextStyle(
                                              color: Colors.red)),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () => context
                                            .read<GetHarajatBloc>()
                                            .add(const GetHarajatE()),
                                        child: const Text("Qayta urinish"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            // Ma'lumotlar
                            if (harajatState is GetHarajatSuccess)
                              ExpenseTableWg(
                                rows: filteredRows,
                                onEdit: (row) => onEdit(row, workers),
                                onDelete: onDelete,
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