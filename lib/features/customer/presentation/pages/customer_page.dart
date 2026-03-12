import 'package:admin_panel/features/customer/presentation/bloc/update_customer/update_customer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/get_customer_entity.dart';
import '../bloc/customer_event.dart';
import '../bloc/get_all_customers/get_all_customers_bloc.dart';
import '../bloc/get_all_customers/get_all_customers_state.dart';
import '../bloc/update_customer/update_customer_bloc.dart';
import '../widgets/customer_details_dialog_wg.dart';
import '../widgets/edit_customer_dialog_wg.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetAllCustomersBloc>().add(GetAllCustomersE());
  }

  void _openCustomerDetails(GetCustomerEntity customer) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => CustomerDetailsDialog(
        customer: CustomerRow(
          customerName: customer.fish,
          phone: customer.telefon,
          address: customer.manzil,
          debt: customer.qarzdorlik.toString(),
        ),
        rows: const [],
      ),
    );
  }

  void _openEditCustomerDialog(GetCustomerEntity customer) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => EditCustomerDialog(
        title: "Tahrirlash",
        initial: CustomerRow(
          customerName: customer.fish,
          phone: customer.telefon,
          address: customer.manzil,
          debt: "${customer.qarzdorlik}",
        ),
        onSave: (updatedCustomer) {
          final cleanedDebt = updatedCustomer.debt
              .replaceAll(" ", "");
          context.read<UpdateCustomerBloc>().add(
            UpdateCustomerE(
              id: customer.id,
              fish: updatedCustomer.customerName,
              telefon: updatedCustomer.phone,
              manzil: updatedCustomer.address,
              qarzdorlik: (num.tryParse(cleanedDebt) ?? 0).toInt(),
            ),
          );

          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: BlocListener<UpdateCustomerBloc, UpdateCustomerState>(
        listener: (context, state) {
          if (state is UpdateCustomersSuccess) {
            context.read<GetAllCustomersBloc>().add(GetAllCustomersE());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Mijoz muvaffaqiyatli yangilandi")),
            );
          }
          if (state is UpdateCustomersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Xatolik: ${state.message}")),
            );
          }
        },
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
                        children: const [
                          Expanded(
                            child: Text(
                              "Mijozlar",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1),
                      const SizedBox(height: 10),

                      BlocBuilder<GetAllCustomersBloc, GetAllCustomersState>(
                        builder: (context, state) {
                          if (state is GetAllCustomersLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is GetAllCustomersError) {
                            return Center(
                              child: Text(
                                state.message,
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }

                          if (state is GetAllCustomersSuccess) {
                            final rows = state.getAllCustomersEntity.data;

                            if (rows.isEmpty) {
                              return const Center(
                                child: Text("Mijozlar mavjud emas"),
                              );
                            }

                            return _CustomerTable(
                              rows: rows,
                              onEdit: (index, customer) =>
                                  _openEditCustomerDialog(customer),
                              onRowTap: _openCustomerDetails,
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

class _CustomerTable extends StatelessWidget {
  final List<GetCustomerEntity> rows;
  final void Function(int index, GetCustomerEntity customer) onEdit;
  final ValueChanged<GetCustomerEntity> onRowTap;

  const _CustomerTable({
    required this.rows,
    required this.onEdit,
    required this.onRowTap,
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
              Expanded(flex: 4, child: Text("Mijoz", style: headerStyle)),
              Expanded(
                flex: 2,
                child: Text("Telefon nomer", style: headerStyle),
              ),
              Expanded(flex: 2, child: Text("Manzil", style: headerStyle)),
              Expanded(flex: 2, child: Text("Qarzdorligi", style: headerStyle)),
              Expanded(flex: 2, child: Text("", style: headerStyle)),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade300),

        ...List.generate(rows.length, (index) {
          final r = rows[index];
          final sn = (index + 1).toString().padLeft(2, '0');

          return _ClickableRow(
            onTap: () => onRowTap(r),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 70, child: Text(sn)),
                      Expanded(flex: 4, child: Text(r.fish)),
                      Expanded(flex: 2, child: Text(r.telefon)),
                      Expanded(flex: 2, child: Text(r.manzil)),
                      Expanded(flex: 2, child: Text(r.qarzdorlik.toString())),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onEdit(index, r),
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.edit, color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey.shade200),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _ClickableRow extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _ClickableRow({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.black.withOpacity(0.03),
        splashColor: Colors.black.withOpacity(0.05),
        child: child,
      ),
    );
  }
}

class CustomerRow {
  final String customerName;
  final String phone;
  final String address;
  final String debt;

  const CustomerRow({
    required this.customerName,
    required this.phone,
    required this.address,
    required this.debt,
  });
}
