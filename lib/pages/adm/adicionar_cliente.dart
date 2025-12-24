import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class AdicionarAdmPage extends StatefulWidget {
  const AdicionarAdmPage({Key? key}) : super(key: key);

  @override
  State<AdicionarAdmPage> createState() => _AdicionarAdmPageState();
}

class _AdicionarAdmPageState extends State<AdicionarAdmPage>
    with SingleTickerProviderStateMixin {
  final Color azul = const Color(0xFF181883);
  final Color amarelo = const Color(0xFFFFD700);
  final Color laranja = const Color(0xFFFF9900);
  final Color fundoClaro = const Color(0xFFFFFDF0);
  final Color cinza = const Color(0xFF6B7280);

  String tipoDoc = "CPF";
  String tipoPessoa = "PF";

  final TextEditingController docController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController especificacao1Controller =
      TextEditingController(); // Local
  final TextEditingController especificacao2Controller =
      TextEditingController(); // Pessoa
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController particaoController = TextEditingController();
  final TextEditingController senhaController = TextEditingController(
    text: "1234",
  );

  bool senhaVisivel = false;

  // Animações
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

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

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    docController.dispose();
    nomeController.dispose();
    especificacao1Controller.dispose();
    especificacao2Controller.dispose();
    codigoController.dispose();
    particaoController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  // --- MODAL PREMIUM ---
  void _mostrarDialogoConfirmacao({
    required String titulo,
    required String mensagem,
    required VoidCallback onConfirmar,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: azul.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_add_rounded, size: 32, color: azul),
                ),
                const SizedBox(height: 20),
                Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: azul,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  mensagem,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: cinza, height: 1.4),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: amarelo,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirmar();
                        },
                        child: Text(
                          'Confirmar',
                          style: TextStyle(
                            color: azul,
                            fontWeight: FontWeight.bold,
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
      },
    );
  }

  void _salvarConta() {
    if (docController.text.isEmpty || nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha os campos obrigatórios"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Chama o modal antes de salvar
    _mostrarDialogoConfirmacao(
      titulo: 'Cadastrar Conta',
      mensagem: 'Confirma o cadastro deste novo cliente no sistema?',
      onConfirmar: () {
        setState(() {
          contas.add({
            "doc": docController.text,
            "nome": nomeController.text,
            "esp1": especificacao1Controller.text,
            "esp2": especificacao2Controller.text,
            "esp3": "Novo Cliente", // Placeholder
            "codigo": codigoController.text,
            "particao": particaoController.text,
            "tipo": tipoPessoa,
          });
        });

        docController.clear();
        nomeController.clear();
        especificacao1Controller.clear();
        especificacao2Controller.clear();
        codigoController.clear();
        particaoController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Conta criada com sucesso!"),
            backgroundColor: Color(0xFF10B981), // Verde
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
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
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [amarelo, amarelo.withOpacity(0.6), amarelo],
                ),
              ),
            ),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFFFFDF0)],
              ),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _header(),
                        const SizedBox(height: 32),

                        // ===== SEÇÃO: IDENTIFICAÇÃO =====
                        _buildSectionTitle(
                          'Identificação',
                          Icons.badge_rounded,
                        ),
                        const SizedBox(height: 16),

                        // Dropdown Tipo Doc
                        _buildPremiumDropdown(
                          value: tipoDoc,
                          items: ["CPF", "CNPJ"],
                          onChanged: (v) {
                            if (v != null)
                              setState(() {
                                tipoDoc = v;
                                docController.clear();
                              });
                          },
                        ),
                        const SizedBox(height: 12),

                        // Campo Documento
                        _buildPremiumInput(
                          controller: docController,
                          hint: tipoDoc == "CPF"
                              ? "000.000.000-00"
                              : "00.000.000/0000-00",
                          icon: Icons.assignment_ind_rounded,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            tipoDoc == 'CPF'
                                ? MaskedInputFormatter('###.###.###-##')
                                : MaskedInputFormatter('##.###.###/####-##'),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Dropdown Tipo Pessoa
                        _buildPremiumDropdown(
                          value: tipoPessoa,
                          items: [
                            "PF",
                            "PJ",
                          ], // Simplificado para visualização, pode mapear nomes completos se quiser
                          onChanged: (v) {
                            if (v != null) setState(() => tipoPessoa = v);
                          },
                        ),
                        const SizedBox(height: 12),

                        // Campo Nome
                        _buildPremiumInput(
                          controller: nomeController,
                          hint: tipoPessoa == "PF"
                              ? "Nome completo"
                              : "Razão social",
                          icon: Icons.person_outline_rounded,
                        ),

                        const SizedBox(height: 32),

                        // ===== SEÇÃO: DETALHES =====
                        _buildSectionTitle(
                          'Detalhes',
                          Icons.location_on_rounded,
                        ),
                        const SizedBox(height: 16),
                        _buildPremiumInput(
                          controller: especificacao2Controller,
                          hint: "Especificação da pessoa (Ex: Apt 101)",
                          icon: Icons.person_pin_circle_outlined,
                        ),
                        const SizedBox(height: 12),
                        _buildPremiumInput(
                          controller: especificacao1Controller,
                          hint: "Especificação do local (Ex: Residencial)",
                          icon: Icons.home_work_outlined,
                        ),

                        const SizedBox(height: 32),

                        // ===== SEÇÃO: ACESSO =====
                        _buildSectionTitle('Acesso', Icons.lock_rounded),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildPremiumInput(
                                controller: codigoController,
                                hint: "Código",
                                icon: Icons.vpn_key_outlined,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildPremiumInput(
                                controller: particaoController,
                                hint: "Partição",
                                icon: Icons.dashboard_outlined,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildPremiumInput(
                          controller: senhaController,
                          hint: "Senha",
                          icon: Icons.password_rounded,
                          readOnly: true,
                          isPassword: !senhaVisivel,
                          onTogglePassword: () =>
                              setState(() => senhaVisivel = !senhaVisivel),
                        ),

                        const SizedBox(height: 40),

                        // BOTÃO CADASTRAR (Estilo mantido conforme pedido)
                        _GradientAnimatedButton(
                          onPressed: _salvarConta,
                          label: "Cadastrar Conta",
                          azul: azul,
                          amarelo: amarelo,
                        ),

                        const SizedBox(height: 48),

                        // --- ÁREA INTOCADA (CONFORME PEDIDO) ---
                        Container(height: 1, color: const Color(0xFFFFE066)),
                        const SizedBox(height: 28),
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
                        const SizedBox(height: 28),
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
      ),
    );
  }

  // ===== WIDGETS AUXILIARES (MODERNIZADOS) =====

  Widget _header() {
    return Center(
      child: Column(
        children: [
          Text(
            "Adicionar nova conta",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: azul,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Cadastre um novo cliente no sistema",
            textAlign: TextAlign.center,
            style: TextStyle(color: azul.withOpacity(0.65)),
          ),
          const SizedBox(height: 14),
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
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: laranja, size: 22),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: azul,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Input Moderno (Igual ao Perfil)
  Widget _buildPremiumInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    bool isPassword = false,
    VoidCallback? onTogglePassword,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: azul.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        readOnly: readOnly,
        obscureText: isPassword,
        style: TextStyle(
          color: azul,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: Icon(icon, color: Colors.grey[400]),
          suffixIcon: onTogglePassword != null
              ? IconButton(
                  icon: Icon(
                    isPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: azul,
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFF3F4F6), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: laranja, width: 1.5),
          ),
        ),
      ),
    );
  }

  // Dropdown Moderno
  Widget _buildPremiumDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: azul.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(Icons.arrow_drop_down_circle_outlined, color: azul),
          style: TextStyle(
            color: azul,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          isExpanded: true,
          items: items.map((String val) {
            return DropdownMenuItem<String>(value: val, child: Text(val));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // --- WIDGETS ANTIGOS PRESERVADOS (APENAS O NECESSÁRIO) ---

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
                    padding: const EdgeInsets.only(right: 14.0),
                    child: Icon(Icons.person, color: azul, size: 30),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: c["nome"] ?? "-",
                                style: const TextStyle(
                                  color: Color(0xFF0033A0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const WidgetSpan(child: SizedBox(width: 5)),
                              TextSpan(
                                text: "(${c["tipo"]})",
                                style: const TextStyle(
                                  color: Color(0xFF0033A0),
                                  fontWeight: FontWeight.bold,
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
                                text: c["tipo"] == "PF" ? "CPF: " : "CNPJ: ",
                                style: const TextStyle(
                                  color: Color(0xFF222222),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: c["doc"] ?? "-",
                                style: const TextStyle(
                                  color: Color(0xFF444444),
                                  fontWeight: FontWeight.normal,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Partição:",
                              style: TextStyle(
                                color: const Color(0xFF222222),
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
                                color: const Color(0xFF222222),
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
                                color: const Color(0xFF222222),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Padrão",
                              style: TextStyle(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Especificação da Pessoa:",
                              style: TextStyle(
                                color: const Color(0xFF222222),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Especificação do Local:",
                              style: TextStyle(
                                color: const Color(0xFF222222),
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
    );
  }
}

// Botão com Animação e Gradiente (Preservado e integrado)
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
          margin: const EdgeInsets.only(top: 8),
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
