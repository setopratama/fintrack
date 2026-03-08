import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintrack/utils/app_theme.dart';
import 'package:fintrack/screens/dashboard_screen.dart';
import 'package:fintrack/providers/transaksi_provider.dart';
import 'package:fintrack/providers/theme_provider.dart';
import 'package:fintrack/providers/user_provider.dart';
import 'package:fintrack/providers/kategori_provider.dart';
import 'package:fintrack/screens/onboarding_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TransaksiProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => KategoriProvider()),
      ],
      child: const FinTrackApp(),
    ),
  );
}

class FinTrackApp extends StatelessWidget {
  const FinTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, UserProvider>(
      builder: (context, themeProvider, userProvider, child) {
        return MaterialApp(
          title: 'FinTrack',
          debugShowCheckedModeBanner: false,
          
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          
          home: _getHome(userProvider),
        );
      },
    );
  }

  Widget _getHome(UserProvider userProvider) {
    if (!userProvider.isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    if (userProvider.isFirstTime) {
      return const OnboardingScreen();
    }
    
    return const DashboardScreen();
  }
}

