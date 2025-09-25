import 'package:flutter/material.dart';
import 'login_page.dart';
import 'dashboard.dart';
import 'request_form.dart'; // Make sure this file exists in lib/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Payment Request App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        // provide a secondary/accent color used by LoginPage
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.orangeAccent),
      ),
      // start at login and use named routes for navigation
      initialRoute: '/',
      routes: {
        '/': (ctx) => const LoginPage(),
        '/dashboard': (ctx) => const DashboardPage(),
        '/new_request': (ctx) => const PaymentRequestForm(),
      },
    );
  }
}
