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
      title: 'Restaurant Waitlist',
      debugShowCheckedModeBanner: false,
      home: const WaitlistScreen(),
    );
  }
}
