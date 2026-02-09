import 'package:flutter/material.dart';
import 'di/injection_container.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
}
