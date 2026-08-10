import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/di/injections.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjections();
  runApp(const App());
}
