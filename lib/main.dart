import 'package:flutter/material.dart';
import 'package:github_app/app.dart';
import 'package:github_app/features/repo/di/container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  containerDeps();

  runApp(App());
}
