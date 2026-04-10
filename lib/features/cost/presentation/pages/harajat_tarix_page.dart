import 'package:flutter/material.dart';
import 'package:admin_panel/core/networks/api_urls.dart';
import 'package:admin_panel/core/networks/dio_client.dart';
import 'package:admin_panel/core/di/services_locator.dart';

class HarajatTarixPage extends StatefulWidget {
  const HarajatTarixPage({super.key});

  @override
  State<HarajatTarixPage> createState() => _HarajatTarixPageState();
}

class _HarajatTarixPageState extends State<HarajatTarixPage> {
  List<Map<String, dynamic>> _oylar = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final dio = sl<DioClient>();
      final resp = await dio.get(ApiUrls.getHarajatTarix);
      final oylar = (resp.data['data']['oylar'] as List<dynamic>? ?? [])
          .map((e) => e as Map<String, dynamic>)
          .toList();
      if (mounted) setState(() { _oylar = oylar; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = "Xatolik yuz berdi"; _isLoading = false; });
    }
  }

  String _oyLabel(int yil, int oy) {
    const oylar = ['', 'Yanvar', 'Fevral', 'Mart', 'Aprel', 'May', 'Iyun',
      'Iyul', 'Avgust', 'Sentabr', 'Oktabr', 'Noyabr', 'Dekabr'];
    return '${oylar[oy]} $yil';
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
            const SizedBox(height: 6),
            // Orqaga
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF1877F2)),
                      SizedBox(width: 6),
                      Text("Orqaga", style: TextStyle(color: Color(0xFF1877F2), fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
                  : _oylar.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history, size: 64, color: Colors.grey),
                    SizedBox(height: 12),
                    Text("Hali tarix yo'q", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              )
                  : RefreshIndicator(
                onRefresh: _load,
                child: ListView.separated(
                  itemCount: _oylar.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final oy = _oylar[index];
                    final yil = oy['yil'] as int;
                    final oyNum = oy['oy'] as int;
                    final jamiSumma = (oy['jami_summa'] as num? ?? 0).toDouble();
                    final ishchilar = (oy['ishchilar'] as List<dynamic>? ?? []);

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                            color: Colors.black.withOpacity(0.06),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4D8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.calendar_month_rounded,
                                color: Color(0xFFD69B1A)),
                          ),
                          title: Text(
                            _oyLabel(yil, oyNum),
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          subtitle: Text(
                            "Jami: \$${jamiSumma.toStringAsFixed(2)}",
                            style: const TextStyle(color: Color(0xFFD69B1A), fontWeight: FontWeight.w600),
                          ),
                          children: ishchilar.map((i) {
                            final iMap = i as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      iMap['fish'] ?? 'Noma\'lum',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Text(
                                    "\$${(iMap['jami_summa'] as num? ?? 0).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1877F2),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
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