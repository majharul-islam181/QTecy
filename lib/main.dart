import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qtechy/core/language/app_language.dart';
import 'app/app.dart';
import 'package:qtechy/core/injections/dependency_injection.dart' as di;

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
    runApp(
    EasyLocalization(
      supportedLocales: AppLanguage.all,
      path: AppLanguage.path,
      fallbackLocale: AppLanguage.english,
      startLocale: AppLanguage.english,
      child: const App(),
    ),
  );
}
