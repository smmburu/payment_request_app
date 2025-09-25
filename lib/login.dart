import 'package:flutter/material.dart';
import 'login_page.dart'; // new import

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: kNavy,
      scaffoldBackgroundColor: kSoftGrey,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kNavy,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        filled: true,
        fillColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kSky),
    ),
    // start app at login and provide a named route for the main form
    initialRoute: '/',
    routes: {
      '/': (context) => LoginPage(),
      '/home': (context) => PaymentRequestForm(),
    },
    // ...existing code...
  ));
}

// ...existing code...