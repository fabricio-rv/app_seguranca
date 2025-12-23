// lib/pages/adm/adicionar_cliente.dart
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter/services.dart';
// import '../../widgets/bottom_navbar_geral.dart'; // unused import removed

class _FadeAndSlideTransition extends StatefulWidget {
  final Widget child;

  const _FadeAndSlideTransition({required this.child});

  @override
  State<_FadeAndSlideTransition> createState() =>
      _FadeAndSlideTransitionState();
}

class _FadeAndSlideTransitionState extends State<_FadeAndSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
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
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}

class AdicionarAdmPage extends StatefulWidget {
  @override
  _AdicionarAdmPageState createState() => _AdicionarAdmPageState();
}

class _AdicionarAdmPageState extends State<AdicionarAdmPage> {
  String tipoDoc = "CPF";
  String tipoPessoa = "PF";

  final TextEditingController docController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController especificacao1Controller =
      TextEditingController();
  final TextEditingController especificacao2Controller =
      TextEditingController();
  final TextEditingController especificacao3Controller =
      TextEditingController();
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController particaoController = TextEditingController();
  final TextEditingController senhaController = TextEditingController(
    text: "1234",
  );
  bool senhaVisivel = false;

  List<Map<String, String>> contas = [
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
        const SnackBar(
          content: Text("Preencha todos os campos"),
          backgroundColor: Colors.red,
        ),
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
      const SnackBar(
        content: Text("Conta criada com sucesso!"),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF181883);
    final laranja = const Color(0xFFFF9900);
    final amarelo = const Color(0xFFFFD700);

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
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home_adm'),
                  splashRadius: 24,
                ),
              ),
            ),
            // 🔥 Linha amarela deslocada corretamente abaixo do azul (com brilho sutil)
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(-2, 0),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Cadastro de Conta",
                            style: TextStyle(
                              color: azul,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: 60,
                            height: 3,
                            decoration: BoxDecoration(
                              color: amarelo,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownButton<String>(
                          value: tipoDoc,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: "CPF", child: Text("CPF")),
                            DropdownMenuItem(
                              value: "CNPJ",
                              child: Text("CNPJ"),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                tipoDoc = value;
                                docController.clear();
                              });
                            }
                          },
                          style: TextStyle(
                            color: laranja,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          icon: Icon(Icons.arrow_drop_down, color: laranja),
                          dropdownColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 1),
                      _buildInput(
                        docController,
                        hint: tipoDoc == "CPF"
                            ? "000.000.000-00"
                            : "00.000.000/0000-00",
                        azul: azul,
                        laranja: laranja,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          tipoDoc == 'CPF'
                              ? MaskedInputFormatter('###.###.###-##')
                              : MaskedInputFormatter('##.###.###/####-##'),
                        ],
                        maxLength: tipoDoc == 'CPF' ? 14 : 18,
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownButton<String>(
                          value: tipoPessoa,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(
                              value: "PF",
                              child: Text("Pessoa Física (PF)"),
                            ),
                            DropdownMenuItem(
                              value: "PJ",
                              child: Text("Pessoa Jurídica (PJ)"),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                tipoPessoa = value;
                              });
                            }
                          },
                          style: TextStyle(
                            color: laranja,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          icon: Icon(Icons.arrow_drop_down, color: laranja),
                          dropdownColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 1),
                      _buildInput(
                        nomeController,
                        hint: tipoPessoa == "PF"
                            ? "Digite o Nome Completo"
                            : "Digite a Razão Social",
                        azul: azul,
                        laranja: laranja,
                        maxLength: 150,
                      ),
                      const SizedBox(height: 18),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Especificação da Pessoa",
                          style: TextStyle(
                            color: laranja,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildInput(
                        especificacao2Controller,
                        hint: "Digite aqui",
                        azul: azul,
                        laranja: laranja,
                        maxLength: 150,
                      ),
                      const SizedBox(height: 18),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Especificação do Local",
                          style: TextStyle(
                            color: laranja,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildInput(
                        especificacao1Controller,
                        hint: "Digite aqui",
                        azul: azul,
                        laranja: laranja,
                        maxLength: 150,
                      ),
                      const SizedBox(height: 18),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Código",
                          style: TextStyle(
                            color: laranja,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildInput(
                        codigoController,
                        hint: "Digite o Código",
                        azul: azul,
                        laranja: laranja,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        maxLength: 4,
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Partição",
                          style: TextStyle(
                            color: laranja,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildInput(
                        particaoController,
                        hint: "Digite a Partição",
                        azul: azul,
                        laranja: laranja,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        maxLength: 2,
                      ),
                      const SizedBox(height: 18),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Senha (padrão 1234)",
                          style: TextStyle(
                            color: laranja,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: senhaController,
                        obscureText: !senhaVisivel,
                        readOnly: true,
                        style: TextStyle(color: azul, fontSize: 16),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              senhaVisivel
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: azul,
                            ),
                            onPressed: () {
                              setState(() {
                                senhaVisivel = !senhaVisivel;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFFFD700),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFFFD700),
                              width: 2.2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      _GradientAnimatedButton(
                        onPressed: _salvarConta,
                        label: "Cadastrar Conta",
                        azul: azul,
                        amarelo: amarelo,
                      ),
                      const SizedBox(height: 36),
                      Container(height: 1, color: const Color(0xFFFFE066)),
                      const SizedBox(height: 16),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shield, color: azul, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              "Contas já cadastradas",
                              style: TextStyle(
                                color: azul,
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      ...contas.map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: 16.0,
                          ), // 🔥 espaçamento entre os cards
                          child: Card(
                            elevation: 2,
                            shadowColor: Colors.black.withOpacity(0.08),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                color: Color(0xFFFFD700),
                                width: 1.2,
                              ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 14.0,
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color: azul,
                                          size: 30,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: c["nome"] ?? "-",
                                                    style: const TextStyle(
                                                      color: Color(0xFF0033A0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                      letterSpacing: 0.3,
                                                    ),
                                                  ),
                                                  const WidgetSpan(
                                                    child: SizedBox(width: 5),
                                                  ),
                                                  TextSpan(
                                                    text: "(${c["tipo"]})",
                                                    style: const TextStyle(
                                                      color: Color(0xFF0033A0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              softWrap: true,
                                            ),
                                            const SizedBox(height: 10),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: c["tipo"] == "PF"
                                                        ? "CPF: "
                                                        : "CNPJ: ",
                                                    style: const TextStyle(
                                                      color: Color(0xFF222222),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: c["doc"] ?? "-",
                                                    style: const TextStyle(
                                                      color: Color(0xFF444444),
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 40,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Partição:",
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFF222222,
                                                    ),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    c["particao"] ?? "-",
                                                    style: const TextStyle(
                                                      color: Color(0xFF444444),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Text(
                                                  "Código:",
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFF222222,
                                                    ),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  c["codigo"] ?? "-",
                                                  style: const TextStyle(
                                                    color: Color(0xFF444444),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 18),
                                            Row(
                                              children: [
                                                Text(
                                                  "Senha:",
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFF222222,
                                                    ),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "Padrão",
                                                  style: const TextStyle(
                                                    color: Color(0xFF444444),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Flexible(
                                        flex: 60,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Especificação da Pessoa:",
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFF222222,
                                                    ),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  c["esp2"] ?? "-",
                                                  style: const TextStyle(
                                                    color: Color(0xFF444444),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Especificação do Local:",
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFF222222,
                                                    ),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  c["esp1"] ?? "-",
                                                  style: const TextStyle(
                                                    color: Color(0xFF444444),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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

  Widget _buildInput(
    TextEditingController controller, {
    required String hint,
    required Color azul,
    required Color laranja,
    Key? fieldKey,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return TextField(
      key: fieldKey,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      style: TextStyle(color: azul, fontSize: 16),
      cursorColor: azul,
      decoration: InputDecoration(
        hintText: hint,
        counterText: maxLength != null ? '' : null,
        hintStyle: TextStyle(color: azul),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFFD700), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFFD700), width: 2.2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
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
  State<_GradientAnimatedButton> createState() =>
      _GradientAnimatedButtonState();
}

class _GradientAnimatedButtonState extends State<_GradientAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

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

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

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
              onTap: () {},
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
                      color: Colors.white, // 🔁 branco em vez de azul
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
