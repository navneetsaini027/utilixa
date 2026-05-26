import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/app_themes.dart';
import 'viewmodels/app_state_viewmodel.dart';
import 'views/splash_view.dart'; // Splash import kiya

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppStateViewModel(),
      child: const UtilixaApp(),
    ),
  );
}

class UtilixaApp extends StatelessWidget {
  const UtilixaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateViewModel>(context);

    return MaterialApp(
      title: 'Utilixa',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: appState.themeMode,
      locale: appState.locale,
      home: const SplashView(), // Entry shifted to Splash sequence
    );
  }
}