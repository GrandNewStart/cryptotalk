import 'package:flutter/material.dart';
import 'package:cryptotalk/screens/home_screen.dart';
import 'package:toastification/toastification.dart';

void main() {
  runApp(const CryptoTalkApp());
}

class CryptoTalkApp extends StatelessWidget {
  const CryptoTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Crypto Talk',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
