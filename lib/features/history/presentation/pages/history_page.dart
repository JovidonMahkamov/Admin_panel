import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// O'zing yozgan history bloc/state/event importlarini shu yerga qo'yasan
import 'package:admin_panel/features/history/presentation/bloc/get_history/get_history_bloc.dart';
import 'package:admin_panel/features/history/presentation/bloc/get_history/get_history_state.dart';
import 'package:admin_panel/features/history/presentation/bloc/history_event.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetHistoryBloc>().add(const GetHistoryE());
  }

  String _formatMoney(num value) {
    return "${value.toString()}\$";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetHistoryBloc, GetHistoryState>(
      builder: (context, state) {
        if (state is GetHistoryLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is GetHistoryError) {
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 460),
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(20),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 44,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Xatolik yuz berdi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GetHistoryBloc>().add(const GetHistoryE());
                    },
                    child: const Text("Qayta urinish"),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is GetHistorySuccess) {
          final history = state.historyEntity;
          final rows = history.data;

          return Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 18),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<GetHistoryBloc>().add(const GetHistoryE());
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                            const Text(
                              "Tarix",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Divider(height: 1),
                            const SizedBox(height: 10),
                            _HistoryTable(
                              rows: rows,
                              formatMoney: _formatMoney,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _HistoryTable extends StatelessWidget {
  final List<dynamic> rows;
  final String Function(num value) formatMoney;

  const _HistoryTable({
    required this.rows,
    required this.formatMoney,
  });

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade700,
    );

    if (rows.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                SizedBox(width: 70, child: Text("S/N", style: headerStyle)),
                Expanded(flex: 4, child: Text("Oylar", style: headerStyle)),
                Expanded(flex: 2, child: Text("Yil", style: headerStyle)),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text("Savdolar soni", style: headerStyle),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text("Oylik savdo summasi", style: headerStyle),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade300),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text("Tarix ma’lumotlari hali yo‘q"),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 70, child: Text("S/N", style: headerStyle)),
              Expanded(flex: 4, child: Text("Oylar", style: headerStyle)),
              Expanded(flex: 2, child: Text("Yil", style: headerStyle)),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Savdolar soni", style: headerStyle),
                ),
              ),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Oylik savdo summasi", style: headerStyle),
                ),
              ),
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
                    Expanded(
                      flex: 4,
                      child: Text(
                        r.oy,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(r.yil.toString()),
                    ),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(r.sotuvlarSoni.toString()),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          formatMoney(r.jamiSumma),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
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
}