import 'package:flutter/material.dart';

class AppStateViewModel extends ChangeNotifier {
  // Default values
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en'); // Default Language English

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  // Theme badalne ka function
  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Yeh line screen ko automatic update kar degi
  }

  // Language badalne ka function ('en' for English, 'hi' for Hindi)
  void changeLanguage(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners(); // Yeh line poore app ki language badal degi
  }
}