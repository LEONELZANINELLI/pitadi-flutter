import 'package:material_ui/material_ui.dart';

import 'tema.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sobre o Pitadi')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: const Column(
            children: [
              SizedBox(height: 24),
              CircleAvatar(
                radius: 42,
                backgroundColor: CoresApp.destaque,
                child: Icon(
                  Icons.restaurant_menu,
                  size: 40,
                  color: CoresApp.primario,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Pitadi',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 8),
              Text(
                'Um toque de sabor em cada receita.',
                textAlign: TextAlign.center,
                style: TextStyle(color: CoresApp.secundario),
              ),
              SizedBox(height: 32),
              Text(
                'Desenvolvido por Leonel Zaninelli de Souza',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 8),
              Text(
                'Atividade individual de Introdução ao Desenvolvimento com Flutter.',
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.6),
              ),
              SizedBox(height: 24),
              Text(
                'Receitas fornecidas pela DummyJSON.\nOs favoritos são salvos somente durante esta sessão.',
                textAlign: TextAlign.center,
                style: TextStyle(color: CoresApp.secundario, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
