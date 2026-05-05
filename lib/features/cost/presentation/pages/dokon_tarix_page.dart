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
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.05))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.store_outlined, color: Colors.orange.shade700),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${oy['oy_nomi']} ${oy['yil']}",
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                              ],
                            ),
                          ),
                          Text(
                            "${(oy['jami_summa'] as num).toStringAsFixed(2)}\$",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Colors.orange.shade700),
                          ),
                        ],
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