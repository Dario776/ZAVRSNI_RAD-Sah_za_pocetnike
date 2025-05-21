import 'package:flutter/material.dart';
import 'package:zavrsni/home/home_page.dart';
import 'package:zavrsni/settings_provider.dart';
import 'package:provider/provider.dart';
import 'styles.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Šah za početnike',
      theme: Styles.buildThemeData(
        isDarkMode: settingsProvider.isDarkMode,
        fontFamily: settingsProvider.currentFontName,
        context: context,
      ),
      darkTheme: Styles.buildThemeData(
        isDarkMode: settingsProvider.isDarkMode,
        fontFamily: settingsProvider.currentFontName,
        context: context,
      ),
      themeMode: settingsProvider.currentTheme,
      home: HomePage(),
    );
  }
}
