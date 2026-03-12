import '../../presentation/pages/product_page.dart';

class ProductEntity {
  final int id;
  final String nomi;
  final String? narxDona;
  final String? narxMetr;
  final String? narxPochka;
  final String? pochka;
  final String? metr;
  final String? miqdor;
  final String? kelganNarx;
  final String? jamiNarx;
  final String? rasm;
  final String? qrKod;
  final String yaratilgan;

  const ProductEntity({
    required this.id,
    required this.nomi,
    required this.narxDona,
    required this.narxMetr,
    required this.narxPochka,
    required this.pochka,
    required this.metr,
    required this.miqdor,
    required this.kelganNarx,
    required this.jamiNarx,
    required this.rasm,
    required this.qrKod,
    required this.yaratilgan,
  });

}
extension ProductEntityMapper on ProductEntity {
  ProductRow toRow() {
    return ProductRow(
      productName: nomi ?? '',
      metrPrice: '${narxMetr ?? 0}\$',
      donaPrice: '${narxDona ?? 0}\$',
      packetPrice: '${narxPochka ?? 0}\$',
      pachka: '${pochka ?? 0}',
      metri: '${metr ?? 0}',
      miqdori: '${miqdor ?? 0}',
      imagePath: rasm ?? '',
      // sotildi: null,
    );
  }
}