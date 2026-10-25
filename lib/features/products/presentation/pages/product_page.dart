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
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<GetProductsBloc>().add(const GetProductsE());
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
                    BlocBuilder<GetProductsBloc, GetProductsState>(
                      builder: (context, state) {
                        if (state is GetProductsSuccess) {
                          return _SummarySection(summary: state.productData.summary);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 16),
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
                          TextField(
                            controller: _searchCtrl,
                            decoration: InputDecoration(
                              hintText: "Tovar nomi yoki kodi bo'yicha qidirish...",
                              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                              prefixIcon: const Icon(Icons.search, color: Colors.grey),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                icon: const Icon(Icons.close, color: Colors.grey),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                                  : null,
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF0B74E5)),
                              ),
                            ),
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
                                final allRows = state.productEntity
                                    .map((e) => e.toProductRow())
                                    .toList();
                                final rows = _searchQuery.isEmpty
                                    ? allRows
                                    : allRows.where((r) =>
                                r.productName.toLowerCase().contains(_searchQuery) ||
                                    r.qrCodePath.toLowerCase().contains(_searchQuery) ||
                                    r.metrPrice.toLowerCase().contains(_searchQuery)
                                ).toList();
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
                  icon: Icons.price_check_rounded,
                  label: "Sotish narxi",
                  value: "${summary.adminJamiNarx.toStringAsFixed(2)}\$",
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
  final String sotishNarxMetr;

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
    this.sotishNarxMetr = '',
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
    String? sotishNarxMetr,
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
      sotishNarxMetr: sotishNarxMetr ?? this.sotishNarxMetr,
    );
  }
}

// ===== Jadval =====

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
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF5F7FA)),
              headingTextStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Color(0xFF374151),
              ),
              dataTextStyle: const TextStyle(fontSize: 13, color: Color(0xFF1F2937)),
              columnSpacing: 20,
              horizontalMargin: 16,
              dividerThickness: 1,
              dataRowMinHeight: 64,
              dataRowMaxHeight: 80,
              columns: [
                DataColumn(label: _hdr("S/N")),
                DataColumn(label: _hdr("Tovar")),
                DataColumn(label: _hdr("Sotish narxi")),
                DataColumn(label: _hdr("Miqdor")),
                DataColumn(label: _hdr("Kelgan narx")),
                DataColumn(label: _hdr("Jami narx")),
                DataColumn(label: _hdr("Sotildi", color: Colors.red.shade600)),
                DataColumn(label: _hdr("QR")),
                DataColumn(label: _hdr("")),
              ],
              rows: List.generate(rows.length, (index) {
                final r = rows[index];
                final isEven = index % 2 == 0;
                return DataRow(
                  color: WidgetStateProperty.all(
                    isEven ? Colors.white : const Color(0xFFFAFAFC),
                  ),
                  cells: [
                    // S/N
                    DataCell(
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B74E5).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          (index + 1).toString().padLeft(2, '0'),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Color(0xFF0B74E5),
                          ),
                        ),
                      ),
                    ),
                    // Tovar nomi + rasm
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ProductImage(path: r.imagePath),
                          const SizedBox(width: 10),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 160),
                            child: Text(
                              r.productName,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Sotish narxi (admin kiritgan)
                    DataCell(
                      _MultiLineCell(lines: [
                        if (r.sotishNarxMetr.isNotEmpty) _CellLine("Metr:", r.sotishNarxMetr, Colors.green.shade700),
                        if (r.donaPrice.isNotEmpty)       _CellLine("Dona:", r.donaPrice, Colors.blue.shade700),
                        if (r.packetPrice.isNotEmpty)     _CellLine("Pachka:", r.packetPrice, Colors.purple.shade700),
                        if (r.sotishNarxMetr.isEmpty && r.donaPrice.isEmpty && r.packetPrice.isEmpty)
                          _CellLine("", "—", Colors.grey),
                      ]),
                    ),
                    // Miqdor
                    DataCell(
                      _MultiLineCell(lines: [
                        if (r.metri.isNotEmpty)  _CellLine("Metr:", r.metri, Colors.teal.shade700),
                        if (r.miqdori.isNotEmpty) _CellLine("Dona:", r.miqdori, Colors.indigo.shade700),
                        if (r.pachka.isNotEmpty)  _CellLine("Pachka:", r.pachka, Colors.orange.shade700),
                        if (r.metri.isEmpty && r.miqdori.isEmpty && r.pachka.isEmpty)
                          _CellLine("", "—", Colors.grey),
                      ]),
                    ),
                    // Kelgan narx
                    DataCell(
                      _PriceChip(value: r.kelganNarx.isEmpty ? "—" : r.kelganNarx, color: const Color(0xFF374151)),
                    ),
                    // Jami narx
                    DataCell(
                      _PriceChip(value: r.jamiNarx.isEmpty ? "—" : r.jamiNarx, color: const Color(0xFF0B74E5)),
                    ),
                    // Sotildi
                    DataCell(
                      _MultiLineCell(lines: [
                        _CellLine("Metr:", r.sotilganMetr.toString(), Colors.red.shade600),
                        _CellLine("Dona:", r.sotilganMiqdor.toString(), Colors.red.shade600),
                        _CellLine("Pachka:", r.sotilganPochka.toString(), Colors.red.shade600),
                      ]),
                    ),
                    // QR
                    DataCell(
                      IconButton(
                        onPressed: () => onQrTap(r),
                        icon: Icon(Icons.qr_code_2_rounded, color: Colors.grey.shade600, size: 28),
                        tooltip: "QR ko'rish",
                      ),
                    ),
                    // Amallar
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ActionBtn(
                            icon: Icons.edit_rounded,
                            color: const Color(0xFF0B74E5),
                            tooltip: "Tahrirlash",
                            onTap: () => onEdit(index, r),
                          ),
                          const SizedBox(width: 4),
                          _ActionBtn(
                            icon: Icons.delete_rounded,
                            color: Colors.red,
                            tooltip: "O'chirish",
                            onTap: () => onDelete(index, r),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _hdr(String text, {Color? color}) => Text(
    text,
    style: TextStyle(color: color),
  );
}

// ===== Yordamchi widgetlar =====

class _CellLine {
  final String label;
  final String value;
  final Color color;
  _CellLine(this.label, this.value, this.color);
}

class _MultiLineCell extends StatelessWidget {
  final List<_CellLine> lines;
  const _MultiLineCell({required this.lines});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((l) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (l.label.isNotEmpty) ...[
              Text(
                l.label,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              l.value,
              style: TextStyle(fontSize: 13, color: l.color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      )).toList(),
    );
  }
}

class _PriceChip extends StatelessWidget {
  final String value;
  final Color color;
  const _PriceChip({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        value,
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.color, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: color, size: 18),
        ),
      ),
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
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.image_outlined, size: 20, color: Colors.grey.shade400),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.broken_image_outlined, size: 20, color: Colors.grey.shade400),
        ),
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
      kelganNarx: (kelganNarx != null && kelganNarx!.isNotEmpty)
          ? kelganNarx!
          : narxMetr ?? '',          // ← kelganNarx bo'sh bo'lsa narxMetr ni ko'rsat
      jamiNarx: jamiNarx ?? '',
      imagePath: rasm ?? '',
      qrCodePath: qrKod ?? '',
      createdAt: yaratilgan,
      sotilganMiqdor: sotilganMiqdor ?? 0,
      sotilganMetr: sotilganMetr ?? 0,
      sotilganPochka: sotilganPochka ?? 0,
      sotishNarxMetr: sotishNarxMetr ?? '',
    );
  }
}