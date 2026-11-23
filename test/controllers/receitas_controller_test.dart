import 'dart:async';
import 'dart:convert';
import 'package:app/controllers/receitas_controller.dart';
import 'package:app/models/receita.dart';
import 'package:app/services/receitas_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import '../fixtures.dart';

void main() {
  test('inicia uma vez e ignora operações concorrentes', () async {
    final resposta = Completer<http.Response>();
    var chamadas = 0;
    final controller = ReceitasController(
      ReceitasService(
        client: MockClient((_) {
          chamadas++;
          return resposta.future;
        }),
      ),
    );
    addTearDown(controller.dispose);
    final inicio = controller.iniciar();
    await controller.iniciar();
    await controller.pesquisar('pizza');
    expect(chamadas, 1);
    expect(controller.carregando, isTrue);
    resposta.complete(
      http.Response(
        jsonEncode({
          'recipes': [receitaJson],
        }),
        200,
      ),
    );
    await inicio;
    expect(controller.carregando, isFalse);
    expect(controller.receitas.single.nome, 'Classic Margherita Pizza');
  });

  test('erro mantém a consulta para tentar novamente', () async {
    var chamadas = 0;
    final controller = ReceitasController(
      ReceitasService(
        client: MockClient((request) async {
          expect(request.url.queryParameters['q'], 'pizza');
          return chamadas++ == 0
              ? http.Response('', 500)
              : http.Response(
                  jsonEncode({
                    'recipes': [receitaJson],
                  }),
                  200,
                );
        }),
      ),
    );
    addTearDown(controller.dispose);
    await controller.pesquisar('  pizza  ');
    expect(controller.consulta, 'pizza');
    expect(controller.erro, isNotNull);
    await controller.tentarNovamente();
    expect(controller.erro, isNull);
    expect(controller.receitas, hasLength(1));
  });

  test('favoritos usam o ID e são compartilhados sem duplicatas', () {
    final controller = ReceitasController(
      ReceitasService(client: MockClient((_) async => http.Response('', 200))),
    );
    addTearDown(controller.dispose);
    controller.alternarFavorito(Receita.fromJson(receitaJson));
    expect(controller.ehFavorita(1), isTrue);
    controller.alternarFavorito(Receita.fromJson(receitaJson));
    expect(controller.favoritos, isEmpty);
    controller.alternarFavorito(Receita.fromJson(receitaJson));
    expect(controller.favoritos, hasLength(1));
  });

  test('resposta após descarte não notifica tela removida', () async {
    final resposta = Completer<http.Response>();
    final controller = ReceitasController(
      ReceitasService(client: MockClient((_) => resposta.future)),
    );
    final operacao = controller.iniciar();
    controller.dispose();
    resposta.complete(http.Response('{"recipes":[]}', 200));
    await expectLater(operacao, completes);
  });
}
