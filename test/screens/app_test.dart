import 'dart:async';
import 'dart:convert';
import 'package:app/principal.dart';
import 'package:app/services/receitas_service.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import '../fixtures.dart';

Future<void> abrir(WidgetTester tester, http.Client client) async {
  await tester.binding.setSurfaceSize(const Size(400, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(Principal(service: ReceitasService(client: client)));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('pesquisa vazia é recusada sem requisição extra', (tester) async {
    var chamadas = 0;
    await abrir(
      tester,
      MockClient((_) async {
        chamadas++;
        return http.Response(
          jsonEncode({
            'recipes': [receitaJson],
          }),
          200,
        );
      }),
    );
    await tester.tap(find.text('Pesquisar receitas'));
    await tester.pumpAndSettle();
    expect(find.text('Digite um nome para pesquisar.'), findsOneWidget);
    expect(chamadas, 1);
  });

  testWidgets('detalhe, favoritos e retorno preservam a busca', (tester) async {
    var chamadas = 0;
    await abrir(
      tester,
      MockClient((_) async {
        chamadas++;
        return http.Response(
          jsonEncode({
            'recipes': [receitaJson],
          }),
          200,
        );
      }),
    );
    await tester.enterText(find.byType(TextFormField), '  pizza  ');
    await tester.tap(find.text('Pesquisar receitas'));
    await tester.pumpAndSettle();
    expect(find.text('Resultados para “pizza”'), findsOneWidget);
    await tester.tap(find.text('Classic Margherita Pizza'));
    await tester.pumpAndSettle();
    expect(find.text('Ingredientes'), findsOneWidget);
    await tester.tap(
      find.byTooltip('Adicionar aos favoritos: Classic Margherita Pizza'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Salva'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Resultados para “pizza”'), findsOneWidget);
    expect(chamadas, 2); // Detalhe reaproveita o objeto completo.
    await tester.tap(find.text('Favoritos'));
    await tester.pumpAndSettle();
    expect(find.text('Classic Margherita Pizza'), findsOneWidget);
    await tester.tap(
      find.byTooltip('Remover dos favoritos: Classic Margherita Pizza'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nenhum favorito ainda'), findsOneWidget);
    await tester.tap(find.text('Explorar receitas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Limpar pesquisa'));
    await tester.pumpAndSettle();
    expect(find.text('Receitas disponíveis'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '  pizza  '), findsNothing);
    expect(chamadas, 3);
  });

  testWidgets('nenhum resultado é diferente de favoritos vazios', (
    tester,
  ) async {
    await abrir(
      tester,
      MockClient((_) async => http.Response('{"recipes":[]}', 200)),
    );
    await tester.enterText(find.byType(TextFormField), 'zzzz987');
    await tester.tap(find.text('Pesquisar receitas'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum resultado'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsNothing);
    await tester.tap(find.text('Favoritos'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum favorito ainda'), findsOneWidget);
  });

  testWidgets('erro de rede oferece nova tentativa funcional', (tester) async {
    var chamadas = 0;
    await abrir(
      tester,
      MockClient((_) async {
        if (chamadas++ == 0) throw http.ClientException('offline');
        return http.Response(
          jsonEncode({
            'recipes': [receitaJson],
          }),
          200,
        );
      }),
    );
    await tester.ensureVisible(find.text('Tentar novamente'));
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(find.text('Classic Margherita Pizza'), findsOneWidget);
  });

  testWidgets('carregamento desabilita envio e mostra feedback', (
    tester,
  ) async {
    final resposta = Completer<http.Response>();
    await tester.pumpWidget(
      Principal(
        service: ReceitasService(client: MockClient((_) => resposta.future)),
      ),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    resposta.complete(http.Response('{"recipes":[]}', 200));
    await tester.pumpAndSettle();
  });

  testWidgets('tela estreita e texto ampliado permitem rolagem sem overflow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      Principal(
        service: ReceitasService(
          client: MockClient(
            (_) async => http.Response(
              jsonEncode({
                'recipes': [receitaJson],
              }),
              200,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Classic Margherita Pizza'));
    await tester.tap(find.text('Classic Margherita Pizza'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Voltar às receitas'), 250);
    expect(tester.takeException(), isNull);
  });
}
