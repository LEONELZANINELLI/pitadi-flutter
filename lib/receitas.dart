import 'package:material_ui/material_ui.dart';

import 'perfil.dart';
import 'controllers/receitas_controller.dart';
import 'models/receita.dart';
import 'screens/detalhe_receita.dart';
import 'services/receitas_service.dart';
import 'tema.dart';
import 'widgets/estado_mensagem.dart';
import 'widgets/formulario_pesquisa.dart';
import 'widgets/receita_card.dart';

class Receitas extends StatefulWidget {
  final ReceitasService? service;
  const Receitas({super.key, this.service});

  @override
  State<Receitas> createState() => _ReceitasState();
}

class _ReceitasState extends State<Receitas> {
  late final ReceitasController _controller;
  int _aba = 0;

  @override
  void initState() {
    super.initState();
    _controller = ReceitasController(widget.service ?? ReceitasService());
    _controller.iniciar(); // Uma vez por sessão, nunca dentro de build.
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _abrir(Receita receita) => Navigator.push<void>(
    context,
    MaterialPageRoute(
      builder: (_) => DetalheReceita(receita: receita, controller: _controller),
    ),
  );

  Widget _conteudo(bool favoritos) {
    if (favoritos && _controller.favoritos.isEmpty) {
      return EstadoMensagem(
        icone: Icons.favorite_border,
        titulo: 'Nenhum favorito ainda',
        descricao: 'Toque no coração de uma receita para encontrá-la aqui.',
        acao: 'Explorar receitas',
        onAcao: () => setState(() => _aba = 0),
      );
    }
    if (!favoritos && _controller.carregando) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            CircularProgressIndicator(semanticsLabel: 'Carregando receitas'),
            SizedBox(height: 20),
            Text('Carregando receitas…'),
          ],
        ),
      );
    }
    if (!favoritos && _controller.erro != null) {
      return EstadoMensagem(
        icone: Icons.wifi_off_outlined,
        titulo: 'Não foi possível carregar as receitas',
        descricao: _controller.erro!,
        acao: 'Tentar novamente',
        onAcao: _controller.tentarNovamente,
      );
    }
    final receitas = favoritos ? _controller.favoritos : _controller.receitas;
    if (receitas.isEmpty) {
      return EstadoMensagem(
        icone: Icons.search_off_outlined,
        titulo: _controller.consulta == null
            ? 'Nenhuma receita disponível'
            : 'Nenhum resultado',
        descricao: _controller.consulta == null
            ? 'O serviço não retornou receitas. Tente novamente.'
            : 'Não encontramos receitas para esse nome. Tente outro termo.',
        acao: 'Ver todas as receitas',
        onAcao: _controller.listar,
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: receitas.length,
      itemBuilder: (context, index) => ReceitaCard(
        receita: receitas[index],
        controller: _controller,
        onAbrir: () => _abrir(receitas[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _controller,
    builder: (context, _) {
      final favoritos = _aba == 1;
      final pesquisando = _controller.consulta != null;
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 72,
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.restaurant_menu, color: CoresApp.primario, size: 24),
              SizedBox(width: 8),
              Text(
                'pitadi',
                style: TextStyle(
                  color: CoresApp.primario,
                  fontSize: 29,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Sobre o Pitadi',
              icon: const Icon(Icons.info_outline),
              onPressed: () => Navigator.push<void>(
                context,
                MaterialPageRoute(builder: (_) => const Perfil()),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(
                key: const PageStorageKey('receitas'),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  Text(
                    favoritos
                        ? 'Suas receitas favoritas'
                        : 'O que vamos cozinhar hoje?',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    favoritos
                        ? 'Receitas salvas nesta sessão. Toque no coração para remover.'
                        : 'Um toque de sabor em cada receita.',
                    style: const TextStyle(
                      color: CoresApp.secundario,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Mantém o formulário montado para preservar o texto entre abas.
                  Offstage(
                    offstage: favoritos,
                    child: FormularioPesquisa(
                      carregando: _controller.carregando,
                      pesquisando: pesquisando,
                      onPesquisar: _controller.pesquisar,
                      onLimpar: _controller.listar,
                    ),
                  ),
                  if (!favoritos) ...[
                    const SizedBox(height: 24),
                    Text(
                      pesquisando
                          ? 'Resultados para “${_controller.consulta}”'
                          : 'Receitas disponíveis',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _controller.carregando
                          ? 'Buscando novas ideias para sua cozinha…'
                          : _controller.erro != null
                          ? 'Vamos tentar de novo?'
                          : '${_controller.receitas.length} receitas · Toque para ver o preparo.',
                      style: const TextStyle(
                        color: CoresApp.secundario,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _conteudo(favoritos),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _aba,
          onDestinationSelected: (indice) => setState(() => _aba = indice),
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
              label: 'Explorar',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: _controller.favoritos.isNotEmpty,
                label: Text('${_controller.favoritos.length}'),
                child: const Icon(Icons.favorite_border),
              ),
              selectedIcon: const Icon(Icons.favorite),
              label: 'Favoritos',
            ),
          ],
        ),
      );
    },
  );
}
