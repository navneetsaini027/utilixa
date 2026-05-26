import 'package:flutter/material.dart';

class AppThemes {
  // Modern Light Theme (Teal Green & White trend)
  static final lightTheme = ThemeData(
    primarySwatch: Colors.teal, // Emerald ki jagah Teal kar diya
    scaffoldBackgroundColor: const Color(0xFFF8F9FA), 
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF212529)),
      titleTextStyle: TextStyle(color: Color(0xFF212529), fontSize: 20, fontWeight: FontWeight.bold),
    ),
    cardTheme: CardThemeData( // CardTheme ko CardThemeData kiya
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // Modern Dark Theme (Amoled Slate Black trend)
  static final darkTheme = ThemeData(
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: const Color(0xFF121212), 
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    cardTheme: CardThemeData( // CardTheme ko CardThemeData kiya
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}