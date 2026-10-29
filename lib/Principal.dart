
import 'package:flutter/material.dart';
import 'Receitas.dart';
import 'tema.dart';

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pitadi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: CoresApp.fundo,
        colorScheme: ColorScheme.fromSeed(seedColor: CoresApp.primario),
        appBarTheme: const AppBarTheme(
          backgroundColor: CoresApp.fundo,
          foregroundColor: CoresApp.texto,
          elevation: 0,
        ),
      ),
      home: const Receitas(),
    );
  }
}
