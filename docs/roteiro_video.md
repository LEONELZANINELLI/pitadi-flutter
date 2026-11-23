# Roteiro de vídeo - Pitadi

Duração sugerida: aproximadamente 4 minutos. Grave sua tela, mostre o próprio app em execução e explique o código com suas palavras. Não é necessário decorar este texto.

## 0:00 a 0:25 - Apresentação

“Eu sou o Leonel e este é o Pitadi, meu aplicativo de receitas em Flutter. Ele permite explorar receitas, pesquisar pelo nome, consultar ingredientes e preparo e escolher favoritos. Os dados vêm da API pública DummyJSON.”

Mostre a tela inicial e a identidade do aplicativo.

## 0:25 a 1:20 - Listagem, pesquisa e detalhes

- Role a listagem e mostre nome, imagem, minutos e avaliação.
- Clique em Pesquisar sem digitar e explique a validação.
- Pesquise `pizza`, abra uma receita e mostre ingredientes e passos.
- Role o preparo e volte, destacando que a consulta foi preservada.
- Explique que os dados da receita podem estar em inglês, conforme permitido na atividade.

## 1:20 a 1:55 - Favoritos e estados vazios

- Salve uma receita pelo coração e abra a aba Favoritos.
- Abra os detalhes pelo favorito e remova-o.
- Volte para mostrar a tela Nenhum favorito ainda.
- Pesquise `zzzz987` e mostre a mensagem de busca sem resultados.
- Use Limpar pesquisa e volte ao catálogo.

## 1:55 a 2:25 - Carregamento e erro

Mostre o indicador na carga inicial. Se for difícil visualizá-lo por a conexão ser rápida, use uma limitação de rede no navegador.

Desative a rede, faça uma nova consulta e mostre a mensagem e o botão Tentar novamente. Reative a rede e tente de novo. Explique que esse estado é diferente de uma busca sem resultados.

## 2:25 a 3:35 - Explicação do código

Abra os arquivos no editor e aponte os trechos:

1. `main.dart` e `principal.dart`: entrada, `MaterialApp`, tema e idioma.
2. `models/receita.dart`: conversão do JSON, campos opcionais, lista de passos e cálculo de tempo somente quando os dois valores existem.
3. `services/receitas_service.dart`: GET assíncrono com `http`, endpoints da listagem e pesquisa, status HTTP, JSON e timeout.
4. `controllers/receitas_controller.dart`: carregamento, consulta atual, bloqueio de operações repetidas e `Map` de favoritos por ID.
5. `receitas.dart` e `screens/detalhe_receita.dart`: widgets observam o controller e o `Navigator` abre e fecha o detalhe.

“Eu reutilizo o objeto completo da resposta no detalhe porque a API já envia ingredientes e instruções. Os favoritos ficam na memória e são compartilhados pelas telas; ao reiniciar, são limpos.”

## 3:35 a 4:10 - Verificação e entrega

Mostre os testes ou uma execução concluída do GitHub Actions. Explique um caso que você entendeu, como impedir duas consultas simultâneas ou retornar de um erro mantendo o termo pesquisado.

Mostre o README e o link do repositório. Termine a gravação entre 3 e 5 minutos. Confira se sua voz, o app e o editor estão legíveis antes de enviar.

## Perguntas para se preparar

- Qual a diferença entre pesquisa remota e filtrar uma lista local?
- Por que o GET inicial fica em `initState()` em vez de `build()`?
- Como listagem e detalhes enxergam os mesmos favoritos?
- Por que o ID é mais adequado que o nome para evitar duplicatas?
- Por que falta de tempo não deve ser transformada em zero?
- Qual a diferença entre falha de rede e uma busca que retornou uma lista vazia?
- Por que o detalhe não precisa de outra chamada HTTP nesta implementação?
