import 'dart:async';
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'package:qtechy/core/injections/dependency_injection.dart' as di;

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(const App());
}
