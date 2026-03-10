import 'package:flutter/material.dart';
import 'bloc_provider.dart';
import 'core/di/services_locator.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();

  runApp(
    const MyBlocProvider(
      child: MyApp(),
    ),
  );
}