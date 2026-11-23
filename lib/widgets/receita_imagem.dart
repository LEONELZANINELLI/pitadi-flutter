import 'package:flutter/material.dart';
import '../tema.dart';

class ReceitaImagem extends StatelessWidget {
  final String? url;
  final String nome;
  const ReceitaImagem({super.key, required this.url, required this.nome});

  @override
  Widget build(BuildContext context) {
    final alternativa = ColoredBox(
      color: CoresApp.destaque,
      child: Center(
        child: Semantics(
          label: 'Imagem indisponível para $nome',
          child: const Icon(
            Icons.restaurant_outlined,
            size: 36,
            color: CoresApp.primario,
          ),
        ),
      ),
    );
    if (url == null) return alternativa;
    return Image.network(
      url!,
      fit: BoxFit.cover,
      semanticLabel: nome,
      errorBuilder: (context, error, stackTrace) => alternativa,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : const ColoredBox(
              color: CoresApp.destaque,
              child: Center(
                child: Icon(
                  Icons.restaurant_outlined,
                  size: 32,
                  color: CoresApp.primario,
                ),
              ),
            ),
    );
  }
}
