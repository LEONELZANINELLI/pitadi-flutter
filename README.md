# Pitadi 🍲

**Um toque de sabor em cada receita.** Aplicativo de receitas desenvolvido por Leonel Zaninelli de Souza para a atividade individual de Introdução ao Desenvolvimento com Flutter.

O projeto adapta os requisitos e as telas de referência do trabalho **Saborê** para a identidade **Pitadi**. A interface está em português; nomes, ingredientes e instruções continuam no idioma recebido da API, conforme permitido no enunciado.

## Funcionalidades

- Carregamento automático de receitas reais da [DummyJSON Recipes](https://dummyjson.com/docs/recipes).
- Listagem com imagem, nome, tempo total, dificuldade e avaliação disponíveis.
- Pesquisa remota por nome, validação de espaços e consulta vazia, envio pelo teclado e botão para limpar.
- Detalhes com ingredientes, passos numerados, porções e tipos de refeição.
- Favoritos compartilhados entre listagem e detalhes, sem duplicatas, durante a sessão.
- Feedback de carregamento, bloqueio de envios repetidos, erros com nova tentativa e estados vazios distintos.
- Alternativa visual para imagem ausente ou quebrada; leitura com rolagem e texto ampliado.
- Retorno dos detalhes preservando a consulta, o texto digitado e a posição da listagem.

## Ambiente e dependências

| Item | Versão / finalidade |
| --- | --- |
| Flutter | 3.50.1 stable usado na validação automatizada; mínimo declarado 3.47.0 |
| Dart | >= 3.13.0 e < 4.0.0; validado com Dart 3.14.0; utilize o SDK incluído no Flutter |
| Java | JDK 17 para Android |
| `http` | ^1.6.0, chamadas HTTP e cliente injetável para testes |
| `material_ui` | ^1.11.1, biblioteca oficial de componentes Material e localização pt-BR |
| `flutter_test` / `flutter_lints` | Testes e análise estática |

As versões resolvidas ficam em `pubspec.lock`. Se sua instalação for anterior ao Flutter 3.47, atualize pelo canal stable antes de executar. Android Studio / Android SDK são necessários para compilar o APK. Não há chaves, login, backend próprio ou banco de dados.

## Executar

Na primeira vez:

```bash
git clone https://github.com/LEONELZANINELLI/pitadi-flutter.git
cd pitadi-flutter
git switch feat/pitadi-entrega-final
flutter --version
flutter doctor
flutter pub get
flutter devices
flutter run
```

Enquanto a entrega estiver em uma branch, selecione `feat/pitadi-entrega-final`. Após integrar a entrega à `main`, basta usar a `main`.

Para atualizar uma cópia que já está no computador, salve suas alterações antes de trocar de branch:

```bash
git fetch origin
git switch feat/pitadi-entrega-final
flutter pub get
flutter run
```

Se `git switch` avisar sobre arquivos locais modificados, preserve-os em um commit ou em `git stash` antes de continuar. Os exemplos de aula que só existem no computador não precisam ser removidos para executar o Pitadi: a entrada do aplicativo é `lib/main.dart`.

Também é possível executar no navegador:

```bash
flutter run -d chrome
```

É necessária conexão com a internet para consultar a API e carregar imagens. A permissão `INTERNET` está no manifesto principal do Android, incluindo builds de release.

## Verificar e compilar

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test --coverage
flutter build web --release
flutter build apk --debug
```

O APK de demonstração fica em `build/app/outputs/flutter-apk/app-debug.apk`. Os arquivos web ficam em `build/web/`. O workflow [Validar Pitadi](../../actions) executa as verificações e disponibiliza o artefato `pitadi-validacao`, contendo os builds, a cobertura e o lockfile. APK de debug é adequado para demonstração acadêmica; não é uma versão assinada para loja.

## Organização do código

```text
lib/
  main.dart                         # runApp
  principal.dart                    # MaterialApp, idioma e tema
  receitas.dart                     # Explorar, pesquisa e aba Favoritos
  perfil.dart                       # Sobre o aplicativo e autor
  tema.dart                         # Paleta e componentes Material 3
  models/receita.dart                # JSON, identidade e campos opcionais
  services/receitas_service.dart     # HTTP, status, timeout e validação
  controllers/receitas_controller.dart # Estado compartilhado da sessão
  screens/detalhe_receita.dart       # Receita completa e navegação de retorno
  widgets/                          # Formulário, card, imagem e mensagens
```

A estrutura usa recursos básicos do Flutter: `StatefulWidget`, `StatelessWidget`, `Form`, `Navigator`, `ChangeNotifier` e `ListenableBuilder`. Não há necessidade de Provider, Bloc ou geração de código. Os arquivos foram padronizados em `snake_case`. O Flutter atual separou a biblioteca Material no pacote oficial `material_ui`; os widgets continuam sendo `MaterialApp`, `Scaffold`, `TextFormField` e os demais componentes usados em aula. [Guia oficial de migração](https://pub.dev/packages/material_ui).

## Decisões da integração

**Listagem:** `GET https://dummyjson.com/recipes?limit=0`. O conjunto escolhido é o catálogo completo disponibilizado pelo serviço. Para este conjunto pequeno, a atividade não precisa de paginação.

**Pesquisa:** `GET https://dummyjson.com/recipes/search?q=<nome>&limit=0`. O termo passa por `trim()` e a URI codifica os parâmetros. Não há filtro local simulando uma busca remota.

**Detalhe:** reaproveita o objeto completo retornado na listagem ou pesquisa. Os endpoints já trazem ingredientes e instruções, portanto abrir detalhes não faz outra requisição nem perde o contexto de pesquisa.

**Concorrência:** `initState()` inicia a primeira carga. O controller impede outra consulta enquanto houver uma em andamento, e campo, envio e limpeza ficam desabilitados durante esse período. A resposta só atualiza o estado se o controller continuar ativo. Reconstruções de widgets não iniciam requisições.

**Favoritos:** um único `Map<int, Receita>` no controller, indexado pelo ID. Listagem, detalhes e aba Favoritos observam essa mesma instância. Fechar ou reiniciar o aplicativo limpa os favoritos, como permitido pelo enunciado.

**Dados opcionais:** avaliação aceita `num`, `mealType` é uma lista e os passos mantêm a ordem recebida. Total de minutos só é calculado se ambos os tempos forem utilizáveis. Tempo ausente não é tratado como zero; porções inválidas são omitidas. Imagens ausentes ou falhas mostram um ícone. JSON inválido, formato incompatível, timeout e erro HTTP apresentam mensagens compreensíveis e nova tentativa.

## Entrega acadêmica

- [Mapa dos requisitos RF01 a RF09 e conferência manual](docs/entrega.md).
- [Roteiro sugerido para o vídeo de 3 a 5 minutos](docs/roteiro_video.md).

O histórico já contém a primeira entrega visual. Os novos commits registram a evolução para integração remota e funcionalidades completas. O vídeo deve ser gravado pelo aluno, demonstrando o próprio aplicativo e explicando as decisões do código. Depois, envie no Classroom o link do repositório e o vídeo conforme a orientação do professor.
