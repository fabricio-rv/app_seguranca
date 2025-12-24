import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Tipos de erro para controle
enum AuthErrorType { none, userNotFound, wrongPassword, generic }

// Resultado da autenticação
class AuthResult {
  final bool ok;
  final String? route;
  final Map<String, dynamic>? arguments;
  final AuthErrorType errorType;
  final String? errorMessage;

  const AuthResult._({
    required this.ok,
    this.route,
    this.arguments,
    this.errorType = AuthErrorType.none,
    this.errorMessage,
  });
  factory AuthResult.success(String route, {Map<String, dynamic>? args}) =>
      AuthResult._(ok: true, route: route, arguments: args);
  factory AuthResult.fail(AuthErrorType type, {String? msg}) =>
      AuthResult._(ok: false, errorType: type, errorMessage: msg);
}

// Serviço de Autenticação Mock
abstract class AuthService {
  Future<AuthResult> login({
    required String tipoDoc,
    required String doc,
    required String senha,
  });
}

class AuthServiceMock implements AuthService {
  final List<Map<String, String>> _adms = [
    {
      'nome': 'Carolina Cantu',
      'cpf': '98765432100',
      'email': 'monitoramento@protepac.com.br',
    },
    // ... adicione os outros aqui se necessário
  ];

  String _normalize(String input) => input.replaceAll(RegExp(r'[^0-9]'), '');

  @override
  Future<AuthResult> login({
    required String tipoDoc,
    required String doc,
    required String senha,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 1500),
    ); // Delay para dar sensação de processamento
    final cleanDoc = _normalize(doc);

    // 1. MOCK CLIENTE
    if (cleanDoc == '12345678900') {
      if (senha != '1234') return AuthResult.fail(AuthErrorType.wrongPassword);
      return AuthResult.success(
        '/home',
        args: {'nome': 'Cliente Teste', 'role': 'user'},
      );
    }

    // 2. MOCK ADM (Simplificado para o exemplo)
    // Se quiser validar a lista _adms, descomente a lógica original.
    // Aqui vou simular um sucesso genérico de ADM se o CPF for diferente do cliente.
    if (cleanDoc != '12345678900' && cleanDoc.length == 11) {
      if (senha != '1234') return AuthResult.fail(AuthErrorType.wrongPassword);
      return AuthResult.success(
        '/home_adm',
        args: {'nome': 'Administrador', 'role': 'ADM'},
      );
    }

    return AuthResult.fail(AuthErrorType.userNotFound);
  }
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  // Cores Premium
  final azul = const Color(0xFF181883);
  final amarelo = const Color(0xFFFFD700);
  final laranja = const Color(0xFFFF9900);
  final cinza = const Color(0xFF6B7280);

  final _formKey = GlobalKey<FormState>();
  final docController = TextEditingController();
  final senhaController = TextEditingController();

  bool senhaVisivel = false;
  bool loading = false;
  String tipoDoc = 'CPF';

  late final AuthService _auth;
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _auth = AuthServiceMock();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
    _controller.dispose();
    docController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  MaskedInputFormatter get _mask => tipoDoc == 'CPF'
      ? MaskedInputFormatter('###.###.###-##')
      : MaskedInputFormatter('##.###.###/####-##');

  int get _maxLength => tipoDoc == 'CPF' ? 14 : 18;
  String get _hintDoc =>
      tipoDoc == 'CPF' ? '000.000.000-00' : '00.000.000/0000-00';

  // --- MODAL PREMIUM ---
  void _mostrarModal({
    required bool sucesso,
    required String titulo,
    required String mensagem,
    VoidCallback? onConfirmar,
  }) {
    final corIcone = sucesso
        ? const Color(0xFF10B981)
        : const Color(0xFFEF4444);
    final icone = sucesso
        ? Icons.check_circle_rounded
        : Icons.error_outline_rounded;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
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
                    color: corIcone.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icone, size: 40, color: corIcone),
                ),
                const SizedBox(height: 20),
                Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
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
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: azul,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      if (onConfirmar != null) onConfirmar();
                    },
                    child: Text(
                      sucesso ? 'Continuar' : 'Tentar Novamente',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _fazerLogin() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => loading = true);

    final result = await _auth.login(
      tipoDoc: tipoDoc,
      doc: docController.text,
      senha: senhaController.text,
    );

    if (!mounted) return;
    setState(() => loading = false);

    if (result.ok) {
      _mostrarModal(
        sucesso: true,
        titulo: 'Bem-vindo!',
        mensagem: 'Login realizado com sucesso. Você será redirecionado.',
        onConfirmar: () {
          Navigator.pushReplacementNamed(
            context,
            result.route!,
            arguments: result.arguments,
          );
        },
      );
    } else {
      String msg = 'Ocorreu um erro inesperado.';
      String titulo = 'Erro no Login';
      if (result.errorType == AuthErrorType.userNotFound) {
        titulo = 'Usuário não encontrado';
        msg = 'Não encontramos uma conta com este documento.';
      } else if (result.errorType == AuthErrorType.wrongPassword) {
        titulo = 'Senha Incorreta';
        msg = 'A senha informada não confere. Tente novamente.';
      }
      _mostrarModal(sucesso: false, titulo: titulo, mensagem: msg);
    }
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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Hero(
                        tag: 'logo',
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: azul.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Image.asset('assets/logo.png', height: 120),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Card de Login
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: azul.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                'Acesse sua Conta',
                                style: TextStyle(
                                  color: azul,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Entre com seus dados para continuar',
                                style: TextStyle(color: cinza, fontSize: 14),
                              ),
                              const SizedBox(height: 30),

                              // Toggle CPF/CNPJ
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    _buildToggleOption('CPF', tipoDoc == 'CPF'),
                                    _buildToggleOption(
                                      'CNPJ',
                                      tipoDoc == 'CNPJ',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Input Documento
                              _buildPremiumInput(
                                controller: docController,
                                hint: _hintDoc,
                                icon: Icons.person_outline_rounded,
                                isNumber: true,
                                formatters: [_mask],
                                validator: (v) =>
                                    v == null || v.length != _maxLength
                                    ? '$tipoDoc inválido'
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              // Input Senha
                              _buildPremiumInput(
                                controller: senhaController,
                                hint: 'Sua senha',
                                icon: Icons.lock_outline_rounded,
                                isPassword: !senhaVisivel,
                                onTogglePassword: () => setState(
                                  () => senhaVisivel = !senhaVisivel,
                                ),
                                validator: (v) => v == null || v.length < 4
                                    ? 'Senha inválida'
                                    : null,
                              ),
                              const SizedBox(height: 24),

                              // Botão Entrar
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: loading ? null : _fazerLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: amarelo,
                                    foregroundColor: azul,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: loading
                                      ? SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: azul,
                                          ),
                                        )
                                      : const Text(
                                          'Entrar',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/primeiro_login'),
                            child: Text(
                              'Primeiro acesso',
                              style: TextStyle(
                                color: azul,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text('•', style: TextStyle(color: cinza)),
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/esqueci_senha'),
                            child: Text(
                              'Esqueci a senha',
                              style: TextStyle(
                                color: azul,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Text(
                        'Protepac • Segurança e Monitoramento',
                        style: TextStyle(
                          color: cinza.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
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

  Widget _buildToggleOption(String text, bool isSelected) {
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
    bool isPassword = false,
    bool isNumber = false,
    List<TextInputFormatter>? formatters,
    String? Function(String?)? validator,
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
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: formatters,
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
          fillColor: const Color(
            0xFFF9FAFB,
          ), // Fundo levemente cinza dentro do input
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
          errorStyle: const TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }
}
