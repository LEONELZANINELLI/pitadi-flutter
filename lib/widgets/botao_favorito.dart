import 'package:material_ui/material_ui.dart';

import '../controllers/receitas_controller.dart';
import '../models/receita.dart';
import '../tema.dart';

class BotaoFavorito extends StatelessWidget {
  final Receita receita;
  final ReceitasController controller;
  const BotaoFavorito({
    super.key,
    required this.receita,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final salva = controller.ehFavorita(receita.id);
    return IconButton(
      tooltip:
          '${salva ? 'Remover dos' : 'Adicionar aos'} favoritos: ${receita.nome}',
      isSelected: salva,
      color: CoresApp.primario,
      icon: const Icon(Icons.favorite_border),
      selectedIcon: const Icon(Icons.favorite),
      onPressed: () => controller.alternarFavorito(receita),
    );
  }
}
