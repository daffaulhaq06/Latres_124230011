import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 100, 100, 101)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

/*SharedPreferences adalah mekanisme penyimpanan data sederhana di dalam aplikasi Android/Flutter.

Secara konsep, bayangkan SharedPreferences seperti catatan kecil atau sticky note yang disimpan di dalam memori HP. Data ini akan tetap ada meskipun aplikasi ditutup (terminated) dan dibuka kembali.

Dalam tugas Anda, SharedPreferences diminta digunakan pada Halaman Register dan Login Sederhana.

Berikut adalah penjelasan detail letaknya di dalam kode yang saya berikan sebelumnya:

1. Apa Fungsinya di Aplikasi Ini?
Sesuai soal, fungsinya adalah menyimpan Username yang diinput saat login, supaya bisa ditampilkan kembali di halaman utama ("Hai, Username!").*/