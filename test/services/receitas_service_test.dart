import 'dart:async';
import 'dart:convert';
import 'package:app/services/receitas_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import '../fixtures.dart';

void main() {
  test('listagem usa API remota e elimina IDs repetidos', () async {
    final service = ReceitasService(
      client: MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.host, 'dummyjson.com');
        expect(request.url.path, '/recipes');
        expect(request.url.queryParameters['limit'], '0');
        return http.Response(
          jsonEncode({
            'recipes': [receitaJson, receitaJson],
          }),
          200,
        );
      }),
    );
    addTearDown(service.dispose);
    expect(await service.listar(), hasLength(1));
  });

  test('pesquisa remota recorta espaços e codifica caracteres', () async {
    final service = ReceitasService(
      client: MockClient((request) async {
        expect(request.url.path, '/recipes/search');
        expect(request.url.queryParameters['q'], 'pão & cheese');
        return http.Response('{"recipes":[]}', 200);
      }),
    );
    addTearDown(service.dispose);
    expect(await service.pesquisar('  pão & cheese  '), isEmpty);
    expect(() => service.pesquisar('   '), throwsA(isA<ReceitasException>()));
  });

  test('distingue lista vazia válida de JSON ou corpo incompatível', () async {
    for (final body in [
      '<html>erro</html>',
      '{}',
      '{"recipes":{}}',
      '{"recipes":[null]}',
      '{"recipes":[{"name":"sem id"}]}',
    ]) {
      final service = ReceitasService(
        client: MockClient((_) async => http.Response(body, 200)),
      );
      await expectLater(
        service.listar(),
        throwsA(
          isA<ReceitasException>().having(
            (e) => e.mensagem,
            'mensagem',
            contains('dados inválidos'),
          ),
        ),
      );
      service.dispose();
    }
  });

  test('status HTTP de erro recebe mensagem compreensível', () async {
    final service = ReceitasService(
      client: MockClient((_) async => http.Response('erro', 503)),
    );
    addTearDown(service.dispose);
    await expectLater(
      service.listar(),
      throwsA(
        isA<ReceitasException>().having(
          (e) => e.mensagem,
          'mensagem',
          contains('indisponível'),
        ),
      ),
    );
  });

  test('falha de rede e timeout permitem nova tentativa', () async {
    final offline = ReceitasService(
      client: MockClient((_) async {
        throw http.ClientException('offline');
      }),
    );
    addTearDown(offline.dispose);
    await expectLater(
      offline.listar(),
      throwsA(
        isA<ReceitasException>().having(
          (e) => e.mensagem,
          'mensagem',
          contains('internet'),
        ),
      ),
    );
    final lento = ReceitasService(
      client: MockClient((_) => Completer<http.Response>().future),
      timeout: const Duration(milliseconds: 5),
    );
    addTearDown(lento.dispose);
    await expectLater(
      lento.listar(),
      throwsA(
        isA<ReceitasException>().having(
          (e) => e.mensagem,
          'mensagem',
          contains('demorou'),
        ),
      ),
    );
  });
}
