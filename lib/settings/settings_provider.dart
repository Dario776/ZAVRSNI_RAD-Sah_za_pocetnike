import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zavrsni/styles.dart';

class SettingsProvider with ChangeNotifier {
  bool _isSound = true;
  bool _isDarkMode = false;
  bool _isOpenDyslexic = false;
  bool _isBiggerFontSize = false;

  SettingsProvider() {
    _load();
  }

  bool get isOpenDyslexic => _isOpenDyslexic;
  bool get isDarkMode => _isDarkMode;
  bool get isSound => _isSound;
  bool get isBiggerFontSize => _isBiggerFontSize;

  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  String get currentFontName =>
      _isOpenDyslexic ? Styles.fontNameSecondary : Styles.fontNamePrimary;

  void toggleTheme(bool isOn) {
    _isDarkMode = isOn;
    _save('DarkMode', isOn);
    notifyListeners();
  }

  void toggleFontName(bool isOn) {
    _isOpenDyslexic = isOn;
    _save('OpenDyslexic', isOn);
    notifyListeners();
  }

  void toggleFontSize(bool isOn) {
    _isBiggerFontSize = isOn;
    _save('BiggerFontSize', isOn);
    notifyListeners();
  }

  void toggleSound(bool isOn) {
    _isSound = isOn;
    _save('Sound', isOn);
    notifyListeners();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('DarkMode') ?? false;
    _isOpenDyslexic = prefs.getBool('OpenDyslexic') ?? false;
    _isBiggerFontSize = prefs.getBool('BiggerFontSize') ?? false;
    _isSound = prefs.getBool('Sound') ?? true;
    notifyListeners();
  }

  Future<void> _save(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> ResetAllPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isSound = true;
    _isDarkMode = false;
    _isOpenDyslexic = false;
    _isBiggerFontSize = false;
    notifyListeners();
  }
}
