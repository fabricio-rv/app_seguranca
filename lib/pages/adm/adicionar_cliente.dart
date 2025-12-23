// lib/pages/adm/adicionar_cliente.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class _FadeAndSlideTransition extends StatefulWidget {
  final Widget child;
  const _FadeAndSlideTransition({required this.child});
  @override
  State<_FadeAndSlideTransition> createState() => _FadeAndSlideTransitionState();
}

class _FadeAndSlideTransitionState extends State<_FadeAndSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fadeAnimation, child: SlideTransition(position: _slideAnimation, child: widget.child));
  }
}

class AdicionarAdmPage extends StatefulWidget {
  const AdicionarAdmPage({Key? key}) : super(key: key);
  @override
  State<AdicionarAdmPage> createState() => _AdicionarAdmPageState();
}

class _AdicionarAdmPageState extends State<AdicionarAdmPage> {
  final Color azul = const Color(0xFF181883);
  final Color amarelo = const Color(0xFFFFD700);
  final Color laranja = const Color(0xFFFF9900);
  final Color fundoClaro = const Color(0xFFFFFDF0);

  String tipoDoc = "CPF";
  String tipoPessoa = "PF";

  final TextEditingController docController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController especificacao1Controller = TextEditingController(); // Local
  final TextEditingController especificacao2Controller = TextEditingController(); // Pessoa
  final TextEditingController especificacao3Controller = TextEditingController();
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController particaoController = TextEditingController();
  final TextEditingController senhaController = TextEditingController(text: "1234");

  bool senhaVisivel = false;

  final List<Map<String, String>> contas = [
    {
      "doc": "123.456.789-00",
      "nome": "Lizandra Oliveira de Freitas",
      "esp1": "Residencial",
      "esp2": "Apt 101",
      "esp3": "Contato: (11) 99999-0000",
      "tipo": "PF",
      "codigo": "1234",
      "particao": "01",
    },
    {
      "doc": "98.765.432/0001-99",
      "nome": "Empresa Logística LTDA",
      "esp1": "Comercial",
      "esp2": "Filial Centro",
      "esp3": "Resp: João Silva",
      "tipo": "PJ",
      "codigo": "5678",
      "particao": "02",
    },
  ];

  void _salvarConta() {
    if (docController.text.isEmpty || nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha os campos obrigatórios"), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() {
      contas.add({
        "doc": docController.text,
        "nome": nomeController.text,
        "esp1": especificacao1Controller.text,
        "esp2": especificacao2Controller.text,
        "esp3": especificacao3Controller.text,
        "codigo": codigoController.text,
        "particao": particaoController.text,
        "tipo": tipoPessoa,
      });
    });
    docController.clear();
    nomeController.clear();
    especificacao1Controller.clear();
    especificacao2Controller.clear();
    especificacao3Controller.clear();
    codigoController.clear();
    particaoController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Conta criada com sucesso!"), backgroundColor: Colors.orange),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundoClaro,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Column(
          children: [
            AppBar(
              backgroundColor: azul,
              elevation: 0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Container(
              height: 2,
              decoration: BoxDecoration(gradient: LinearGradient(colors: [amarelo, amarelo.withOpacity(0.6), amarelo])),
            ),
          ],
        ),
      ),
      body: _FadeAndSlideTransition(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white, Color(0xFFFFFDF0)]),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header(),
                      const SizedBox(height: 28),

                      // ===== IDENTIFICAÇÃO — spacing reduzido =====
                      _section(
                        title: "Identificação",
                        icon: Icons.badge_rounded,
                        spacing: 6, // ↓ menor espaço entre dropdown e campo
                        children: [
                          _dropdownTipoDoc(), // CPF/CNPJ (azul, fonte maior)
                          _buildInput(
                            docController,
                            hint: tipoDoc == "CPF" ? "000.000.000-00" : "00.000.000/0000-00",
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              tipoDoc == 'CPF'
                                  ? MaskedInputFormatter('###.###.###-##')
                                  : MaskedInputFormatter('##.###.###/####-##'),
                            ],
                          ),
                          _dropdownTipoPessoa(), // PF/PJ (azul, fonte maior)
                          _buildInput(
                            nomeController,
                            hint: tipoPessoa == "PF" ? "Nome completo" : "Razão social",
                          ),
                        ],
                      ),

                      // ===== DETALHES =====
                      _section(
                        title: "Detalhes",
                        icon: Icons.location_on_rounded,
                        children: [
                          _buildInput(especificacao2Controller, hint: "Especificação da pessoa"),
                          _buildInput(especificacao1Controller, hint: "Especificação do local"),
                        ],
                      ),

                      // ===== ACESSO =====
                      _section(
                        title: "Acesso",
                        icon: Icons.lock_rounded,
                        children: [
                          _buildInput(
                            codigoController,
                            hint: "Código",
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                          _buildInput(
                            particaoController,
                            hint: "Partição",
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                          TextField(
                            controller: senhaController,
                            obscureText: !senhaVisivel,
                            readOnly: true,
                            style: TextStyle(color: azul, fontSize: 16),
                            decoration: InputDecoration(
                              hintText: "Senha (padrão 1234)",
                              suffixIcon: IconButton(
                                icon: Icon(senhaVisivel ? Icons.visibility : Icons.visibility_off, color: azul),
                                onPressed: () => setState(() => senhaVisivel = !senhaVisivel),
                              ),
                              enabledBorder: _border(),
                              focusedBorder: _border(),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ],
                      ),

                      // Botão animado
                      _GradientAnimatedButton(onPressed: _salvarConta, label: "Cadastrar Conta", azul: azul, amarelo: amarelo),

                      const SizedBox(height: 48), // ↑ mais distância do botão para a linha amarela

                      // Linha amarela + título
                      Container(height: 1, color: const Color(0xFFFFE066)),
                      const SizedBox(height: 28), // ↑ mais distância linha ➜ título
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shield, color: azul, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              "Contas já cadastradas",
                              style: TextStyle(
                                color: azul,
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                shadows: [Shadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28), // ↑ mais distância título ➜ cards

                      // Cards ricos
                      ...contas.map((c) => _cardContaRico(c)).toList(),
                      const SizedBox(height: 28),
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

  // ===== Helpers =====

  Widget _header() {
    return Center( // centraliza bloco inteiro
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Adicionar nova conta",
            textAlign: TextAlign.center,
            style: TextStyle(color: azul, fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            "Cadastre um novo cliente no sistema",
            textAlign: TextAlign.center,
            style: TextStyle(color: azul.withOpacity(0.65)),
          ),
          const SizedBox(height: 14),
          Container(width: 60, height: 3, decoration: BoxDecoration(color: amarelo, borderRadius: BorderRadius.circular(3))),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required List<Widget> children,
    double spacing = 14, // ← novo: controla o espaçamento interno
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: amarelo.withOpacity(0.18), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: amarelo),
            ),
            const SizedBox(width: 10),
            Text(title, style: TextStyle(color: azul, fontSize: 16, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 18),
          ...children.expand((w) => [w, SizedBox(height: spacing)]).toList()..removeLast(),
        ],
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller, {
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyle(color: azul, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        enabledBorder: _border(),
        focusedBorder: _border(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  OutlineInputBorder _border() =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: amarelo, width: 2));

  // Dropdowns com fonte maior e AZUL
  Widget _dropdownTipoDoc() {
    return DropdownButton<String>(
      value: tipoDoc,
      underline: const SizedBox(),
      items: const [
        DropdownMenuItem(value: "CPF", child: Text("CPF")),
        DropdownMenuItem(value: "CNPJ", child: Text("CNPJ")),
      ],
      onChanged: (v) {
        if (v != null) {
          setState(() {
            tipoDoc = v;
            docController.clear();
          });
        }
      },
      style: TextStyle(color: azul, fontWeight: FontWeight.w800, fontSize: 18),
      icon: Icon(Icons.arrow_drop_down, color: azul),
    );
  }

  Widget _dropdownTipoPessoa() {
    return DropdownButton<String>(
      value: tipoPessoa,
      underline: const SizedBox(),
      items: const [
        DropdownMenuItem(value: "PF", child: Text("Pessoa Física")),
        DropdownMenuItem(value: "PJ", child: Text("Pessoa Jurídica")),
      ],
      onChanged: (v) {
        if (v != null) setState(() => tipoPessoa = v);
      },
      style: TextStyle(color: azul, fontWeight: FontWeight.w800, fontSize: 18),
      icon: Icon(Icons.arrow_drop_down, color: azul),
    );
  }

  // Card rico (inalterado visual principal)
  Widget _cardContaRico(Map<String, String> c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFFFD700), width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 14, top: 14, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Padding(padding: const EdgeInsets.only(right: 14.0), child: Icon(Icons.person, color: azul, size: 30)),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: c["nome"] ?? "-",
                          style: const TextStyle(color: Color(0xFF0033A0), fontWeight: FontWeight.bold, fontSize: 17, letterSpacing: 0.3),
                        ),
                        const WidgetSpan(child: SizedBox(width: 5)),
                        TextSpan(
                          text: "(${c["tipo"]})",
                          style: const TextStyle(color: Color(0xFF0033A0), fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ]),
                      softWrap: true,
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: c["tipo"] == "PF" ? "CPF: " : "CNPJ: ",
                          style: const TextStyle(color: Color(0xFF222222), fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        TextSpan(
                          text: c["doc"] ?? "-",
                          style: const TextStyle(color: Color(0xFF444444), fontWeight: FontWeight.normal, fontSize: 14),
                        ),
                      ]),
                    ),
                  ]),
                ),
              ]),
              const SizedBox(height: 18),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Flexible(
                  flex: 40,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("Partição:", style: TextStyle(color: const Color(0xFF222222), fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(c["particao"] ?? "-", style: const TextStyle(color: Color(0xFF444444), fontSize: 14))),
                    ]),
                    const SizedBox(height: 16),
                    Row(children: [
                      Text("Código:", style: TextStyle(color: const Color(0xFF222222), fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(width: 8),
                      Text(c["codigo"] ?? "-", style: const TextStyle(color: Color(0xFF444444), fontSize: 14)),
                    ]),
                    const SizedBox(height: 18),
                    Row(children: [
                      Text("Senha:", style: TextStyle(color: const Color(0xFF222222), fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(width: 8),
                      const Text("Padrão", style: TextStyle(color: Color(0xFF444444), fontSize: 14)),
                    ]),
                  ]),
                ),
                const SizedBox(width: 12),
                Flexible(
                  flex: 60,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("Especificação da Pessoa:", style: TextStyle(color: const Color(0xFF222222), fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 6),
                      Text(c["esp2"] ?? "-", style: const TextStyle(color: Color(0xFF444444), fontSize: 14)),
                    ]),
                    const SizedBox(height: 10),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("Especificação do Local:", style: TextStyle(color: const Color(0xFF222222), fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 6),
                      Text(c["esp1"] ?? "-", style: const TextStyle(color: Color(0xFF444444), fontSize: 14)),
                    ]),
                  ]),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
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
  State<_GradientAnimatedButton> createState() => _GradientAnimatedButtonState();
}

class _GradientAnimatedButtonState extends State<_GradientAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  void _handleTapDown(TapDownDetails details) => _controller.forward();
  void _handleTapUp(TapUpDetails details) { _controller.reverse(); widget.onPressed(); }
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
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [widget.amarelo, const Color(0xFFFFB300)]),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: widget.azul.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {}, // evita duplo trigger
              splashColor: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    widget.label,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18, letterSpacing: 0.5),
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
