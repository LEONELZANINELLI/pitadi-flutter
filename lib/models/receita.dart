/// Dados recebidos da DummyJSON. Campos opcionais ausentes continuam nulos.
class Receita {
  final int id;
  final String nome;
  final String? imagem;
  final List<String> ingredientes;
  final List<String> instrucoes;
  final int? tempoPreparo;
  final int? tempoCozimento;
  final int? porcoes;
  final num? avaliacao;
  final String? dificuldade;
  final String? culinaria;
  final List<String> tiposRefeicao;

  const Receita({
    required this.id,
    required this.nome,
    this.imagem,
    this.ingredientes = const [],
    this.instrucoes = const [],
    this.tempoPreparo,
    this.tempoCozimento,
    this.porcoes,
    this.avaliacao,
    this.dificuldade,
    this.culinaria,
    this.tiposRefeicao = const [],
  });

  factory Receita.fromJson(Map<String, dynamic> json) {
    final id = _inteiro(json['id']);
    if (id == null || id <= 0) {
      throw const FormatException('Receita sem identificador válido.');
    }
    final avaliacao = json['rating'];
    return Receita(
      id: id,
      nome: _texto(json['name']) ?? 'Receita sem nome',
      imagem: _urlImagem(json['image']),
      ingredientes: _lista(json['ingredients']),
      instrucoes: _lista(json['instructions']),
      tempoPreparo: _inteiro(json['prepTimeMinutes']),
      tempoCozimento: _inteiro(json['cookTimeMinutes']),
      porcoes: _inteiro(json['servings'], minimo: 1),
      avaliacao:
          avaliacao is num &&
              avaliacao.isFinite &&
              avaliacao >= 0 &&
              avaliacao <= 5
          ? avaliacao
          : null,
      dificuldade: _texto(json['difficulty']),
      culinaria: _texto(json['cuisine']),
      tiposRefeicao: _lista(json['mealType']),
    );
  }

  // Zero é válido quando informado pela API; ausência não vira zero.
  int? get tempoTotal => tempoPreparo != null && tempoCozimento != null
      ? tempoPreparo! + tempoCozimento!
      : null;

  String get tempoTexto =>
      tempoTotal == null ? 'Tempo não informado' : '$tempoTotal min';

  String? get avaliacaoTexto =>
      avaliacao?.toStringAsFixed(1).replaceAll('.', ',');

  String? get dificuldadeTexto => switch (dificuldade) {
    'Easy' => 'Fácil',
    'Medium' => 'Médio',
    'Hard' => 'Difícil',
    _ => dificuldade,
  };

  static String? _texto(dynamic valor) =>
      valor is String && valor.trim().isNotEmpty ? valor.trim() : null;

  static int? _inteiro(dynamic valor, {int minimo = 0}) =>
      valor is num &&
          valor.isFinite &&
          valor >= minimo &&
          valor == valor.roundToDouble()
      ? valor.toInt()
      : null;

  static List<String> _lista(dynamic valor) {
    if (valor == null) return const [];
    if (valor is! List || valor.any((item) => item is! String)) {
      throw const FormatException('Lista de receita incompatível.');
    }
    return List.unmodifiable(valor.cast<String>());
  }

  static String? _urlImagem(dynamic valor) {
    final texto = _texto(valor);
    final uri = texto == null ? null : Uri.tryParse(texto);
    return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty
        ? texto
        : null;
  }
}
