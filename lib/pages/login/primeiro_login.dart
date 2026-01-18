import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class PrimeiroLoginPage extends StatefulWidget {
  final String? doc;
  const PrimeiroLoginPage({Key? key, this.doc}) : super(key: key);

  @override
  State<PrimeiroLoginPage> createState() => _PrimeiroLoginPageState();
}

class _PrimeiroLoginPageState extends State<PrimeiroLoginPage>
    with SingleTickerProviderStateMixin {
  // Cores
  final azul = const Color(0xFF181883);
  final amarelo = const Color(0xFFFFD700);
  final laranja = const Color(0xFFFF9900);
  final cinza = const Color(0xFF6B7280);

  // Controllers
  final docController = TextEditingController();
  final smsController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();
  final emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Estados
  String tipoDoc = 'CPF';
  bool enviouCodigo = false;
  bool codigoValidado = false;
  bool loading = false;
  bool senhaVisivel = false;

  Timer? _timer;
  int tempoRestante = 0;
  final numeroMascara = '(11) 9****-4321';

  // Animações
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  MaskedInputFormatter get _mask => tipoDoc == 'CPF'
      ? MaskedInputFormatter('###.###.###-##')
      : MaskedInputFormatter('##.###.###/####-##');

  int get _maxLength => tipoDoc == 'CPF' ? 14 : 18;
  String get _hint =>
      tipoDoc == 'CPF' ? '000.000.000-00' : '00.000.000/0000-00';

  @override
  void initState() {
    super.initState();
    if (widget.doc != null) docController.text = widget.doc!;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    docController.dispose();
    smsController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    emailController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // --- LÓGICA DE NEGÓCIO (Mantida) ---

  Future<void> _enviarCodigo() async {
    if (docController.text.length != _maxLength) {
      _showPremiumModal(
        icon: Icons.error_outline_rounded,
        title: 'Documento inválido',
        message: 'Por favor, verifique o número do seu documento.',
        button: 'Corrigir',
        isError: true,
      );
      return;
    }

    setState(() {
      loading = true;
      tempoRestante = 60;
      enviouCodigo = true;
    });

    await Future.delayed(const Duration(milliseconds: 1000)); // Delay para UX

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (tempoRestante > 0) {
        if (mounted) setState(() => tempoRestante--);
      } else {
        t.cancel();
      }
    });

    if (mounted) setState(() => loading = false);

    _showPremiumModal(
      icon: Icons.sms_outlined,
      title: 'Código Enviado',
      message: 'Enviamos um SMS para o número cadastrado:\n$numeroMascara',
      button: 'Entendi',
    );
  }

  Future<void> _validarCodigo() async {
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => loading = false);

    if (smsController.text == '1234') {
      setState(() => codigoValidado = true);
      _showPremiumModal(
        icon: Icons.verified_rounded,
        title: 'Verificado!',
        message: 'Código validado com sucesso. Agora crie sua senha de acesso.',
        button: 'Continuar',
      );
    } else {
      _showPremiumModal(
        icon: Icons.error_outline_rounded,
        title: 'Código Inválido',
        message: 'O código informado não confere. Por favor, tente novamente.',
        button: 'Tentar Novamente',
        isError: true,
      );
    }
  }

  Future<void> _finalizar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() => loading = false);

    _showPremiumModal(
      icon: Icons.check_circle_rounded,
      title: 'Cadastro Concluído!',
      message: 'Seu acesso foi configurado com sucesso. Bem-vindo à Protepac!',
      button: 'Acessar App',
      onClose: () => Navigator.pushReplacementNamed(context, '/home'),
    );
  }

  // --- MODAL PREMIUM ---
  void _showPremiumModal({
    required IconData icon,
    required String title,
    required String message,
    required String button,
    bool isError = false,
    VoidCallback? onClose,
  }) {
    final color = isError
        ? const Color(0xFFEF4444)
        : const Color(0xFF10B981); // Vermelho ou Verde

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                  color: isError
                      ? color.withOpacity(0.1)
                      : azul.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: isError ? color : azul),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: azul,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: cinza, height: 1.4, fontSize: 15),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onClose?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: amarelo,
                    foregroundColor: azul,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    button,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFFFFDF0)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Column(
                children: [
                  // App Bar Customizada
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_rounded, color: azul),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Hero(
                                tag: 'logo',
                                child: Image.asset(
                                  'assets/logo.png',
                                  height: 100,
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Card Principal
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: Colors.white),
                                  boxShadow: [
                                    BoxShadow(
                                      color: azul.withOpacity(0.08),
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: !enviouCodigo
                                      ? _StepDocumento()
                                      : codigoValidado
                                      ? _StepSenha()
                                      : _StepSMS(),
                                ),
                              ),

                              const SizedBox(height: 30),

                              // Indicador de Passos (Opcional, mas dá um toque pro)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _StepDot(active: !enviouCodigo),
                                  _StepDot(
                                    active: enviouCodigo && !codigoValidado,
                                  ),
                                  _StepDot(active: codigoValidado),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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

  // --- STEPS WIDGETS ---

  Widget _StepDocumento() {
    return Column(
      key: const ValueKey('step1'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Primeiro Acesso',
          style: TextStyle(
            color: azul,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Informe seu documento para localizarmos seu cadastro.',
          style: TextStyle(color: cinza, fontSize: 14),
        ),
        const SizedBox(height: 24),

        // Toggle Tipo Doc
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _buildToggleButton('CPF', tipoDoc == 'CPF'),
              _buildToggleButton('CNPJ', tipoDoc == 'CNPJ'),
            ],
          ),
        ),

        const SizedBox(height: 20),

        _buildPremiumInput(
          controller: docController,
          hint: _hint,
          icon: Icons.badge_outlined,
          inputType: TextInputType.number,
          formatters: [_mask],
        ),

        const SizedBox(height: 28),
        _PrimaryButton(
          label: 'Enviar Código',
          loading: loading,
          onPressed: _enviarCodigo,
        ),
      ],
    );
  }

  Widget _StepSMS() {
    return Column(
      key: const ValueKey('step2'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verificação',
          style: TextStyle(
            color: azul,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(color: cinza, fontSize: 14),
            children: [
              const TextSpan(text: 'Enviamos um código para '),
              TextSpan(
                text: numeroMascara,
                style: TextStyle(color: azul, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        _buildPremiumInput(
          controller: smsController,
          hint: 'Código de 4 dígitos',
          icon: Icons.sms_outlined,
          inputType: TextInputType.number,
          formatters: [LengthLimitingTextInputFormatter(4)],
        ),

        if (tempoRestante > 0)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Reenviar em ${tempoRestante}s',
              style: TextStyle(
                color: laranja,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),

        const SizedBox(height: 28),
        _PrimaryButton(
          label: 'Validar Código',
          loading: loading,
          onPressed: _validarCodigo,
        ),
      ],
    );
  }

  Widget _StepSenha() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('step3'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Criar Senha',
            style: TextStyle(
              color: azul,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Defina uma senha segura para acessar sua conta.',
            style: TextStyle(color: cinza, fontSize: 14),
          ),
          const SizedBox(height: 24),

          _buildPremiumInput(
            controller: senhaController,
            hint: 'Nova Senha',
            icon: Icons.lock_outline_rounded,
            isPassword: !senhaVisivel,
            onTogglePassword: () =>
                setState(() => senhaVisivel = !senhaVisivel),
            validator: (v) =>
                v != null && v.length >= 4 ? null : 'Mínimo 4 caracteres',
          ),
          const SizedBox(height: 12),
          _buildPremiumInput(
            controller: confirmarSenhaController,
            hint: 'Confirmar Senha',
            icon: Icons.lock_reset_rounded,
            isPassword: !senhaVisivel,
            validator: (v) =>
                v == senhaController.text ? null : 'Senhas não conferem',
          ),
          const SizedBox(height: 12),
          _buildPremiumInput(
            controller: emailController,
            hint: 'E-mail de Contato',
            icon: Icons.email_outlined,
            inputType: TextInputType.emailAddress,
            validator: (v) =>
                v != null && v.contains('@') ? null : 'E-mail inválido',
          ),

          const SizedBox(height: 28),
          _PrimaryButton(
            label: 'Finalizar Cadastro',
            loading: loading,
            onPressed: _finalizar,
          ),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildToggleButton(String text, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            tipoDoc = text;
            docController.clear();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? azul : cinza,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? formatters,
    bool isPassword = false,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      inputFormatters: formatters,
      obscureText: isPassword,
      style: TextStyle(color: azul, fontWeight: FontWeight.w600),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        suffixIcon: onTogglePassword != null
            ? IconButton(
                icon: Icon(
                  isPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey[400],
                ),
                onPressed: onTogglePassword,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
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
          borderSide: BorderSide(color: amarelo, width: 1.5),
        ),
        errorStyle: const TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD700), // Amarelo
          foregroundColor: const Color(0xFF181883), // Azul
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFF181883),
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool active;
  const _StepDot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? const Color(0xFFFF9900) : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
