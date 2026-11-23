import 'package:flutter/foundation.dart';
import '../models/receita.dart';
import '../services/receitas_service.dart';

/// Uma fonte de verdade para consulta e favoritos em todas as telas.
class ReceitasController extends ChangeNotifier {
  final ReceitasService _service;
  final Map<int, Receita> _favoritos = {};
  List<Receita> _receitas = const [];
  bool _carregando = false;
  bool _iniciado = false;
  bool _descartado = false;
  String? _erro;
  String? _consulta;

  ReceitasController(this._service);

  List<Receita> get receitas => _receitas;
  List<Receita> get favoritos => List.unmodifiable(_favoritos.values);
  bool get carregando => _carregando;
  String? get erro => _erro;
  String? get consulta => _consulta;
  bool ehFavorita(int id) => _favoritos.containsKey(id);

  Future<void> iniciar() async {
    if (_iniciado || _descartado) return;
    _iniciado = true;
    await listar();
  }

  Future<void> listar() => _carregar(null);

  Future<void> pesquisar(String nome) async {
    if (nome.trim().isEmpty) return;
    await _carregar(nome.trim());
  }

  Future<void> tentarNovamente() => _carregar(_consulta);

  Future<void> _carregar(String? consulta) async {
    // O formulário também fica desabilitado: uma consulta por vez.
    if (_carregando || _descartado) return;
    _consulta = consulta;
    _erro = null;
    _carregando = true;
    notifyListeners();
    try {
      final resultado = consulta == null
          ? await _service.listar()
          : await _service.pesquisar(consulta);
      if (!_descartado) _receitas = resultado;
    } on ReceitasException catch (e) {
      if (!_descartado) _erro = e.mensagem;
    } catch (_) {
      if (!_descartado) {
        _erro = 'Não foi possível carregar as receitas. Tente novamente.';
      }
    } finally {
      if (!_descartado) {
        _carregando = false;
        notifyListeners();
      }
    }
  }

  void alternarFavorito(Receita receita) {
    if (_descartado) return;
    if (ehFavorita(receita.id)) {
      _favoritos.remove(receita.id);
    } else {
      _favoritos[receita.id] = receita;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _descartado = true;
    _service.dispose();
    super.dispose();
  }
}
