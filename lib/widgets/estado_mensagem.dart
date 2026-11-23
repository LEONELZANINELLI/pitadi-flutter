import 'package:material_ui/material_ui.dart';

import '../tema.dart';

class EstadoMensagem extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;
  final String? acao;
  final VoidCallback? onAcao;
  const EstadoMensagem({
    super.key,
    required this.icone,
    required this.titulo,
    required this.descricao,
    this.acao,
    this.onAcao,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
    child: Column(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: CoresApp.destaque,
          child: Icon(icone, size: 30, color: CoresApp.primario),
        ),
        const SizedBox(height: 20),
        Semantics(
          liveRegion: true,
          child: Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          descricao,
          textAlign: TextAlign.center,
          style: const TextStyle(color: CoresApp.secundario, height: 1.5),
        ),
        if (acao != null) ...[
          const SizedBox(height: 20),
          FilledButton(onPressed: onAcao, child: Text(acao!)),
        ],
      ],
    ),
  );
}
