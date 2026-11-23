import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Receitas.dart';
import 'services/receitas_service.dart';
import 'tema.dart';

class Principal extends StatelessWidget {
  final ReceitasService? service;
  const Principal({super.key, this.service});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Pitadi',
    debugShowCheckedModeBanner: false,
    locale: const Locale('pt', 'BR'),
    supportedLocales: const [Locale('pt', 'BR')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: criarTema(),
    home: Receitas(service: service),
  );
}
