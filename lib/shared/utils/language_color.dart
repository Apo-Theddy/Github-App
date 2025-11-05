import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

Map<String, dynamic> _languageData = {};

Future<void> loadLanguageColors() async {
  final yamlStr = await rootBundle.loadString('assets/ymls/languages.yml');
  final yamlMap = loadYaml(yamlStr);
  _languageData = json.decode(json.encode(yamlMap));
}

Color getLanguageColor(String? language) {
  if (language == null || !_languageData.containsKey(language)) {
    return Colors.grey;
  }

  final hex = _languageData[language]['color'];
  if (hex == null || hex.toString().isEmpty) return Colors.grey;

  try {
    return Color(int.parse('0xFF${hex.substring(1)}'));
  } catch (_) {
    return Colors.grey;
  }
}
