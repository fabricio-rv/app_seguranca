import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class EditarClientePage extends StatefulWidget {
  static const routeName = '/editar_cliente';

  @override
  State<EditarClientePage> createState() => _EditarClientePageState();
}

class _EditarClientePageState extends State<EditarClientePage> {
  final _repo = _InMemoryClientesRepository();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repo.seed();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF181883);
    final laranja = const Color(0xFFFF9900);
    final amarelo = const Color(0xFFFFD700);

    final query = _searchController.text.trim();
    final clientes = _repo.list();
    final filtrados = query.isEmpty
        ? clientes
        : clientes.where((c) {
            final q = query.toLowerCase();
            return c.nome.toLowerCase().contains(q) ||
                c.documento.toLowerCase().contains(q) ||
                c.codigo.toLowerCase().contains(q) ||
                c.particao.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              backgroundColor: azul,
              elevation: 0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                  splashRadius: 24,
                ),
              ),
            ),
            Container(
              height: 2,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [amarelo, const Color(0xFFFFE566), amarelo],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ],
        ),
      ),
      body: _FadeAndSlideTransition(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, const Color(0xFFFFFDF0)],
              stops: const [0, 1],
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  child: Column(
                    children: [
                      _HeaderSection(
                        azul: azul,
                        amarelo: amarelo,
                        total: clientes.length,
                        exibindo: filtrados.length,
                      ),
                      const SizedBox(height: 16),
                      _SearchBar(
                        controller: _searchController,
                        azul: azul,
                        amarelo: amarelo,
                      ),
                      const SizedBox(height: 18),
                      if (filtrados.isEmpty)
                        _EmptyState(azul: azul)
                      else
                        ...filtrados
                            .map(
                              (c) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _ClienteCard(
                                  cliente: c,
                                  azul: azul,
                                  amarelo: amarelo,
                                  onEditar: () async {
                                    final atualizado =
                                        await Navigator.push<_Cliente?>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                EditarClienteFormPage(
                                                  cliente: c,
                                                  azul: azul,
                                                  laranja: laranja,
                                                  amarelo: amarelo,
                                                ),
                                          ),
                                        );
                                    if (atualizado != null) {
                                      setState(() => _repo.upsert(atualizado));
                                    }
                                  },
                                  onExcluir: () {
                                    setState(() {
                                      _repo.remover(c.id);
                                    });
                                  },
                                ),
                              ),
                            )
                            .toList(),

                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditarClienteFormPage extends StatefulWidget {
  final _Cliente cliente;
  final Color azul;
  final Color laranja;
  final Color amarelo;

  const EditarClienteFormPage({
    required this.cliente,
    required this.azul,
    required this.laranja,
    required this.amarelo,
  });

  @override
  State<EditarClienteFormPage> createState() => _EditarClienteFormPageState();
}

class _EditarClienteFormPageState extends State<EditarClienteFormPage> {
  final _formKey = GlobalKey<FormState>();

  late _ClienteTipo _tipo;
  late bool _ativo;

  late final TextEditingController _docController;
  late final TextEditingController _nomeController;
  late final TextEditingController _espLocalController;
  late final TextEditingController _espPessoaController;
  late final TextEditingController _contatoController;
  late final TextEditingController _codigoController;
  late final TextEditingController _particaoController;
  late final TextEditingController _senhaController;

  late _Cliente _originalSnapshot;

  bool _senhaVisivel = false;

  @override
  void initState() {
    super.initState();
    _tipo = widget.cliente.tipo;
    _ativo = widget.cliente.ativo;

    _docController = TextEditingController(text: widget.cliente.documento);
    _nomeController = TextEditingController(text: widget.cliente.nome);
    _espLocalController = TextEditingController(
      text: widget.cliente.especificacaoLocal,
    );
    _espPessoaController = TextEditingController(
      text: widget.cliente.especificacaoPessoa,
    );
    _contatoController = TextEditingController(text: widget.cliente.contato);
    _codigoController = TextEditingController(text: widget.cliente.codigo);
    _particaoController = TextEditingController(text: widget.cliente.particao);
    _senhaController = TextEditingController(text: widget.cliente.senha);

    _originalSnapshot = _buildClienteSnapshot();
  }

  @override
  void dispose() {
    _docController.dispose();
    _nomeController.dispose();
    _espLocalController.dispose();
    _espPessoaController.dispose();
    _contatoController.dispose();
    _codigoController.dispose();
    _particaoController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  _Cliente _buildClienteSnapshot() {
    return widget.cliente.copyWith(
      tipo: _tipo,
      ativo: _ativo,
      documento: _docController.text.trim(),
      nome: _nomeController.text.trim(),
      especificacaoLocal: _espLocalController.text.trim(),
      especificacaoPessoa: _espPessoaController.text.trim(),
      contato: _contatoController.text.trim(),
      codigo: _codigoController.text.trim(),
      particao: _particaoController.text.trim(),
      senha: _senhaController.text,
    );
  }

  bool get _hasChanges => _buildClienteSnapshot() != _originalSnapshot;

  Future<bool> _confirmDiscardIfNeeded() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Descartar alterações?',
          style: TextStyle(color: widget.azul, fontWeight: FontWeight.w800),
        ),
        content: const Text(
          'Você alterou dados do cliente. Deseja sair sem salvar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Voltar',
              style: TextStyle(color: widget.azul, fontWeight: FontWeight.w700),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: widget.amarelo),
            child: Text(
              'Sair',
              style: TextStyle(color: widget.azul, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final atualizado = _buildClienteSnapshot().copyWith(
      atualizadoEm: DateTime.now(),
      atualizadoPor: 'ADM (mock)',
    );

    _originalSnapshot = atualizado;

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Salvo com sucesso',
          style: TextStyle(color: widget.azul, fontWeight: FontWeight.w800),
        ),
        content: const Text(
          'As alterações foram registradas no histórico do cliente.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            style: FilledButton.styleFrom(backgroundColor: widget.amarelo),
            child: Text(
              'Ok',
              style: TextStyle(color: widget.azul, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.pop(context, atualizado);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmDiscardIfNeeded,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                backgroundColor: widget.azul,
                elevation: 0,
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.white),
                title: Text(
                  'Editar Dados',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () async {
                      final canLeave = await _confirmDiscardIfNeeded();
                      if (!canLeave || !mounted) return;
                      Navigator.pop(context);
                    },
                    splashRadius: 24,
                  ),
                ),
              ),
              Container(
                height: 2,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.amarelo,
                      const Color(0xFFFFE566),
                      widget.amarelo,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: _FadeAndSlideTransition(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, const Color(0xFFFFFDF0)],
                stops: const [0, 1],
              ),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _ClienteSummaryCard(
                            cliente: _buildClienteSnapshot(),
                            azul: widget.azul,
                            amarelo: widget.amarelo,
                            laranja: widget.laranja,
                          ),
                          const SizedBox(height: 18),
                          _SectionTitle(
                            title: 'Dados do Cliente',
                            azul: widget.azul,
                            amarelo: widget.amarelo,
                          ),
                          const SizedBox(height: 14),
                          _TipoPessoaSelector(
                            tipo: _tipo,
                            azul: widget.azul,
                            laranja: widget.laranja,
                            onChanged: (value) {
                              setState(() {
                                _tipo = value;
                                _docController.clear();
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          _LabeledField(
                            label: _tipo == _ClienteTipo.pf ? 'CPF' : 'CNPJ',
                            azul: widget.azul,
                            laranja: widget.laranja,
                            child: TextFormField(
                              controller: _docController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                _tipo == _ClienteTipo.pf
                                    ? MaskedInputFormatter('###.###.###-##')
                                    : MaskedInputFormatter(
                                        '##.###.###/####-##',
                                      ),
                              ],
                              maxLength: _tipo == _ClienteTipo.pf ? 14 : 18,
                              style: TextStyle(
                                color: widget.azul,
                                fontSize: 16,
                              ),
                              cursorColor: widget.azul,
                              decoration: _inputDecoration(
                                azul: widget.azul,
                                amarelo: widget.amarelo,
                                hint: _tipo == _ClienteTipo.pf
                                    ? '000.000.000-00'
                                    : '00.000.000/0000-00',
                              ),
                              validator: (value) {
                                final v = (value ?? '').trim();
                                if (v.isEmpty) return 'Informe o documento';
                                if (_tipo == _ClienteTipo.pf && v.length != 14)
                                  return 'CPF inválido';
                                if (_tipo == _ClienteTipo.pj && v.length != 18)
                                  return 'CNPJ inválido';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 14),
                          _LabeledField(
                            label: _tipo == _ClienteTipo.pf
                                ? 'Nome Completo'
                                : 'Razão Social',
                            azul: widget.azul,
                            laranja: widget.laranja,
                            child: TextFormField(
                              controller: _nomeController,
                              maxLength: 150,
                              style: TextStyle(
                                color: widget.azul,
                                fontSize: 16,
                              ),
                              cursorColor: widget.azul,
                              decoration: _inputDecoration(
                                azul: widget.azul,
                                amarelo: widget.amarelo,
                                hint: _tipo == _ClienteTipo.pf
                                    ? 'Digite o nome completo'
                                    : 'Digite a razão social',
                              ),
                              validator: (value) => (value ?? '').trim().isEmpty
                                  ? 'Informe o nome'
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _LabeledField(
                            label: 'Especificação do Local',
                            azul: widget.azul,
                            laranja: widget.laranja,
                            child: TextFormField(
                              controller: _espLocalController,
                              maxLength: 150,
                              style: TextStyle(
                                color: widget.azul,
                                fontSize: 16,
                              ),
                              cursorColor: widget.azul,
                              decoration: _inputDecoration(
                                azul: widget.azul,
                                amarelo: widget.amarelo,
                                hint: 'Ex: Residencial, Comercial, Loja, etc.',
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _LabeledField(
                            label: 'Especificação da Pessoa',
                            azul: widget.azul,
                            laranja: widget.laranja,
                            child: TextFormField(
                              controller: _espPessoaController,
                              maxLength: 150,
                              style: TextStyle(
                                color: widget.azul,
                                fontSize: 16,
                              ),
                              cursorColor: widget.azul,
                              decoration: _inputDecoration(
                                azul: widget.azul,
                                amarelo: widget.amarelo,
                                hint: 'Ex: Apt 101, Setor, Responsável, etc.',
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _LabeledField(
                            label: 'Contato',
                            azul: widget.azul,
                            laranja: widget.laranja,
                            child: TextFormField(
                              controller: _contatoController,
                              maxLength: 150,
                              style: TextStyle(
                                color: widget.azul,
                                fontSize: 16,
                              ),
                              cursorColor: widget.azul,
                              decoration: _inputDecoration(
                                azul: widget.azul,
                                amarelo: widget.amarelo,
                                hint: 'Ex: (11) 99999-0000, e-mail, etc.',
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _LabeledField(
                                  label: 'Código',
                                  azul: widget.azul,
                                  laranja: widget.laranja,
                                  child: TextFormField(
                                    controller: _codigoController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    maxLength: 4,
                                    style: TextStyle(
                                      color: widget.azul,
                                      fontSize: 16,
                                    ),
                                    cursorColor: widget.azul,
                                    decoration: _inputDecoration(
                                      azul: widget.azul,
                                      amarelo: widget.amarelo,
                                      hint: '0000',
                                    ),
                                    validator: (value) {
                                      final v = (value ?? '').trim();
                                      if (v.isEmpty) return 'Informe';
                                      if (v.length != 4) return '4 dígitos';
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _LabeledField(
                                  label: 'Partição',
                                  azul: widget.azul,
                                  laranja: widget.laranja,
                                  child: TextFormField(
                                    controller: _particaoController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    maxLength: 2,
                                    style: TextStyle(
                                      color: widget.azul,
                                      fontSize: 16,
                                    ),
                                    cursorColor: widget.azul,
                                    decoration: _inputDecoration(
                                      azul: widget.azul,
                                      amarelo: widget.amarelo,
                                      hint: '00',
                                    ),
                                    validator: (value) {
                                      final v = (value ?? '').trim();
                                      if (v.isEmpty) return 'Informe';
                                      if (v.length != 2) return '2 dígitos';
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _LabeledField(
                            label: 'Senha',
                            azul: widget.azul,
                            laranja: widget.laranja,
                            child: TextFormField(
                              controller: _senhaController,
                              obscureText: !_senhaVisivel,
                              maxLength: 32,
                              style: TextStyle(
                                color: widget.azul,
                                fontSize: 16,
                              ),
                              cursorColor: widget.azul,
                              decoration:
                                  _inputDecoration(
                                    azul: widget.azul,
                                    amarelo: widget.amarelo,
                                    hint: 'Digite a senha',
                                  ).copyWith(
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(
                                        () => _senhaVisivel = !_senhaVisivel,
                                      ),
                                      icon: Icon(
                                        _senhaVisivel
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: widget.azul,
                                      ),
                                    ),
                                  ),
                              validator: (value) => (value ?? '').isEmpty
                                  ? 'Informe a senha'
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _StatusSwitch(
                            ativo: _ativo,
                            azul: widget.azul,
                            amarelo: widget.amarelo,
                            onChanged: (value) =>
                                setState(() => _ativo = value),
                          ),
                          const SizedBox(height: 22),
                          _GradientAnimatedButton(
                            onPressed: _save,
                            label: 'Salvar Alterações',
                            azul: widget.azul,
                            amarelo: widget.amarelo,
                          ),
                          const SizedBox(height: 14),
                          TextButton(
                            onPressed: () async {
                              final canLeave = await _confirmDiscardIfNeeded();
                              if (!canLeave || !mounted) return;
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Voltar sem salvar',
                              style: TextStyle(
                                color: widget.azul,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration({
  required Color azul,
  required Color amarelo,
  required String hint,
}) {
  return InputDecoration(
    hintText: hint,
    counterText: '',
    hintStyle: TextStyle(color: azul.withOpacity(0.9)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: amarelo, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: amarelo, width: 2.2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}

class _FadeAndSlideTransition extends StatefulWidget {
  final Widget child;

  const _FadeAndSlideTransition({required this.child});

  @override
  State<_FadeAndSlideTransition> createState() =>
      _FadeAndSlideTransitionState();
}

class _FadeAndSlideTransitionState extends State<_FadeAndSlideTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

enum _ClienteTipo { pf, pj }

@immutable
class _Cliente {
  final String id;
  final _ClienteTipo tipo;
  final String documento;
  final String nome;
  final String especificacaoLocal;
  final String especificacaoPessoa;
  final String contato;
  final String codigo;
  final String particao;
  final String senha;
  final bool ativo;
  final DateTime criadoEm;
  final String criadoPor;
  final DateTime? atualizadoEm;
  final String? atualizadoPor;

  const _Cliente({
    required this.id,
    required this.tipo,
    required this.documento,
    required this.nome,
    required this.especificacaoLocal,
    required this.especificacaoPessoa,
    required this.contato,
    required this.codigo,
    required this.particao,
    required this.senha,
    required this.ativo,
    required this.criadoEm,
    required this.criadoPor,
    required this.atualizadoEm,
    required this.atualizadoPor,
  });

  _Cliente copyWith({
    String? id,
    _ClienteTipo? tipo,
    String? documento,
    String? nome,
    String? especificacaoLocal,
    String? especificacaoPessoa,
    String? contato,
    String? codigo,
    String? particao,
    String? senha,
    bool? ativo,
    DateTime? criadoEm,
    String? criadoPor,
    DateTime? atualizadoEm,
    String? atualizadoPor,
  }) {
    return _Cliente(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      documento: documento ?? this.documento,
      nome: nome ?? this.nome,
      especificacaoLocal: especificacaoLocal ?? this.especificacaoLocal,
      especificacaoPessoa: especificacaoPessoa ?? this.especificacaoPessoa,
      contato: contato ?? this.contato,
      codigo: codigo ?? this.codigo,
      particao: particao ?? this.particao,
      senha: senha ?? this.senha,
      ativo: ativo ?? this.ativo,
      criadoEm: criadoEm ?? this.criadoEm,
      criadoPor: criadoPor ?? this.criadoPor,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      atualizadoPor: atualizadoPor ?? this.atualizadoPor,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _Cliente &&
        id == other.id &&
        tipo == other.tipo &&
        documento == other.documento &&
        nome == other.nome &&
        especificacaoLocal == other.especificacaoLocal &&
        especificacaoPessoa == other.especificacaoPessoa &&
        contato == other.contato &&
        codigo == other.codigo &&
        particao == other.particao &&
        senha == other.senha &&
        ativo == other.ativo &&
        criadoEm == other.criadoEm &&
        criadoPor == other.criadoPor &&
        atualizadoEm == other.atualizadoEm &&
        atualizadoPor == other.atualizadoPor;
  }

  @override
  int get hashCode => Object.hash(
    id,
    tipo,
    documento,
    nome,
    especificacaoLocal,
    especificacaoPessoa,
    contato,
    codigo,
    particao,
    senha,
    ativo,
    criadoEm,
    criadoPor,
    atualizadoEm,
    atualizadoPor,
  );
}

abstract class _ClientesRepository {
  List<_Cliente> list();
  void upsert(_Cliente cliente);
}

class _InMemoryClientesRepository implements _ClientesRepository {
  void remover(String id) {
    _items.removeWhere((c) => c.id == id);
  }

  final List<_Cliente> _items = [];

  void seed() {
    if (_items.isNotEmpty) return;
    _items.addAll([
      _Cliente(
        id: '1',
        tipo: _ClienteTipo.pf,
        documento: '123.456.789-00',
        nome: 'Lizandra Oliveira de Freitas',
        especificacaoLocal: 'Residencial',
        especificacaoPessoa: 'Apt 101',
        contato: 'Contato: (11) 99999-0000',
        codigo: '1234',
        particao: '01',
        senha: '1234',
        ativo: true,
        criadoEm: DateTime(2025, 1, 10, 10, 30),
        criadoPor: 'ADM (mock)',
        atualizadoEm: null,
        atualizadoPor: null,
      ),
      _Cliente(
        id: '2',
        tipo: _ClienteTipo.pj,
        documento: '98.765.432/0001-99',
        nome: 'Empresa Logística LTDA',
        especificacaoLocal: 'Comercial',
        especificacaoPessoa: 'Filial Centro',
        contato: 'Resp: João Silva',
        codigo: '5678',
        particao: '02',
        senha: '1234',
        ativo: true,
        criadoEm: DateTime(2025, 2, 2, 14, 10),
        criadoPor: 'ADM (mock)',
        atualizadoEm: null,
        atualizadoPor: null,
      ),
      _Cliente(
        id: '3',
        tipo: _ClienteTipo.pf,
        documento: '987.654.321-00',
        nome: 'Carlos Henrique Almeida',
        especificacaoLocal: 'Residencial',
        especificacaoPessoa: 'Casa 12',
        contato: 'Contato: (11) 98888-2222',
        codigo: '4321',
        particao: '03',
        senha: '1234',
        ativo: false,
        criadoEm: DateTime(2025, 3, 5, 9, 0),
        criadoPor: 'ADM (mock)',
        atualizadoEm: DateTime(2025, 12, 10, 11, 40),
        atualizadoPor: 'ADM (mock)',
      ),
    ]);
  }

  @override
  List<_Cliente> list() => List.unmodifiable(_items);

  @override
  void upsert(_Cliente cliente) {
    final index = _items.indexWhere((c) => c.id == cliente.id);
    if (index == -1) {
      _items.add(cliente);
      return;
    }
    _items[index] = cliente;
  }
}

class _HeaderSection extends StatelessWidget {
  final Color azul;
  final Color amarelo;
  final int total;
  final int exibindo;

  const _HeaderSection({
    required this.azul,
    required this.amarelo,
    required this.total,
    required this.exibindo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Clientes cadastrados',
          style: TextStyle(
            color: azul,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Container(
          width: 70,
          height: 3,
          decoration: BoxDecoration(
            color: amarelo,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Exibindo $exibindo de $total',
          style: TextStyle(
            color: azul.withOpacity(0.7),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Color azul;
  final Color amarelo;

  const _SearchBar({
    required this.controller,
    required this.azul,
    required this.amarelo,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: azul, fontWeight: FontWeight.w700),
      cursorColor: azul,
      decoration: InputDecoration(
        hintText: 'Buscar por nome, documento, código ou partição',
        hintStyle: TextStyle(
          color: azul.withOpacity(0.7),
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(Icons.search_rounded, color: azul),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: amarelo, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: amarelo, width: 2.2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Color azul;

  const _EmptyState({required this.azul});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            color: azul.withOpacity(0.6),
            size: 42,
          ),
          const SizedBox(height: 10),
          Text(
            'Nenhum cliente encontrado',
            style: TextStyle(
              color: azul,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Ajuste o termo de busca e tente novamente.',
            style: TextStyle(
              color: azul.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ClienteCard extends StatelessWidget {
  final _Cliente cliente;
  final Color azul;
  final Color amarelo;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  const _ClienteCard({
    required this.cliente,
    required this.azul,
    required this.amarelo,
    required this.onEditar,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    final tipoLabel = cliente.tipo == _ClienteTipo.pf ? 'PF' : 'PJ';
    final docLabel = cliente.tipo == _ClienteTipo.pf ? 'CPF' : 'CNPJ';

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: amarelo, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: azul, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: cliente.nome,
                          style: TextStyle(
                            color: azul,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const WidgetSpan(child: SizedBox(width: 6)),
                        TextSpan(
                          text: '($tipoLabel)',
                          style: TextStyle(
                            color: azul,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _StatusPill(ativo: cliente.ativo, azul: azul, amarelo: amarelo),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              '$docLabel: ${cliente.documento}',
              style: const TextStyle(
                color: Color(0xFF444444),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _info('Partição', cliente.particao)),
                Expanded(
                  child: _info(
                    'Especificação da Pessoa',
                    cliente.especificacaoPessoa,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _info('Especificação do Local', cliente.especificacaoLocal),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: FilledButton.icon(
                    onPressed: onEditar,
                    style: FilledButton.styleFrom(
                      backgroundColor: amarelo,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: Icon(Icons.edit_rounded, color: azul, size: 18),
                    label: Text(
                      'Editar',
                      style: TextStyle(
                        color: azul,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 4,
                  child: FilledButton.icon(
                    onPressed: () => _confirmarExclusao(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(
                      Icons.delete_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: const Text(
                      'Excluir',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF222222),
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isEmpty ? '-' : value,
          style: const TextStyle(color: Color(0xFF444444), fontSize: 14),
        ),
      ],
    );
  }

  void _confirmarExclusao(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Excluir conta',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        content: const Text(
          'Você tem certeza que deseja excluir esta conta permanentemente do sistema?\n\n'
          'Essa ação não poderá ser desfeita, porém a conta poderá ser criada novamente pela tela de Adicionar Conta.',
          style: TextStyle(fontSize: 15),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              onExcluir();
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text(
              'Excluir conta',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool ativo;
  final Color azul;
  final Color amarelo;

  const _StatusPill({
    required this.ativo,
    required this.azul,
    required this.amarelo,
  });

  @override
  Widget build(BuildContext context) {
    final bg = ativo
        ? const Color(0xFF10B981).withOpacity(0.14)
        : const Color(0xFFEF4444).withOpacity(0.12);
    final fg = ativo ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final text = ativo ? 'Ativo' : 'Inativo';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: amarelo.withOpacity(0.7), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color azul;
  final Color amarelo;

  const _SectionTitle({
    required this.title,
    required this.azul,
    required this.amarelo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: azul,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Container(
          width: 64,
          height: 3,
          decoration: BoxDecoration(
            color: amarelo,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }
}

class _TipoPessoaSelector extends StatelessWidget {
  final _ClienteTipo tipo;
  final Color azul;
  final Color laranja;
  final ValueChanged<_ClienteTipo> onChanged;

  const _TipoPessoaSelector({
    required this.tipo,
    required this.azul,
    required this.laranja,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SegmentButton(
            selected: tipo == _ClienteTipo.pf,
            label: 'Pessoa Física (PF)',
            azul: azul,
            laranja: laranja,
            onTap: () => onChanged(_ClienteTipo.pf),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SegmentButton(
            selected: tipo == _ClienteTipo.pj,
            label: 'Pessoa Jurídica (PJ)',
            azul: azul,
            laranja: laranja,
            onTap: () => onChanged(_ClienteTipo.pj),
          ),
        ),
      ],
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final bool selected;
  final String label;
  final Color azul;
  final Color laranja;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.selected,
    required this.label,
    required this.azul,
    required this.laranja,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected ? laranja.withOpacity(0.16) : Colors.white,
          border: Border.all(
            color: selected ? laranja : laranja.withOpacity(0.45),
            width: selected ? 1.6 : 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: laranja,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Color azul;
  final Color laranja;
  final Widget child;

  const _LabeledField({
    required this.label,
    required this.azul,
    required this.laranja,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: laranja,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _StatusSwitch extends StatelessWidget {
  final bool ativo;
  final Color azul;
  final Color amarelo;
  final ValueChanged<bool> onChanged;

  const _StatusSwitch({
    required this.ativo,
    required this.azul,
    required this.amarelo,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: amarelo, width: 2),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(Icons.verified_user_rounded, color: azul),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Status do cliente',
              style: TextStyle(color: azul, fontWeight: FontWeight.w800),
            ),
          ),
          Switch(
            value: ativo,
            onChanged: onChanged,
            activeColor: const Color(0xFF10B981),
            inactiveThumbColor: const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }
}

class _ClienteSummaryCard extends StatelessWidget {
  final _Cliente cliente;
  final Color azul;
  final Color amarelo;
  final Color laranja;

  const _ClienteSummaryCard({
    required this.cliente,
    required this.azul,
    required this.amarelo,
    required this.laranja,
  });

  @override
  Widget build(BuildContext context) {
    final tipoLabel = cliente.tipo == _ClienteTipo.pf ? 'PF' : 'PJ';
    final docLabel = cliente.tipo == _ClienteTipo.pf ? 'CPF' : 'CNPJ';

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: amarelo, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 18,
          right: 14,
          top: 14,
          bottom: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Icon(Icons.badge_rounded, color: azul, size: 30),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: cliente.nome,
                          style: TextStyle(
                            color: azul,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const WidgetSpan(child: SizedBox(width: 6)),
                        TextSpan(
                          text: '($tipoLabel)',
                          style: TextStyle(
                            color: azul,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _StatusPill(ativo: cliente.ativo, azul: azul, amarelo: amarelo),
              ],
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$docLabel: ',
                    style: const TextStyle(
                      color: Color(0xFF222222),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: cliente.documento,
                    style: const TextStyle(
                      color: Color(0xFF444444),
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _meta('Criado por', cliente.criadoPor)),
                const SizedBox(width: 12),
                Expanded(
                  child: _meta('Criado em', _formatDate(cliente.criadoEm)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _meta('Atualizado por', cliente.atualizadoPor ?? '-'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _meta(
                    'Atualizado em',
                    cliente.atualizadoEm == null
                        ? '-'
                        : _formatDate(cliente.atualizadoEm!),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _meta(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: laranja,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF444444),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final yyyy = dt.year.toString();
    final hh = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$dd/$mm/$yyyy • $hh:$min';
  }
}

class _GradientAnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final Color azul;
  final Color amarelo;

  const _GradientAnimatedButton({
    required this.onPressed,
    required this.label,
    required this.azul,
    required this.amarelo,
  });

  @override
  State<_GradientAnimatedButton> createState() =>
      _GradientAnimatedButtonState();
}

class _GradientAnimatedButtonState extends State<_GradientAnimatedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) => _controller.forward();
  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [widget.amarelo, const Color(0xFFFFB300)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: widget.azul.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              splashColor: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
