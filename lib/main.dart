import 'package:flutter/material.dart';

import 'screens/waitlist_screen.dart';

void main() {
  runApp(const RestaurantWaitlistApp());
}

class RestaurantWaitlistApp extends StatelessWidget {
  const RestaurantWaitlistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
    scaffoldBackgroundColor: const Color(0xFFF7F4F1),
    appBarTheme: const AppBarTheme(centerTitle: false, scrolledUnderElevation: 0),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  ),
  home: const WaitlistScreen(),
);
  }
}
