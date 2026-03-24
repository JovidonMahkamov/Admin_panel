import 'package:admin_panel/features/balans/presentation/bloc/balans_event.dart';
import 'package:admin_panel/features/balans/presentation/bloc/get_balans/balans_bloc.dart';
import 'package:admin_panel/features/balans/presentation/bloc/get_balans/balans_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BalansPage extends StatefulWidget {
  const BalansPage({super.key});

  @override
  State<BalansPage> createState() => _BalansPageState();
}

class _BalansPageState extends State<BalansPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetBalansBloc>().add(const GetBalansE());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),
          BlocBuilder<GetBalansBloc, GetBalansState>(
            builder: (context, state) {
              if (state is GetBalansLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GetBalansError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.message,
                          style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context
                            .read<GetBalansBloc>()
                            .add(const GetBalansE()),
                        child: const Text("Qayta urinish"),
                      ),
                    ],
                  ),
                );
              }

              if (state is GetBalansSuccess) {
                final b = state.balans;
                final isManfiy = b.qoldiq < 0;

                return RefreshIndicator(
                  onRefresh: () async =>
                      context.read<GetBalansBloc>().add(const GetBalansE()),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: isManfiy
                                ? const Color(0xFFFFEEEE)
                                : const Color(0xFFEEF8F0),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isManfiy
                                  ? Colors.red.shade200
                                  : Colors.green.shade200,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isManfiy
                                        ? Icons.trending_down_rounded
                                        : Icons.trending_up_rounded,
                                    color: isManfiy
                                        ? Colors.red
                                        : Colors.green.shade700,
                                    size: 28.sp,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "Joriy Balans",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isManfiy
                                          ? Colors.red.shade700
                                          : Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                "${b.qoldiq.toStringAsFixed(2)}\$",
                                style: TextStyle(
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.w800,
                                  color: isManfiy
                                      ? Colors.red
                                      : Colors.green.shade800,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                isManfiy
                                    ? "Chiqimlar savdodan ko'p"
                                    : "Savdo chiqimlardan ko'p",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: isManfiy
                                      ? Colors.red.shade400
                                      : Colors.green.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // ===== SAVDO VA CHIQIM KARTOCHKALARI =====
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final cards = [
                              _BalansCard(
                                icon: Icons.arrow_upward_rounded,
                                iconColor: Colors.green.shade700,
                                iconBg: Colors.green.shade50,
                                label: "Jami Savdo",
                                amount: b.savdoJami,
                                isNegative: false,
                              ),
                              _BalansCard(
                                icon: Icons.arrow_downward_rounded,
                                iconColor: Colors.red.shade700,
                                iconBg: Colors.red.shade50,
                                label: "Jami Chiqim",
                                amount: b.chiqimJami,
                                isNegative: false,
                              ),
                            ];

                            if (constraints.maxWidth < 600) {
                              return Column(
                                children: cards
                                    .map((c) => Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: c,
                                ))
                                    .toList(),
                              );
                            }

                            return Row(
                              children: [
                                Expanded(child: cards[0]),
                                SizedBox(width: 12.w),
                                Expanded(child: cards[1]),
                              ],
                            );
                          },
                        ),

                        SizedBox(height: 16.h),

                        // ===== CHIQIM TAFSILOTI =====
                        Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Chiqim tafsiloti",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF111827),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              _DetailRow(
                                label: "Ishchi oylik chiqimi",
                                amount: b.xarajatJami,
                                icon: Icons.person_outline_rounded,
                                color: Colors.orange.shade700,
                              ),
                              Divider(
                                  height: 24.h, color: Colors.grey.shade100),
                              _DetailRow(
                                label: "Harajat chiqimi",
                                amount: b.kassaJami,
                                icon: Icons.shopping_cart_outlined,
                                color: Colors.purple.shade700,
                              ),
                              Divider(
                                  height: 24.h, color: Colors.grey.shade100),
                              _DetailRow(
                                label: "Dkon chiqimi",
                                amount: b.dokonJami,
                                icon: Icons.store_outlined,
                                color: Colors.teal.shade700,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _BalansCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final double amount;
  final bool isNegative;

  const _BalansCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.amount,
    required this.isNegative,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 22.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 12.sp, color: Colors.grey.shade600)),
                SizedBox(height: 4.h),
                Text(
                  "${amount.toStringAsFixed(2)}\$",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;

  const _DetailRow({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: color, size: 18.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(label,
              style: TextStyle(
                  fontSize: 14.sp, color: const Color(0xFF374151))),
        ),
        Text(
          "${amount.toStringAsFixed(2)}\$",
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: Colors.red.shade700,
          ),
        ),
      ],
    );
  }
}