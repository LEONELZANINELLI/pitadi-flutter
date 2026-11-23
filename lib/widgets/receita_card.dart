import 'package:material_ui/material_ui.dart';

import '../controllers/receitas_controller.dart';
import '../models/receita.dart';
import '../tema.dart';
import 'botao_favorito.dart';
import 'receita_imagem.dart';

class ReceitaCard extends StatelessWidget {
  final Receita receita;
  final ReceitasController controller;
  final VoidCallback onAbrir;
  const ReceitaCard({
    super.key,
    required this.receita,
    required this.controller,
    required this.onAbrir,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Material(
      color: CoresApp.superficie,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: CoresApp.borda),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onAbrir,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 76,
                        height: 88,
                        child: ReceitaImagem(
                          url: receita.imagem,
                          nome: receita.nome,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            receita.nome,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            [
                              receita.tempoTexto,
                              if (receita.dificuldadeTexto != null)
                                receita.dificuldadeTexto!,
                            ].join(' · '),
                            style: const TextStyle(
                              fontSize: 12,
                              color: CoresApp.secundario,
                            ),
                          ),
                          if (receita.avaliacaoTexto != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              '★ ${receita.avaliacaoTexto} / 5',
                              semanticsLabel:
                                  'Avaliação ${receita.avaliacaoTexto} de 5',
                              style: const TextStyle(
                                color: CoresApp.verde,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BotaoFavorito(receita: receita, controller: controller),
          const SizedBox(width: 4),
        ],
      ),
    ),
  );
}
