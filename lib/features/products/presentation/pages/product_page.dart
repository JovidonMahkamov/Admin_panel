import 'dart:io';
import 'package:admin_panel/features/products/presentation/bloc/products_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../dashboard/presentation/widgets/elvated_button_wg.dart';
import '../../domain/entity/product_entity.dart';
import '../bloc/get_products/get_products_bloc.dart';
import '../bloc/get_products/get_products_state.dart';
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
    context.read<GetProductsBloc>().add(GetProductsE());
  }

  void _openAddProductDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AddEditProductDialog(
        title: "Tovar qo‘shish",
        onSave: (newProduct) {
          // Hozircha add API ulanmagan bo‘lsa shundoq qoldiring
          Navigator.pop(context);
        },
      ),
    );
  }

  void _openEditProductDialog(int index, ProductRow product) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AddEditProductDialog(
        title: "Tovarni tahrirlash",
        initial: product,
        onSave: (updated) {
          // Hozircha update API ulanmagan bo‘lsa shundoq qoldiring
          Navigator.pop(context);
        },
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
                    "Haqiqatan ham ushbu tovarni o‘chirmoqchimisiz?\n\n${product.productName}",
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
                        onPressed: () => Navigator.pop(context, true),
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
      // Hozircha delete API ulanmagan bo‘lsa shu joyni keyin Bloc bilan almashtirasiz
    }
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
                            "Tovarlarni boshqarish",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        ElevatedWidget(
                          onPressed: _openAddProductDialog,
                          text: "Tovar qo‘shish",
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
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (state is GetProductsError) {
                          return Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Text(state.message),
                            ),
                          );
                        }

                        if (state is GetProductsSuccess) {
                          final rows = state.productEntity
                              .map((e) => e.toProductRow())
                              .toList();

                          if (rows.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(
                                child: Text("Tovarlar topilmadi"),
                              ),
                            );
                          }

                          return ProductsTable(
                            rows: rows,
                            onEdit: (i, p) => _openEditProductDialog(i, p),
                            onDelete: (i, p) => _confirmDelete(i, p),
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
    );
  }
}

class ProductRow {
  final String productName;
  final String metrPrice;
  final String donaPrice;
  final String packetPrice;
  final String pachka;
  final String metri;
  final String miqdori;
  final String imagePath;

  const ProductRow({
    required this.productName,
    required this.metrPrice,
    required this.donaPrice,
    required this.packetPrice,
    required this.pachka,
    required this.metri,
    required this.miqdori,
    required this.imagePath,
  });

  ProductRow copyWith({
    String? productName,
    String? metrPrice,
    String? donaPrice,
    String? packetPrice,
    String? pachka,
    String? metri,
    String? miqdori,
    String? imagePath,
  }) {
    return ProductRow(
      productName: productName ?? this.productName,
      metrPrice: metrPrice ?? this.metrPrice,
      donaPrice: donaPrice ?? this.donaPrice,
      packetPrice: packetPrice ?? this.packetPrice,
      pachka: pachka ?? this.pachka,
      metri: metri ?? this.metri,
      miqdori: miqdori ?? this.miqdori,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

class ProductsTable extends StatelessWidget {
  final List<ProductRow> rows;
  final void Function(int index, ProductRow product) onEdit;
  final void Function(int index, ProductRow product) onDelete;

  const ProductsTable({
    super.key,
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
              Expanded(flex: 5, child: Text("Tovar Nomi", style: headerStyle)),
              Expanded(flex: 2, child: Text("Narxi metr", style: headerStyle)),
              Expanded(flex: 2, child: Text("Narxi dona", style: headerStyle)),
              Expanded(flex: 2, child: Text("Narxi Pachka", style: headerStyle)),
              Expanded(flex: 2, child: Text("Pochka", style: headerStyle)),
              Expanded(flex: 2, child: Text("Metri", style: headerStyle)),
              Expanded(flex: 2, child: Text("Miqdori", style: headerStyle)),
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
                            _ProductImage(path: r.imagePath),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                r.productName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(flex: 2, child: Text(r.metrPrice)),
                      Expanded(flex: 2, child: Text(r.donaPrice)),
                      Expanded(flex: 2, child: Text(r.packetPrice)),
                      Expanded(flex: 2, child: Text(r.pachka)),
                      Expanded(flex: 2, child: Text(r.metri)),
                      Expanded(flex: 2, child: Text(r.miqdori)),
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
                              tooltip: "O‘chirish",
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

class _ProductImage extends StatelessWidget {
  final String path;

  const _ProductImage({required this.path});

  @override
  Widget build(BuildContext context) {
    final hasFile = path.trim().isNotEmpty && File(path).existsSync();

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: hasFile
          ? Image.file(
        File(path),
        width: 54,
        height: 54,
        fit: BoxFit.cover,
      )
          : Container(
        width: 54,
        height: 54,
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Icon(
          Icons.image,
          size: 20,
          color: Colors.grey.shade600,
        ),
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
      productName: nomi ?? '',
      metrPrice: '${narxMetr ?? 0}',
      donaPrice: '${narxDona ?? 0}',
      packetPrice: '${narxPochka ?? 0}',
      pachka: '${pochka ?? 0}',
      metri: '${metr ?? 0}',
      miqdori: '${miqdor ?? 0}',
      imagePath: rasm ?? '',
    );
  }
}