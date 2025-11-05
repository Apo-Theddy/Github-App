import 'package:flutter/material.dart';
import 'package:github_app/app.dart';
import 'package:github_app/features/repo/di/container.dart';
import 'package:github_app/shared/utils/language_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await containerDeps();
  await loadLanguageColors();

  runApp(App());
}
