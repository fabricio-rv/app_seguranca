import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

// --- MOCKS E SERVIÇOS (Mantidos da sua lógica original) ---

class ResetSenhaResult {
  final bool ok;
  final String? error;
  const ResetSenhaResult._({required this.ok, this.error});
  factory ResetSenhaResult.success() => const ResetSenhaResult._(ok: true);
  factory ResetSenhaResult.fail(String msg) =>
      ResetSenhaResult._(ok: false, error: msg);
}

abstract class ResetSenhaService {
  Future<bool> enviarCodigo(String doc);
  Future<bool> validarCodigo(String codigo);
  Future<ResetSenhaResult> alterarSenha(String novaSenha);
}

class ResetSenhaServiceMock implements ResetSenhaService {
  @override
  Future<bool> enviarCodigo(String doc) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  @override
  Future<bool> validarCodigo(String codigo) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return codigo.trim() == '1234';
  }

  @override
  Future<ResetSenhaResult> alterarSenha(String novaSenha) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return ResetSenhaResult.success();
  }
}

// Enum para os tipos de Modal
enum _ModalKind { success, error }

// --- TELA PRINCIPAL ---

class EsqueciSenhaPage extends StatefulWidget {
  const EsqueciSenhaPage({Key? key}) : super(key: key);

  @override
  State<EsqueciSenhaPage> createState() => _EsqueciSenhaPageState();
}

class _EsqueciSenhaPageState extends State<EsqueciSenhaPage>
    with SingleTickerProviderStateMixin {
  // Cores do Design System
  final azul = const Color(0xFF181883);
  final amarelo = const Color(0xFFFFD700);
  final laranja = const Color(0xFFFF9900);
  final cinza = const Color(0xFF6B7280);

  // Controllers
  final docController = TextEditingController();
  final smsController = TextEditingController();
  final novaSenhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late final ResetSenhaService _service;

  // Estados
  String tipoDoc = 'CPF';
  bool enviouCodigo = false;
  bool codigoValidado = false;
  bool loading = false;
  bool senhaVisivel = false;

  Timer? _timer;
  int tempoRestante = 0;
  final numeroMascara = '(51) 9****-6445';

  // Animações
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  MaskedInputFormatter get _mask => tipoDoc == 'CPF'
      ? MaskedInputFormatter('###.###.###-##')
      : MaskedInputFormatter('##.###.###/####-##');

  int get _maxLength => tipoDoc == 'CPF' ? 14 : 18;

  @override
  void initState() {
    super.initState();
    _service = ResetSenhaServiceMock();

    // Inicialização correta das animações
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
    _timer?.cancel();
    docController.dispose();
    smsController.dispose();
    novaSenhaController.dispose();
    confirmarSenhaController.dispose();
    _animController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE NEGÓCIO ---

  Future<void> _enviarCodigo() async {
    FocusScope.of(context).unfocus();
    final doc = docController.text.trim();

    if (doc.isEmpty || doc.length != _maxLength) {
      await _showPremiumModal(
        kind: _ModalKind.error,
        title: 'Documento Inválido',
        message: 'Por favor, informe um $tipoDoc válido para continuarmos.',
        primaryText: 'Corrigir',
      );
      return;
    }

    setState(() => loading = true);
    await _service.enviarCodigo(doc);
    setState(() => loading = false);

    setState(() {
      enviouCodigo = true;
      tempoRestante = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (tempoRestante > 0) {
        setState(() => tempoRestante--);
      } else {
        t.cancel();
      }
    });

    await _showPremiumModal(
      kind: _ModalKind.success,
      title: 'Código Enviado',
      message:
          'Enviamos um código de verificação para o número:\n$numeroMascara',
      primaryText: 'Entendi',
    );
  }

  Future<void> _validarCodigo() async {
    FocusScope.of(context).unfocus();
    final code = smsController.text.trim();

    if (code.isEmpty || code.length < 4) {
      await _showPremiumModal(
        kind: _ModalKind.error,
        title: 'Código Incompleto',
        message: 'Por favor, digite o código de 4 dígitos enviado por SMS.',
        primaryText: 'OK',
      );
      return;
    }

    setState(() => loading = true);
    final ok = await _service.validarCodigo(code);
    setState(() => loading = false);

    if (!ok) {
      await _showPremiumModal(
        kind: _ModalKind.error,
        title: 'Código Inválido',
        message: 'O código informado não confere. Verifique e tente novamente.',
        primaryText: 'Tentar Novamente',
      );
      return;
    }

    await _showPremiumModal(
      kind: _ModalKind.success,
      title: 'Verificado!',
      message:
          'Código validado com sucesso. Agora você pode redefinir sua senha.',
      primaryText: 'Criar Nova Senha',
    );

    if (!mounted) return;
    setState(() => codigoValidado = true);
  }

  Future<void> _alterarSenha() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => loading = true);
    final result = await _service.alterarSenha(novaSenhaController.text.trim());
    setState(() => loading = false);

    if (!result.ok) {
      await _showPremiumModal(
        kind: _ModalKind.error,
        title: 'Erro ao Alterar',
        message: result.error ?? 'Ocorreu um erro inesperado. Tente novamente.',
        primaryText: 'OK',
      );
      return;
    }

    // Modal de Sucesso (Await para esperar o usuário clicar no botão do modal)
    await _showPremiumModal(
      kind: _ModalKind.success,
      title: 'Senha Redefinida!',
      message:
          'Sua senha foi alterada com sucesso. Faça login para acessar sua conta.',
      primaryText: 'Ir para Login',
    );

    if (!mounted) return;

    // --- CORREÇÃO AQUI ---
    // Em vez de popUntil, usamos pushNamedAndRemoveUntil para FORÇAR a ida ao /login
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false, // Remove todas as telas anteriores da memória
    );
  }

  Future<void> _reEnviarCodigo() async {
    if (tempoRestante > 0) return;
    smsController.clear();
    await _enviarCodigo();
  }

  // --- MODAL PREMIUM ---
  Future<void> _showPremiumModal({
    required _ModalKind kind,
    required String title,
    required String message,
    required String primaryText,
  }) {
    final isSuccess = kind == _ModalKind.success;
    final color = isSuccess ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final icon = isSuccess
        ? Icons.check_circle_rounded
        : Icons.error_outline_rounded;

    return showDialog(
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
                  color: isSuccess
                      ? color.withOpacity(0.1)
                      : azul.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: isSuccess ? color : azul),
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
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: amarelo,
                    foregroundColor: azul,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    primaryText,
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

  // --- UI PRINCIPAL ---

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
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // App Bar
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
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
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
                                      ? _stepDocumento()
                                      : codigoValidado
                                      ? _stepNovaSenha()
                                      : _stepSMS(),
                                ),
                              ),

                              const SizedBox(height: 30),

                              // Indicadores de Progresso
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

  // --- WIDGETS DAS ETAPAS ---

  Widget _stepDocumento() {
    return Column(
      key: const ValueKey('step1'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recuperar Acesso',
          style: TextStyle(
            color: azul,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Informe seu documento para localizarmos sua conta.',
          style: TextStyle(color: cinza, fontSize: 14),
        ),
        const SizedBox(height: 24),

        // Toggle Tipo Doc (Adicionado para permitir troca)
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
          hint: tipoDoc == 'CPF' ? '000.000.000-00' : '00.000.000/0000-00',
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

  Widget _stepSMS() {
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
              const TextSpan(text: 'Código enviado para '),
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

        if (tempoRestante == 0)
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: _reEnviarCodigo,
              child: Text(
                'Reenviar Código',
                style: TextStyle(color: azul, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }

  Widget _stepNovaSenha() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('step3'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Redefinir Senha',
            style: TextStyle(
              color: azul,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crie uma nova senha segura para sua conta.',
            style: TextStyle(color: cinza, fontSize: 14),
          ),
          const SizedBox(height: 24),

          _buildPremiumInput(
            controller: novaSenhaController,
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
                v == novaSenhaController.text ? null : 'Senhas não conferem',
          ),

          const SizedBox(height: 28),
          _PrimaryButton(
            label: 'Alterar Senha',
            loading: loading,
            onPressed: _alterarSenha,
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
          backgroundColor: const Color(0xFFFFD700),
          foregroundColor: const Color(0xFF181883),
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
