import 'package:material_ui/material_ui.dart';
import 'receitas.dart';
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
