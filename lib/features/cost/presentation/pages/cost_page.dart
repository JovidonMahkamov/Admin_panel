import 'package:admin_panel/features/cost/presentation/pages/dokon_chiqim_page.dart';
import 'package:admin_panel/features/cost/presentation/pages/harajat_chiqim_page.dart';
import 'package:admin_panel/features/cost/presentation/pages/kassa_chiqim_page.dart';
import 'package:flutter/material.dart';

class CostPage extends StatefulWidget {
  const CostPage({super.key});

  @override
  State<CostPage> createState() => _CostPageState();
}

class _CostPageState extends State<CostPage> {
  void _onHarajatChiqimTap() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HarajatChiqimPage()));
  }

  void _onKassaChiqimTap() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const KassaChiqimPage()));
  }

  void _onDokonChiqimTap() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const DokonChiqimPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F6FB),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FC),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Harajat turlari",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2B2B2B),
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: [
                    _ExpenseTypeCard(
                      title: "Ishchi oylik chiqim",
                      description: "Ishchilarga beriladigan oylik va boshqa to'lovlarni kiritish.",
                      icon: Icons.person_outline_rounded,
                      iconBg: const Color(0xFFFFF4D8),
                      iconColor: const Color(0xFFD69B1A),
                      accentColor: const Color(0xFFE84D4F),
                      onTap: _onHarajatChiqimTap,
                    ),
                    _ExpenseTypeCard(
                      title: "Harajat chiqim",
                      description: "Tovar sotib olish va boshqa kassa chiqimlarini qayd etish.",
                      icon: Icons.shopping_cart_outlined,
                      iconBg: const Color(0xFFEAF3FF),
                      iconColor: const Color(0xFF2F80ED),
                      accentColor: const Color(0xFFE84D4F),
                      onTap: _onKassaChiqimTap,
                    ),
                    _ExpenseTypeCard(
                      title: "Do'kon chiqim",
                      description:
                      "Kommunalka, gaz, svет va do'kon egasi olib ketgan pullarni qayd etish.",
                      icon: Icons.store_outlined,
                      iconBg: const Color(0xFFEEF8F0),
                      iconColor: const Color(0xFF27AE60),
                      accentColor: const Color(0xFFE84D4F),
                      onTap: _onDokonChiqimTap,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpenseTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color accentColor;
  final VoidCallback onTap;

  const _ExpenseTypeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        hoverColor: Colors.black.withOpacity(0.02),
        splashColor: Colors.black.withOpacity(0.04),
        child: Container(
          width: 370,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE9EDF3)),
            boxShadow: [
              BoxShadow(
                blurRadius: 14,
                offset: const Offset(0, 4),
                color: Colors.black.withOpacity(0.04),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2B2B2B))),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                    child: Icon(icon, size: 16, color: iconColor),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.south_west_rounded, size: 14, color: accentColor),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(description,
                        style: TextStyle(
                            fontSize: 11.5, height: 1.35, color: Colors.grey.shade600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}