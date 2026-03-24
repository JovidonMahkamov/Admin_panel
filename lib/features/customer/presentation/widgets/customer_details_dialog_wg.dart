import 'package:admin_panel/features/customer/domain/entity/get_customer_detail_entity.dart';
import 'package:admin_panel/features/customer/presentation/bloc/customer_event.dart';
import 'package:admin_panel/features/customer/presentation/bloc/get_customer/get_customer_bloc.dart';
import 'package:admin_panel/features/customer/presentation/bloc/get_customer/get_customer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerDetailsDialog extends StatefulWidget {
  final int customerId;
  final String customerName;

  const CustomerDetailsDialog({
    super.key,
    required this.customerId,
    required this.customerName,
  });

  @override
  State<CustomerDetailsDialog> createState() => _CustomerDetailsDialogState();
}

class _CustomerDetailsDialogState extends State<CustomerDetailsDialog> {
  @override
  void initState() {
    super.initState();
    context
        .read<GetCustomerBloc>()
        .add(GetCustomersE(id: widget.customerId));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1150, minWidth: 900),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: BlocBuilder<GetCustomerBloc, GetCustomerState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.customerName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child:
                          Icon(Icons.close, color: Colors.red, size: 18),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Loading holati
                  if (state is GetCustomerLoading)
                    const Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(),
                    ),

                  // Xatolik holati
                  if (state is GetCustomerError)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  // Ma'lumotlar
                  if (state is GetCustomerSuccess) ...[
                    _CustomerInfoBar(data: state.getCustomerDetailEntity.data),
                    const SizedBox(height: 12),
                    Flexible(
                      child: SingleChildScrollView(
                        child: _SotuvlarTable(
                          sotuvlar:
                          state.getCustomerDetailEntity.data.sotuvlar,
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ===== Info bar — telefon, manzil, qarz =====

class _CustomerInfoBar extends StatelessWidget {
  final CustomerDetailDataEntity data;

  const _CustomerInfoBar({required this.data});

  @override
  Widget build(BuildContext context) {
    Widget chip(String label, String value) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Text(
                "$label: ",
                style:
                TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        chip("Telefon", data.telefon),
        const SizedBox(width: 10),
        chip("Manzil", data.manzil),
        const SizedBox(width: 10),
        chip("Qarzi", data.qarzdorlik.toString()),
        const SizedBox(width: 10),
        chip("Mijoz turi", data.mijozTuri),
      ],
    );
  }
}

// ===== Sotuvlar jadvali =====

class _SotuvlarTable extends StatelessWidget {
  final List<MijozSotuvEntity> sotuvlar;

  const _SotuvlarTable({required this.sotuvlar});

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 12.5,
      color: Colors.grey.shade700,
    );

    if (sotuvlar.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text("Sotuvlar mavjud emas",
              style: TextStyle(color: Colors.grey.shade600)),
        ),
      );
    }

    return Column(
      children: [
        // Jadval header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              SizedBox(width: 90, child: Text("Sana", style: headerStyle)),
              SizedBox(
                  width: 100,
                  child: Text("To'lov turi", style: headerStyle)),
              Expanded(
                  flex: 4,
                  child: Text("Tovar nomi", style: headerStyle)),
              SizedBox(
                  width: 70, child: Text("Metr", style: headerStyle)),
              SizedBox(
                  width: 70, child: Text("Dona", style: headerStyle)),
              SizedBox(
                  width: 70, child: Text("Pachka", style: headerStyle)),
              SizedBox(
                  width: 100,
                  child: Text("Narx", style: headerStyle)),
              SizedBox(
                  width: 100,
                  child: Text("Jami", style: headerStyle)),
              SizedBox(
                  width: 100,
                  child: Text("To'langan", style: headerStyle)),
              SizedBox(
                  width: 80, child: Text("Qarz", style: headerStyle)),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade300),

        // Sotuvlar
        ...sotuvlar.expand((sotuv) {
          return sotuv.mahsulotlar.map((mahsulot) {
            return _SotuvRow(
              sotuv: sotuv,
              mahsulot: mahsulot,
              showSotuvInfo: sotuv.mahsulotlar.indexOf(mahsulot) == 0,
            );
          }).toList();
        }),
      ],
    );
  }
}

// ===== QAYTARISHLAR BO'LIMI =====
class _QaytarishlarTable extends StatelessWidget {
  final List<MijozQaytarishEntity> qaytarishlar;
  const _QaytarishlarTable({required this.qaytarishlar});

  @override
  Widget build(BuildContext context) {
    if (qaytarishlar.isEmpty) return const SizedBox.shrink();

    final headerStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.keyboard_return_rounded,
                  color: Colors.red.shade600, size: 16),
            ),
            const SizedBox(width: 8),
            const Text(
              "Qaytarishlar",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "-\${qaytarishlar.fold<double>(0, (s, q) => s + q.jamiUsd).toStringAsFixed(2)}\$",
                style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w800,
                    fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(width: 90, child: Text("Sana", style: headerStyle)),
              SizedBox(width: 90, child: Text("To'lov turi", style: headerStyle)),
              SizedBox(width: 70, child: Text("Metr", style: headerStyle)),
              SizedBox(width: 70, child: Text("Pachka", style: headerStyle)),
              SizedBox(width: 90, child: Text("Narx", style: headerStyle)),
              SizedBox(width: 100, child: Text("Jami", style: headerStyle)),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade300),
        ...qaytarishlar.map((q) => _QaytarishRow(qaytarish: q)).toList(),
      ],
    );
  }
}

class _QaytarishRow extends StatelessWidget {
  final MijozQaytarishEntity qaytarish;
  const _QaytarishRow({required this.qaytarish});

  Color _payColor(String turi) {
    switch (turi) {
      case 'terminal': return const Color(0xFF2F80ED);
      case 'click':    return const Color(0xFF27AE60);
      default:         return const Color(0xFFE67E22);
    }
  }

  String _formatDate(String? sana) {
    if (sana == null) return '';
    try {
      final d = DateTime.parse(sana);
      return '\${d.day.toString().padLeft(2,"0")}.\${d.month.toString().padLeft(2,"0")}.\${d.year}';
    } catch (_) { return sana; }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...qaytarish.elementlar.map((el) {
          final isFirst = qaytarish.elementlar.indexOf(el) == 0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(
                    isFirst ? _formatDate(qaytarish.sana) : '',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: isFirst ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _payColor(qaytarish.tolovTuri).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      qaytarish.tolovTuri,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _payColor(qaytarish.tolovTuri)),
                    ),
                  ) : const SizedBox.shrink(),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    el.metr > 0 ? "\${el.metr}m" : '-',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    el.pachtka > 0 ? "\${el.pachtka}" : '-',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    "\${el.narxUsd}\$",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    isFirst ? "-\${qaytarish.jamiUsd}\$" : '',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.red.shade600),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }
}

class _SotuvRow extends StatelessWidget {
  final MijozSotuvEntity sotuv;
  final SotuvMahsulotEntity mahsulot;
  final bool showSotuvInfo;

  const _SotuvRow({
    required this.sotuv,
    required this.mahsulot,
    required this.showSotuvInfo,
  });

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d.$m.$y';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              // Sana — faqat birinchi mahsulotda
              SizedBox(
                width: 90,
                child: Text(
                  showSotuvInfo ? _formatDate(sotuv.sana) : '',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              // To'lov turi — faqat birinchi mahsulotda
              SizedBox(
                width: 100,
                child: showSotuvInfo
                    ? Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _paymentColor(sotuv.tolovTuri)
                        .withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    sotuv.tolovTuri,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _paymentColor(sotuv.tolovTuri),
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              ),
              // Tovar nomi + rasm
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: mahsulot.tovarRasm != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://olampardalar.uz${mahsulot.tovarRasm}',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.image_not_supported,
                            size: 16,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      )
                          : Icon(Icons.inventory_2_outlined,
                          size: 16, color: Colors.grey.shade500),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        mahsulot.tovarNomi,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  width: 70,
                  child: Text(mahsulot.metr.toString(),
                      style: const TextStyle(fontSize: 12))),
              SizedBox(
                  width: 70,
                  child: Text(mahsulot.miqdor.toString(),
                      style: const TextStyle(fontSize: 12))),
              SizedBox(
                  width: 70,
                  child: Text(mahsulot.pochka.toString(),
                      style: const TextStyle(fontSize: 12))),
              SizedBox(
                  width: 100,
                  child: Text(mahsulot.narx.toString(),
                      style: const TextStyle(fontSize: 12))),
              SizedBox(
                  width: 100,
                  child: Text(mahsulot.jami.toString(),
                      style: const TextStyle(fontSize: 12))),
              // To'langan — faqat birinchi mahsulotda
              SizedBox(
                width: 100,
                child: Text(
                  showSotuvInfo ? sotuv.tolovQilingan.toString() : '',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              // Qarz — faqat birinchi mahsulotda, qizil rangda
              SizedBox(
                width: 80,
                child: showSotuvInfo
                    ? Text(
                  sotuv.qarz.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: sotuv.qarz > 0
                        ? Colors.red
                        : Colors.green,
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }

  Color _paymentColor(String tur) {
    switch (tur) {
      case 'terminal':
        return const Color(0xFF2F80ED);
      case 'click':
        return const Color(0xFF27AE60);
      default:
        return const Color(0xFFE67E22);
    }
  }
}