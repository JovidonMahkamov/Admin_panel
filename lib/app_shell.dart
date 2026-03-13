import 'package:admin_panel/features/cost/presentation/pages/cost_page.dart';
import 'package:admin_panel/features/history/presentation/pages/history_page.dart';
import 'package:admin_panel/features/monthly_selling/presentation/pages/monthly_selling_page.dart';
import 'package:admin_panel/features/profile/presentation/pages/profile_page.dart';
import 'package:admin_panel/sidebar_widget.dart';
import 'package:flutter/material.dart';

import 'features/customer/presentation/pages/customer_page.dart';
import 'features/dashboard/presentation/pages/deshboard_page.dart';
import 'features/products/presentation/pages/product_page.dart';
import 'features/workers/presentation/pages/workers_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const DashboardPage(),
      const WorkersPage(),
      const ProductPage(),
      const CustomerPage(),
      const MonthlySellingPage(),
      const HistoryPage(),
      const ProfilePage(),
      const CostPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final isWide = c.maxWidth >= 900;

        if (!isWide) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('StockFlow Admin'),
            ),
            drawer: Drawer(
              child: SafeArea(
                child: Sidebar(
                  selectedIndex: _selectedIndex,
                  onSelect: (i) {
                    setState(() => _selectedIndex = i);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            body: _pages[_selectedIndex],
          );
        }

        return Scaffold(
          body: Row(
            children: [
              Sidebar(
                selectedIndex: _selectedIndex,
                onSelect: (i) => setState(() => _selectedIndex = i),
              ),
              Expanded(child: _pages[_selectedIndex]),
            ],
          ),
        );
      },
    );
  }
}