import 'package:admin_panel/features/profile/presentation/widgets/lock_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_shell.dart';
import 'features/profile/presentation/widgets/lock_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final lock = LockController();

  @override
  void initState() {
    super.initState();
    lock.init();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AnimatedBuilder(
            animation: lock,
            builder: (context, _) {
              if (!lock.initialized) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return Listener(
                onPointerDown: (_) => lock.recordActivity(),
                onPointerHover: (_) => lock.recordActivity(),
                // MUHIM: lock bo'lsa AppShell umuman chizilmaydi (orqa ko'rinmaydi)
                child: lock.isLocked ? LockScreen(lock: lock) : const AppShell(),
              );
            },
          ),
        );
      },
    );
  }
}
