import 'package:app/models/receita.dart';
import 'package:flutter_test/flutter_test.dart';
import '../fixtures.dart';

void main() {
  test('lê os campos da API e preserva a ordem dos passos', () {
    final receita = Receita.fromJson(receitaJson);
    expect(receita.id, 1);
    expect(receita.tempoTotal, 35);
    expect(receita.instrucoes.last, 'Bake and serve.');
    expect(receita.tiposRefeicao, ['Dinner', 'Lunch']);
    expect(receita.avaliacaoTexto, '4,6');
    expect(receita.dificuldadeTexto, 'Fácil');
  });

  test('aceita rating inteiro e não inventa campos ausentes', () {
    final receita = Receita.fromJson({'id': 2, 'rating': 5});
    expect(receita.avaliacaoTexto, '5,0');
    expect(receita.nome, 'Receita sem nome');
    expect(receita.tempoTotal, isNull);
    expect(receita.porcoes, isNull);
    expect(receita.ingredientes, isEmpty);
    expect(receita.imagem, isNull);
  });

  test('tempo parcial não vira total e zero informado é válido', () {
    expect(
      Receita.fromJson({'id': 1, 'prepTimeMinutes': 5}).tempoTotal,
      isNull,
    );
    expect(
      Receita.fromJson({
        'id': 1,
        'prepTimeMinutes': 0,
        'cookTimeMinutes': 0,
      }).tempoTotal,
      0,
    );
  });

  test('metadados opcionais de tipos inválidos ficam ausentes', () {
    final receita = Receita.fromJson({
      'id': 1,
      'prepTimeMinutes': '20',
      'cookTimeMinutes': -1,
      'servings': 0,
      'rating': 10,
      'image': 'javascript:alert(1)',
    });
    expect(receita.tempoTotal, isNull);
    expect(receita.porcoes, isNull);
    expect(receita.avaliacao, isNull);
    expect(receita.imagem, isNull);
  });

  test('recusa identificador inválido e listas incompatíveis', () {
    for (final json in [
      {'id': 0},
      {'id': 1.5},
      {'id': '1'},
      {'id': 1, 'mealType': 'Dinner'},
      {
        'id': 1,
        'instructions': [123],
      },
    ]) {
      expect(() => Receita.fromJson(json), throwsFormatException);
    }
  });
}
