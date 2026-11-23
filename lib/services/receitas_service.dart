import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/receita.dart';

class ReceitasException implements Exception {
  final String mensagem;
  const ReceitasException(this.mensagem);
  @override
  String toString() => mensagem;
}

/// Única camada que conhece HTTP e o formato da resposta da API.
class ReceitasService {
  final http.Client _client;
  final Duration timeout;

  ReceitasService({
    http.Client? client,
    this.timeout = const Duration(seconds: 15),
  }) : _client = client ?? http.Client();

  Future<List<Receita>> listar() =>
      _buscar(Uri.https('dummyjson.com', '/recipes', {'limit': '0'}));

  Future<List<Receita>> pesquisar(String nome) {
    final termo = nome.trim();
    if (termo.isEmpty) {
      throw const ReceitasException('Digite um nome para pesquisar.');
    }
    return _buscar(
      Uri.https('dummyjson.com', '/recipes/search', {'q': termo, 'limit': '0'}),
    );
  }

  Future<List<Receita>> _buscar(Uri uri) async {
    try {
      final response = await _client.get(uri).timeout(timeout);
      if (response.statusCode != 200) {
        throw const ReceitasException(
          'O serviço de receitas está indisponível. Tente novamente.',
        );
      }
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      if (json is! Map<String, dynamic> || json['recipes'] is! List) {
        throw const FormatException('Resposta sem lista de receitas.');
      }
      final receitas = <Receita>[];
      final ids = <int>{};
      for (final item in json['recipes'] as List) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Receita incompatível.');
        }
        final receita = Receita.fromJson(item);
        if (ids.add(receita.id)) receitas.add(receita);
      }
      return List.unmodifiable(receitas);
    } on TimeoutException {
      throw const ReceitasException(
        'A conexão demorou demais. Verifique sua internet e tente novamente.',
      );
    } on http.ClientException {
      throw const ReceitasException(
        'Não foi possível conectar. Verifique sua internet e tente novamente.',
      );
    } on FormatException {
      throw const ReceitasException(
        'O serviço retornou dados inválidos. Tente novamente em instantes.',
      );
    }
  }

  void dispose() => _client.close();
}
