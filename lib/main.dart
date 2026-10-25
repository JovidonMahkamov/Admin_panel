import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc_provider.dart';
import 'core/di/services_locator.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  await setup();

  runApp(
    const MyBlocProvider(
      child: MyApp(),
    ),
  );
}