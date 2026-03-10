import 'package:admin_panel/features/customer/presentation/widgets/customer_details_dialog_wg.dart';
import 'package:admin_panel/features/customer/presentation/widgets/edit_customer_dialog_wg.dart';
import 'package:flutter/material.dart';


class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  void _openCustomerDetails(CustomerRow customer) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => CustomerDetailsDialog(
        customer: customer,
        rows: const [
          CustomerDebtItem(
            productName: "0422 Senior",
            metr: "50M",
            dona: "-",
            packet: "-",
            debtPrice: "70\$",
            takenTime: "02.19.2026/17:23",
            imageAsset: "assets/images/product.png",
          ),
          CustomerDebtItem(
            productName: "Maxsulot 2",
            metr: "-",
            dona: "10",
            packet: "-",
            debtPrice: "500 000 so'm",
            takenTime: "02.19.2026/18:10",
            imageAsset: "assets/images/product.png",
          ),
        ],
      ),
    );
  }


  final List<CustomerRow> _rows = [
    CustomerRow(
      customerName: "Aliyev Anvar Alisher o‘g‘li",
      phone: "+998 566 12 22",
      address: 'Yakkasaroy',
      debt: '500 000',

    ),
    CustomerRow(
      customerName: "Executive Director",
      phone: "+998 566 12 22",
      address: 'Chilonzor',
      debt: '2 000 000',

    ),
  ];

  void _openEditCustomerDialog(int index, CustomerRow customer) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => EditCustomerDialog(
        title: "Tahrirlash",
        initial: customer,
        onSave: (updatedCustomer) {
          setState(() => _rows[index] = updatedCustomer);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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

                    _CustomerTable(
                      rows: _rows,
                      onEdit: (index, worker) => _openEditCustomerDialog(index, worker),
                      onRowTap: (customer) => _openCustomerDetails(customer),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
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

class _CustomerTable extends StatelessWidget {
  final List<CustomerRow> rows;
  final void Function(int index, CustomerRow customer) onEdit;
  final ValueChanged<CustomerRow> onRowTap;

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
              Expanded(flex: 2, child: Text("Telefon nomer", style: headerStyle)),
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
                      Expanded(flex: 4, child: Text(r.customerName)),
                      Expanded(flex: 2, child: Text(r.phone)),
                      Expanded(flex: 2, child: Text(r.address)),
                      Expanded(flex: 2, child: Text(r.debt)),

                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => onEdit(index, r),
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.edit, color: Colors.blue),
                              ),
                            ),
                          ],
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

  const _ClickableRow({
    required this.child,
    required this.onTap,
  });

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


