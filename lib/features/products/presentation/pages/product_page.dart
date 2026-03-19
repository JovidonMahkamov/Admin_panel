import 'package:admin_panel/features/products/domain/entity/summary_entity.dart';
import 'package:admin_panel/features/products/presentation/bloc/products_event.dart';
import 'package:admin_panel/features/products/presentation/widgets/product_qr_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dashboard/presentation/widgets/elvated_button_wg.dart';
import '../../domain/entity/product_entity.dart';
import '../bloc/create_product/create_product_bloc.dart';
import '../bloc/delete_product/delete_product_bloc.dart';
import '../bloc/delete_product/delete_product_state.dart';
import '../bloc/get_products/get_products_bloc.dart';
import '../bloc/get_products/get_products_state.dart';
import '../bloc/update_product/update_product_bloc.dart';
import '../bloc/update_product/update_product_state.dart';
import '../utils/product_media_helper.dart';
import '../widgets/add_edit_product_dialog.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetProductsBloc>().add(const GetProductsE());
  }

  Future<void> _openAddProductDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<CreateProductBloc>()),
          BlocProvider.value(value: context.read<UpdateProductBloc>()),
        ],
        child: const AddEditProductDialog(title: "Tovar qo'shish"),
      ),
    );
    if (!mounted) return;
    context.read<GetProductsBloc>().add(const GetProductsE());
  }

  Future<void> _openEditProductDialog(int index, ProductRow product) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<CreateProductBloc>()),
          BlocProvider.value(value: context.read<UpdateProductBloc>()),
        ],
        child: AddEditProductDialog(
          title: "Tovarni tahrirlash",
          initial: product,
        ),
      ),
    );
    if (!mounted) return;
    context.read<GetProductsBloc>().add(const GetProductsE());
  }

  Future<void> _showQrDialog(ProductRow product) async {
    if (product.qrCodePath.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("QR kod topilmadi")),
      );
      return;
    }
    await showDialog(
      context: context,
      builder: (_) => ProductQrDialog(
        productName: product.productName,
        qrCodePath: product.qrCodePath,
      ),
    );
  }

  Future<void> _confirmDelete(int index, ProductRow product) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                          "O'chirishni tasdiqlang",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
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
                    "Haqiqatan ham ushbu tovarni o'chirmoqchimisiz?\n\n${product.productName}",
                    style: const TextStyle(height: 1.3),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Yo'q"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Ha, o'chirish"),
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
      context.read<DeleteProductBloc>().add(DeleteProductE(id: product.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteProductBloc, DeleteProductState>(
          listener: (context, state) {
            if (state is DeleteProductLoading) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Tovar o'chirilmoqda..."),
                  duration: Duration(seconds: 1),
                ),
              );
            }
            if (state is DeleteProductSuccess) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response.message),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<GetProductsBloc>().add(const GetProductsE());
            }
            if (state is DeleteProductError) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<UpdateProductBloc, UpdateProductState>(
          listener: (context, state) {
            if (state is UpdateProductSuccess) {
              context.read<GetProductsBloc>().add(const GetProductsE());
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ===== SUMMARY KARTOCHKALAR =====
                    BlocBuilder<GetProductsBloc, GetProductsState>(
                      builder: (context, state) {
                        if (state is GetProductsSuccess) {
                          return _SummarySection(summary: state.productData.summary);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 16),

                    // ===== TOVARLAR JADVALI =====
                    Container(
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
                                  "Tovarlarni boshqarish",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              ElevatedWidget(
                                onPressed: _openAddProductDialog,
                                text: "Tovar qo'shish",
                                backgroundColor: Colors.blueAccent,
                                textColor: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Divider(height: 1),
                          const SizedBox(height: 10),
                          BlocBuilder<GetProductsBloc, GetProductsState>(
                            builder: (context, state) {
                              if (state is GetProductsLoading) {
                                return const Padding(
                                  padding: EdgeInsets.all(40),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              if (state is GetProductsError) {
                                return Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Center(child: Text(state.message)),
                                );
                              }
                              if (state is GetProductsSuccess) {
                                final rows = state.productEntity
                                    .map((e) => e.toProductRow())
                                    .toList();
                                if (rows.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.all(24),
                                    child: Center(child: Text("Tovarlar topilmadi")),
                                  );
                                }
                                return ProductsTable(
                                  rows: rows,
                                  onEdit: (i, p) => _openEditProductDialog(i, p),
                                  onDelete: (i, p) => _confirmDelete(i, p),
                                  onQrTap: (p) => _showQrDialog(p),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== SUMMARY SECTION =====

class _SummarySection extends StatelessWidget {
  final SummaryEntity summary;

  const _SummarySection({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Umumiy hisobot",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final cards = [
                _SummaryCard(
                  icon: Icons.monetization_on_outlined,
                  label: "Jami narx",
                  value: "${summary.jamiNarx.toStringAsFixed(2)}\$",
                  color: const Color(0xFF0B74E5),
                ),
                _SummaryCard(
                  icon: Icons.straighten,
                  label: "Jami metr",
                  value: "${summary.jamiMetr.toStringAsFixed(2)} m",
                  color: const Color(0xFF16A34A),
                ),
                _SummaryCard(
                  icon: Icons.confirmation_number_outlined,
                  label: "Jami dona",
                  value: "${summary.jamiMiqdor} ta",
                  color: const Color(0xFFD97706),
                ),
                _SummaryCard(
                  icon: Icons.inventory_2_outlined,
                  label: "Jami pachka",
                  value: "${summary.jamiPochka} ta",
                  color: const Color(0xFF7C3AED),
                ),
                _SummaryCard(
                  icon: Icons.category_outlined,
                  label: "Tovarlar soni",
                  value: "${summary.tovarlarSoni} xil",
                  color: const Color(0xFFDB2777),
                ),
              ];

              final itemWidth = constraints.maxWidth < 600
                  ? (constraints.maxWidth - 12) / 2
                  : (constraints.maxWidth - 48) / 5;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: cards
                    .map((c) => SizedBox(width: itemWidth < 120 ? double.infinity : itemWidth, child: c))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ===== ProductRow =====

class ProductRow {
  final int id;
  final String productName;
  final String metrPrice;
  final String donaPrice;
  final String packetPrice;
  final String pachka;
  final String metri;
  final String miqdori;
  final String kelganNarx;
  final String jamiNarx;
  final String imagePath;
  final String qrCodePath;
  final int sotilganMiqdor;
  final double sotilganMetr;
  final int sotilganPochka;
  final DateTime createdAt;

  const ProductRow({
    required this.id,
    required this.productName,
    required this.metrPrice,
    required this.donaPrice,
    required this.packetPrice,
    required this.pachka,
    required this.metri,
    required this.miqdori,
    required this.kelganNarx,
    required this.jamiNarx,
    required this.imagePath,
    required this.qrCodePath,
    required this.createdAt,
    required this.sotilganMiqdor,
    required this.sotilganMetr,
    required this.sotilganPochka,
  });

  ProductRow copyWith({
    int? id,
    String? productName,
    String? metrPrice,
    String? donaPrice,
    String? packetPrice,
    String? pachka,
    String? metri,
    String? miqdori,
    String? kelganNarx,
    String? jamiNarx,
    String? imagePath,
    String? qrCodePath,
    DateTime? createdAt,
    int? sotilganMiqdor,
    double? sotilganMetr,
    int? sotilganPochka,
  }) {
    return ProductRow(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      metrPrice: metrPrice ?? this.metrPrice,
      donaPrice: donaPrice ?? this.donaPrice,
      packetPrice: packetPrice ?? this.packetPrice,
      pachka: pachka ?? this.pachka,
      metri: metri ?? this.metri,
      miqdori: miqdori ?? this.miqdori,
      kelganNarx: kelganNarx ?? this.kelganNarx,
      jamiNarx: jamiNarx ?? this.jamiNarx,
      imagePath: imagePath ?? this.imagePath,
      qrCodePath: qrCodePath ?? this.qrCodePath,
      createdAt: createdAt ?? this.createdAt,
      sotilganMetr: sotilganMetr ?? this.sotilganMetr,
      sotilganMiqdor: sotilganMiqdor ?? this.sotilganMiqdor,
      sotilganPochka: sotilganPochka ?? this.sotilganPochka,
    );
  }
}

// ===== Jadval =====

class ProductsTable extends StatelessWidget {
  final List<ProductRow> rows;
  final void Function(int index, ProductRow product) onEdit;
  final void Function(int index, ProductRow product) onDelete;
  final void Function(ProductRow product) onQrTap;

  const ProductsTable({
    super.key,
    required this.rows,
    required this.onEdit,
    required this.onDelete,
    required this.onQrTap,
  });

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade800,
      fontSize: 14,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth = constraints.maxWidth < 1100 ? 1100.0 : constraints.maxWidth;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Text("S/N", style: headerStyle)),
                      Expanded(flex: 5, child: Text("Tovar Nomi", style: headerStyle)),
                      Expanded(flex: 2, child: Text("Narxi", style: headerStyle)),
                      Expanded(flex: 2, child: Text("Miqdor", style: headerStyle)),
                      Expanded(flex: 2, child: Text("Kelgan narx", style: headerStyle)),
                      Expanded(flex: 2, child: Text("Jami narx", style: headerStyle)),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Sotildi",
                          style: headerStyle.copyWith(color: Colors.red.shade700),
                        ),
                      ),
                      Expanded(flex: 2, child: Text("QR kod", style: headerStyle)),
                      Expanded(flex: 2, child: Text("", style: headerStyle)),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey.shade300),
                ...List.generate(rows.length, (index) {
                  final r = rows[index];
                  return _HoverRow(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        (index + 1).toString().padLeft(2, '0'),
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    _ProductImage(path: r.imagePath),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        r.productName,
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Metr: ${r.metrPrice}", style: const TextStyle(fontSize: 14)),
                                    Text("Dona: ${r.donaPrice}", style: const TextStyle(fontSize: 14)),
                                    Text("Pachka: ${r.packetPrice}", style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Metr: ${r.metri}", style: const TextStyle(fontSize: 14)),
                                    Text("Dona: ${r.miqdori}", style: const TextStyle(fontSize: 14)),
                                    Text("Pachka: ${r.pachka}", style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                              Expanded(flex: 2, child: Text(r.kelganNarx)),
                              Expanded(flex: 2, child: Text(r.jamiNarx)),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Metr: ${r.sotilganMetr}", style: const TextStyle(fontSize: 14)),
                                    Text('Dona: ${r.sotilganMiqdor}', style: const TextStyle(fontSize: 14)),
                                    Text('Pochka: ${r.sotilganPochka}', style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                  onPressed: () => onQrTap(r),
                                  icon: const Icon(Icons.qr_code),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      onPressed: () => onEdit(index, r),
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      tooltip: "Tahrirlash",
                                    ),
                                    IconButton(
                                      onPressed: () => onDelete(index, r),
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      tooltip: "O'chirish",
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
            ),
          ),
        );
      },
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String path;

  const _ProductImage({required this.path});

  @override
  Widget build(BuildContext context) {
    final imageUrl = ProductMediaHelper.fullUrl(path);
    if (imageUrl.isEmpty) {
      return Container(
        width: 54,
        height: 54,
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Icon(Icons.image, size: 20, color: Colors.grey.shade600),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl,
        width: 54,
        height: 54,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: 54,
            height: 54,
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: Icon(Icons.broken_image, size: 20, color: Colors.grey.shade600),
          );
        },
      ),
    );
  }
}

class _HoverRow extends StatelessWidget {
  final Widget child;

  const _HoverRow({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        hoverColor: Colors.black.withOpacity(0.03),
        splashColor: Colors.black.withOpacity(0.04),
        child: child,
      ),
    );
  }
}

extension ProductEntityMapper on ProductEntity {
  ProductRow toProductRow() {
    return ProductRow(
      id: id,
      productName: nomi,
      metrPrice: narxMetr ?? '',
      donaPrice: narxDona ?? '',
      packetPrice: narxPochka ?? '',
      pachka: pochka ?? '',
      metri: metr ?? '',
      miqdori: miqdor ?? '',
      kelganNarx: kelganNarx ?? '',
      jamiNarx: jamiNarx ?? '',
      imagePath: rasm ?? '',
      qrCodePath: qrKod ?? '',
      createdAt: yaratilgan,
      sotilganMiqdor: sotilganMiqdor ?? 0,
      sotilganMetr: sotilganMetr ?? 0,
      sotilganPochka: sotilganPochka ?? 0,
    );
  }
}