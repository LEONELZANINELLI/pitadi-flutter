
import 'package:flutter/material.dart';
import 'Perfil.dart';
import 'tema.dart';

class Receitas extends StatefulWidget {
  const Receitas({super.key});

  @override
  State<Receitas> createState() => _ReceitasState();
}

class _ReceitasState extends State<Receitas> {
  String pesquisa = '';

  final receitas = const [
    {'nome': 'Pizza Margherita', 'emoji': '🍕', 'tempo': '35 min', 'nivel': 'Fácil'},
    {'nome': 'Panqueca de Banana', 'emoji': '🥞', 'tempo': '15 min', 'nivel': 'Fácil'},
    {'nome': 'Bolo de Cenoura', 'emoji': '🍰', 'tempo': '50 min', 'nivel': 'Médio'},
  ];

  @override
  Widget build(BuildContext context) {
    final resultados = receitas.where((receita) {
      return receita['nome']!
          .toLowerCase()
          .contains(pesquisa.trim().toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          'Pitadi',
          style: TextStyle(
            color: CoresApp.primario,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Meu perfil',
            icon: const Icon(Icons.account_circle_outlined, size: 29),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Perfil()),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            const Text(
              'O que vamos cozinhar hoje?',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: CoresApp.texto,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Um toque de sabor em cada receita.',
              style: TextStyle(fontSize: 14, color: CoresApp.secundario),
            ),
            const SizedBox(height: 26),

            // Campo de pesquisa
            TextField(
              onChanged: (valor) => setState(() => pesquisa = valor),
              decoration: InputDecoration(
                hintText: 'Buscar receitas...',
                hintStyle: const TextStyle(color: CoresApp.secundario),
                prefixIcon: const Icon(Icons.search, color: CoresApp.verde),
                filled: true,
                fillColor: CoresApp.superficie,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: CoresApp.borda),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: CoresApp.primario),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Título da lista
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Receitas disponíveis',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: CoresApp.texto,
                  ),
                ),
                Text(
                  '${resultados.length} receitas',
                  style: const TextStyle(
                    fontSize: 12,
                    color: CoresApp.secundario,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (resultados.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Nenhuma receita encontrada.'),
              ),

            // Cards das receitas
            ...resultados.map(
                  (receita) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CoresApp.superficie,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: CoresApp.borda),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: CoresApp.destaque,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Text(
                        receita['emoji']!,
                        style: const TextStyle(fontSize: 37),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            receita['nome']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: CoresApp.texto,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule_outlined,
                                size: 16,
                                color: CoresApp.verde,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${receita['tempo']}  •  ${receita['nivel']}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: CoresApp.secundario,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Barra inferior apenas visual
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (_) {},
        height: 74,
        backgroundColor: CoresApp.superficie,
        indicatorColor: CoresApp.destaque,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search, color: CoresApp.primario),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
