import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zavrsni/settings/settings_provider.dart';
import 'app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: const App(),
    ),
  );
}
