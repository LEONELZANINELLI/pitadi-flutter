
import 'package:flutter/material.dart';
import 'tema.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 46,
                backgroundColor: CoresApp.destaque,
                child: Icon(
                  Icons.person_outline,
                  size: 50,
                  color: CoresApp.primario,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Leonel Zaninelli',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: CoresApp.texto,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Estudante de Engenharia de Software',
                textAlign: TextAlign.center,
                style: TextStyle(color: CoresApp.secundario),
              ),
              const SizedBox(height: 8),
              const Text(
                'Rolândia - Paraná',
                style: TextStyle(color: CoresApp.verde),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
