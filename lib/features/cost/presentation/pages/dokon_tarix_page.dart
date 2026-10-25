import 'package:flutter/material.dart';
import 'package:admin_panel/core/networks/api_urls.dart';
import 'package:admin_panel/core/networks/dio_client.dart';
import 'package:admin_panel/core/di/services_locator.dart';

class DokonTarixPage extends StatefulWidget {
  const DokonTarixPage({super.key});

  @override
  State<DokonTarixPage> createState() => _DokonTarixPageState();
}

class _DokonTarixPageState extends State<DokonTarixPage> {
  List<Map<String, dynamic>> _oylar = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final dio = sl<DioClient>();
      final resp = await dio.get(ApiUrls.getDokonTarix);
      final oylar = (resp.data['data']['oylar'] as List<dynamic>? ?? [])
          .map((e) => e as Map<String, dynamic>).toList();
      if (mounted) setState(() { _oylar = oylar; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '-';
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day.toString().padLeft(2,'0')}.${dt.month.toString().padLeft(2,'0')}.${dt.year}';
    } catch (_) { return isoDate; }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1877F2)),
                ),
                const Text("Do'kon chiqim tarixi",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _oylar.isEmpty
                  ? const Center(child: Text("Tarix mavjud emas", style: TextStyle(color: Colors.grey)))
                  : RefreshIndicator(
                onRefresh: _load,
                child: ListView.separated(
                  itemCount: _oylar.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final oy = _oylar[index];
                    final chiqimlar = (oy['chiqimlar'] as List<dynamic>? ?? [])
                        .map((e) => e as Map<String, dynamic>).toList();
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.05))],
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          leading: Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.store_outlined, color: Colors.orange.shade700),
                          ),
                          title: Text(
                            "${oy['oy_nomi']} ${oy['yil']}",
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          subtitle: Text(
                            "Jami: ${(oy['jami_summa'] as num).toStringAsFixed(2)}\$",
                            style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.w600),
                          ),
                          children: chiqimlar.isEmpty
                              ? [const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text("Chiqimlar mavjud emas", style: TextStyle(color: Colors.grey)),
                          )]
                              : [
                            // Jadval sarlavhasi
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 3, child: Text("Sana", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade600))),
                                  Expanded(flex: 4, child: Text("Izoh/Tavsif", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade600))),
                                  Expanded(flex: 2, child: Text("To'lov", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade600))),
                                  Expanded(flex: 2, child: Text("Summa", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade600), textAlign: TextAlign.right)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            ...chiqimlar.map((ch) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(flex: 3, child: Text(
                                    _formatDate(ch['sana']),
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  )),
                                  Expanded(flex: 4, child: Text(
                                    ch['izoh'] ?? ch['tavsif'] ?? '-',
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                  Expanded(flex: 2, child: Text(
                                    ch['tolov_turi'] ?? '-',
                                    style: const TextStyle(fontSize: 12),
                                  )),
                                  Expanded(flex: 2, child: Text(
                                    "${(ch['summa'] as num).toStringAsFixed(2)}\$",
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.red),
                                    textAlign: TextAlign.right,
                                  )),
                                ],
                              ),
                            )),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text("Jami: ", style: TextStyle(fontWeight: FontWeight.w700)),
                                Text(
                                  "${(oy['jami_summa'] as num).toStringAsFixed(2)}\$",
                                  style: TextStyle(fontWeight: FontWeight.w800, color: Colors.orange.shade700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}