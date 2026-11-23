# Conferência da entrega Pitadi

Referências: enunciado e guia visual do aplicativo Saborê fornecidos pelo professor. O nome adotado para a implementação é Pitadi.

## Rastreabilidade

| Requisito | Implementação | Evidência de verificação |
| --- | --- | --- |
| RF01 - Principal | Identidade Pitadi, pesquisa evidente, carga em `initState()` | Teste de inicialização única no controller |
| RF02 - Listagem | Catálogo remoto com nome, imagem e rolagem | Testes do serviço e teste de tela estreita |
| RF03 - Pesquisa | `/recipes/search`, `trim()`, recusa vazia e limpar | Testes da URL remota, formulário e retorno à listagem |
| RF04 - Detalhes | Objeto completo, ingredientes e passos ordenados | Modelo, navegação e rolagem até o último botão |
| RF05 - Favoritos | `Map<int, Receita>` compartilhado na sessão | Testes de alternância por ID e remoção entre telas |
| RF06 - Carregamento | Indicador, formulário desabilitado e trava no controller | Testes de operação concorrente e botão bloqueado |
| RF07 - Erros | Rede, status, JSON, timeout e nova tentativa | Testes do serviço, consulta retida e recuperação da interface |
| RF08 - Ausência | Mensagens distintas para busca, catálogo e favoritos vazios | Teste de estados vazios na interface |
| RF09 - Navegação | `Navigator.push/pop` mantém a tela de origem montada | Teste busca → detalhe → favorito → retorno sem nova consulta |

## Conferência manual antes de gravar

1. Execute `flutter run` com internet: observe o carregamento inicial e as receitas recebidas.
2. Toque em Pesquisar sem preencher ou digitando apenas espaços: aparece uma validação e não ocorre consulta extra.
3. Pesquise `  pizza  `: o título dos resultados usa `pizza`. Pode haver várias receitas; os resultados dependem do serviço.
4. Abra uma receita. Confira ingredientes, passos numerados, tipos de refeição, porções e avaliação. Role até o final e volte.
5. Confirme que a pesquisa e a posição da listagem continuam disponíveis.
6. Toque no coração na lista e consulte Favoritos. Abra o detalhe por essa aba e remova o favorito. Ao voltar, a aba deve refletir a remoção.
7. Remova todos os favoritos: confira a mensagem exclusiva dessa situação e o botão Explorar receitas.
8. Pesquise `zzzz987`: confira a mensagem Nenhum resultado. Use Limpar pesquisa para recarregar o catálogo e esvaziar o campo.
9. Desative a rede e faça uma nova consulta. Confira a mensagem de erro, reative a rede e toque em Tentar novamente. A consulta anterior deve ser repetida.
10. Para verificar uma imagem quebrada sem depender do serviço falhar: no navegador, bloqueie `*cdn.dummyjson.com*` pela ferramenta Network request blocking do DevTools e recarregue. A API de receitas continua acessível e os cards usam a alternativa visual. Remova o bloqueio ao terminar.
11. Confira em largura pequena e com fonte ampliada: o conteúdo deve continuar legível e rolável.
12. Reinicie o aplicativo: os favoritos voltam vazios porque são mantidos somente durante a sessão.

## Escopo da entrega

- Fonte e documentação ficam no GitHub, com o histórico da primeira entrega preservado.
- O README informa descrição, funcionalidades, dependências, SDK e execução.
- A validação automatizada está em `.github/workflows/flutter.yml` e os testes não dependem da disponibilidade da API pública.
- A demonstração real depende da disponibilidade de DummyJSON e da conexão do dispositivo.
- É necessário gravar e enviar o vídeo individual de 3 a 5 minutos no Classroom. Um roteiro não substitui essa gravação.
- O enunciado fornecido não detalha critérios separados por aula. Os commits registram a evolução real; não foram inventadas entregas de aulas passadas.
