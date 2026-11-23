import 'package:material_ui/material_ui.dart';

import '../controllers/receitas_controller.dart';
import '../models/receita.dart';
import '../tema.dart';
import '../widgets/botao_favorito.dart';
import '../widgets/receita_imagem.dart';

class DetalheReceita extends StatelessWidget {
  final Receita receita;
  final ReceitasController controller;
  const DetalheReceita({
    super.key,
    required this.receita,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => Scaffold(
      appBar: AppBar(
        title: const Text('Receita'),
        actions: [
          BotaoFavorito(receita: receita, controller: controller),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: ReceitaImagem(
                      url: receita.imagem,
                      nome: receita.nome,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  receita.nome,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  [
                    if (receita.culinaria != null) receita.culinaria!,
                    if (receita.dificuldadeTexto != null)
                      receita.dificuldadeTexto!,
                    if (receita.avaliacaoTexto != null)
                      'Avaliação ${receita.avaliacaoTexto} / 5',
                  ].join(' · '),
                  style: const TextStyle(color: CoresApp.secundario),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Dado(valor: receita.tempoTexto, legenda: 'tempo total'),
                    if (receita.porcoes != null)
                      _Dado(valor: '${receita.porcoes}', legenda: 'porções'),
                    _Dado(
                      valor: controller.ehFavorita(receita.id)
                          ? 'Salva'
                          : 'Não salva',
                      legenda: 'nos favoritos',
                    ),
                  ],
                ),
                if (receita.tempoTotal == null &&
                    (receita.tempoPreparo != null ||
                        receita.tempoCozimento != null)) ...[
                  const SizedBox(height: 12),
                  Text(
                    [
                      if (receita.tempoPreparo != null)
                        'Preparo: ${receita.tempoPreparo} min',
                      if (receita.tempoCozimento != null)
                        'Cozimento: ${receita.tempoCozimento} min',
                      'Tempo total não informado.',
                    ].join(' · '),
                  ),
                ],
                if (receita.tiposRefeicao.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final tipo in receita.tiposRefeicao)
                        Chip(label: Text(tipo)),
                    ],
                  ),
                ],
                const SizedBox(height: 28),
                const _Titulo('Ingredientes'),
                const SizedBox(height: 12),
                if (receita.ingredientes.isEmpty)
                  const Text('Ingredientes não informados.'),
                for (final ingrediente in receita.ingredientes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '•',
                          style: TextStyle(color: CoresApp.verde),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            ingrediente,
                            style: const TextStyle(height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                const _Titulo('Modo de preparo'),
                const SizedBox(height: 16),
                if (receita.instrucoes.isEmpty)
                  const Text('Modo de preparo não informado.'),
                for (var i = 0; i < receita.instrucoes.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: CoresApp.verde,
                          foregroundColor: Colors.white,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            receita.instrucoes[i],
                            style: const TextStyle(height: 1.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Voltar às receitas'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _Titulo extends StatelessWidget {
  final String texto;
  const _Titulo(this.texto);
  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      texto,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
    ),
  );
}

class _Dado extends StatelessWidget {
  final String valor;
  final String legenda;
  const _Dado({required this.valor, required this.legenda});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xFFEBF0E8),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          valor,
          style: const TextStyle(
            color: CoresApp.verde,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          legenda,
          style: const TextStyle(color: CoresApp.secundario, fontSize: 12),
        ),
      ],
    ),
  );
}
