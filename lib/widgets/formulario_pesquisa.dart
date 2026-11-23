import 'package:material_ui/material_ui.dart';

class FormularioPesquisa extends StatefulWidget {
  final bool carregando;
  final bool pesquisando;
  final ValueChanged<String> onPesquisar;
  final VoidCallback onLimpar;
  const FormularioPesquisa({
    super.key,
    required this.carregando,
    required this.pesquisando,
    required this.onPesquisar,
    required this.onLimpar,
  });

  @override
  State<FormularioPesquisa> createState() => _FormularioPesquisaState();
}

class _FormularioPesquisaState extends State<FormularioPesquisa> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();

  void _pesquisar() {
    if (widget.carregando || !_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    widget.onPesquisar(_nome.text.trim());
  }

  void _limpar() {
    _nome.clear();
    _formKey.currentState?.reset();
    FocusScope.of(context).unfocus();
    widget.onLimpar();
  }

  @override
  void dispose() {
    _nome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _nome,
          enabled: !widget.carregando,
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (_) => _pesquisar(),
          validator: (valor) => valor == null || valor.trim().isEmpty
              ? 'Digite um nome para pesquisar.'
              : null,
          decoration: const InputDecoration(
            labelText: 'Nome da receita',
            hintText: 'Ex.: pizza, chicken, pasta',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: widget.carregando ? null : _pesquisar,
          icon: const Icon(Icons.search, size: 20),
          label: const Text('Pesquisar receitas'),
        ),
        if (widget.pesquisando) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: widget.carregando ? null : _limpar,
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Limpar pesquisa'),
          ),
        ],
      ],
    ),
  );
}
