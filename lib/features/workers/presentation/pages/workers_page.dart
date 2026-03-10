import 'package:admin_panel/features/workers/domain/entity/get_worker_entity.dart';
import 'package:admin_panel/features/workers/presentation/bloc/get_all_worker/get_all_worker_bloc.dart';
import 'package:admin_panel/features/workers/presentation/bloc/get_all_worker/get_all_worker_state.dart';
import 'package:admin_panel/features/workers/presentation/bloc/worker_event.dart';
import 'package:admin_panel/features/workers/presentation/widgets/add_worker_dialog_wg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dashboard/presentation/widgets/elvated_button_wg.dart';
import '../bloc/delete_worker/delete_worker_bloc.dart';
import '../bloc/delete_worker/delete_worker_state.dart';
import '../bloc/update_worker/update_worker_bloc.dart';
import '../bloc/update_worker/update_worker_state.dart';

class WorkersPage extends StatefulWidget {
  const WorkersPage({super.key});

  @override
  State<WorkersPage> createState() => _WorkersPageState();
}

class _WorkersPageState extends State<WorkersPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetAllWorkerBloc>().add(GetAllWorkerE());
  }

  Future<void> _confirmDelete(GetWorkerEntity worker) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "O‘chirishni tasdiqlang",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context, false),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    "Haqiqatan ham ushbu ishchini o‘chirmoqchimisiz?\n\n${worker.fish}",
                    style: const TextStyle(height: 1.3),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Yo‘q"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text("Ha, o‘chirish"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result == true) {
      context.read<DeleteWorkerBloc>().add(DeleteWorkerE(id: worker.id));
    }
  }

  void _openAddWorkerDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const AddEditWorkerDialog(
        initial: null,
        onSave: null,
        title: "Ishchi qo'shish",
      ),
    );
  }
  void _openEditWorkerDialog(GetWorkerEntity worker) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AddEditWorkerDialog(
        title: "Ishchini tahrirlash",
        initial: WorkerFormData(
          id: worker.id,
          fish: worker.fish,
          telefon: worker.telefon,
          login: worker.login,
          parol: '',
        ),
        onSave: (updatedWorker) {
          context.read<UpdateWorkerBloc>().add(
            UpdateWorkerE(
              id: updatedWorker.id!,
              fish: updatedWorker.fish,
              parol: updatedWorker.parol,
              telefon: updatedWorker.telefon, login: '',
            ),
          );
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteWorkerBloc, DeleteWorkerState>(
          listener: (context, state) {
            if (state is DeleteWorkerSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.deleteWorkerResponseEntity.message),
                ),
              );

              context.read<GetAllWorkerBloc>().add(const GetAllWorkerE());
            }

            if (state is DeleteWorkerError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<UpdateWorkerBloc, UpdateWorkerState>(
          listener: (context, state) {
            if (state is UpdateWorkerSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.updateWorkerResponseEntity.message),
                ),
              );

              context.read<GetAllWorkerBloc>().add(const GetAllWorkerE());
              Navigator.pop(context);
            }

            if (state is UpdateWorkerError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],

      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 18),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                        color: Colors.black.withOpacity(0.06),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Ishchilar",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          ElevatedWidget(
                            onPressed: _openAddWorkerDialog,
                            text: "Ishchi qo'shish",
                            backgroundColor: Colors.blueAccent,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1),
                      const SizedBox(height: 10),

                      BlocBuilder<GetAllWorkerBloc, GetAllWorkerState>(
                        builder: (context, state) {
                          if (state is GetAllWorkerLoading) {
                            return const Padding(
                              padding: EdgeInsets.all(40),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (state is GetAllWorkerError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  children: [
                                    Text(
                                      state.message,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.read<GetAllWorkerBloc>().add(
                                          const GetAllWorkerE(),
                                        );
                                      },
                                      child: const Text("Qayta yuklash"),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          if (state is GetAllWorkerSuccess) {
                            final rows = state.getAllWorkersEntity.data;

                            if (rows.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(24),
                                child: Center(
                                  child: Text("Ishchilar mavjud emas"),
                                ),
                              );
                            }

                            return _WorkersTable(
                              rows: rows,
                              onEdit: (worker) => _openEditWorkerDialog(worker),
                              onDelete: (worker) => _confirmDelete(worker),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkersTable extends StatelessWidget {
  final List<GetWorkerEntity> rows;
  final void Function(GetWorkerEntity worker) onEdit;
  final void Function(GetWorkerEntity worker) onDelete;

  const _WorkersTable({
    required this.rows,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade800,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 70, child: Text("S/N", style: headerStyle)),
              Expanded(flex: 4, child: Text("Ishchi", style: headerStyle)),
              Expanded(
                flex: 3,
                child: Text("Ishchining nomeri", style: headerStyle),
              ),
              Expanded(flex: 3, child: Text("Login", style: headerStyle)),
              Expanded(flex: 3, child: Text("Parol", style: headerStyle)),
              Expanded(flex: 3, child: Text("Yaratilgan", style: headerStyle)),
              Expanded(flex: 2, child: Text("", style: headerStyle)),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade300),

        ...List.generate(rows.length, (index) {
          final r = rows[index];
          final sn = (index + 1).toString().padLeft(2, '0');

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    SizedBox(width: 70, child: Text(sn)),
                    Expanded(flex: 4, child: Text(r.fish)),
                    Expanded(flex: 3, child: Text(r.telefon)),
                    Expanded(flex: 3, child: Text(r.login)),
                    Expanded(flex: 3, child: Text(r.parol)),
                    Expanded(flex: 3, child: Text(_formatDate(r.yaratilgan))),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => onEdit(r),
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () => onDelete(r),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
            ],
          );
        }),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day.$month.$year';
  }
}

