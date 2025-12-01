import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Cek apakah user sudah pernah login (ada username tersimpan?)
  String? username = prefs.getString('username');
  
  runApp(MyApp(isLogin: username != null));
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  const MyApp({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hilangkan label debug
      home: isLogin ? const HomePage() : const LoginPage(),
    );
  }
}