import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          _LogoBlock(),
          SizedBox(height: 70.h,),
          _MenuItem(
            title: "Asosiy",
            icon: Icons.grid_view_rounded,
            selected: selectedIndex == 0,
            onTap: () => onSelect(0),
          ),
          _MenuItem(
            title: "Ishchilar",
            icon: Icons.people_alt_rounded,
            selected: selectedIndex == 1,
            onTap: () => onSelect(1),
          ),
          _MenuItem(
            title: "Tovarlar",
            icon: Icons.shopping_bag,
            selected: selectedIndex == 2,
            onTap: () => onSelect(2),
          ),
          _MenuItem(
            title: "Mijozlar",
            icon: Icons.people_alt_rounded,
            selected: selectedIndex == 3,
            onTap: () => onSelect(3),
          ),
          _MenuItem(
            title: "Oylik Savdo",
            icon: Icons.sell,
            selected: selectedIndex == 4,
            onTap: () => onSelect(4),
          ),
          _MenuItem(
            title: "Tarix",
            icon: Icons.history,
            selected: selectedIndex == 5,
            onTap: () => onSelect(5),
          ),
          _MenuItem(
            title: "Profil",
            icon: Icons.person,
            selected: selectedIndex == 6,
            onTap: () => onSelect(6),
          ),
          _MenuItem(
            title: "Xarajat",
            icon: Icons.attach_money_sharp,
            selected: selectedIndex == 7,
            onTap: () => onSelect(7),
          ),
        ],
      ),
    );
  }
}

class _LogoBlock extends StatelessWidget {
  const _LogoBlock();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: SvgPicture.asset("assets/logo/logo.svg",height: 80,width: 80,),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _MenuItem({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFFEAF1FF) : Colors.transparent;
    final color = selected ? const Color(0xFF1E6BFF) : Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
