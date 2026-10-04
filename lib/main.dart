import 'package:flutter/material.dart';

import 'view/home_page.dart';

class AppCores {
  AppCores._();

  static const fundo = Color(0xFF13151C);
  static const superficie = Color(0xFF1C1F2A);
  static const superficieClara = Color(0xFF262A38);
  static const primaria = Color(0xFF8B5CF6);
  static const primariaClara = Color(0xFFB39DFF);
  static const destaque = Color(0xFFF2A541);
  static const textoPrimario = Colors.white;
  static const textoSecundario = Color(0xFFA0A6B8);
  static const erro = Color(0xFFFF6B6B);
}

void main() {
  runApp(MaterialApp(
    title: 'Catálogo Musical',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppCores.fundo,
      colorScheme: const ColorScheme.dark(
        primary: AppCores.primaria,
        secondary: AppCores.destaque,
        surface: AppCores.superficie,
        error: AppCores.erro,
      ),
      cardColor: AppCores.superficie,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppCores.fundo,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AppCores.textoPrimario,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppCores.textoPrimario),
        bodyMedium: TextStyle(color: AppCores.textoPrimario),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppCores.superficie,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppCores.primaria, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppCores.erro, width: 1.2),
        ),
        labelStyle: const TextStyle(color: AppCores.textoSecundario),
        hintStyle: const TextStyle(color: Color(0xFF5B6075)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppCores.primaria,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppCores.superficie,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    home: const HomePage(),
  ));
}
