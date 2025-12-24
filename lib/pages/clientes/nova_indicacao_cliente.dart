import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NovaIndicacaoClientePage extends StatefulWidget {
  const NovaIndicacaoClientePage({Key? key}) : super(key: key);

  @override
  State<NovaIndicacaoClientePage> createState() =>
      _NovaIndicacaoClientePageState();
}

class _NovaIndicacaoClientePageState extends State<NovaIndicacaoClientePage>
    with SingleTickerProviderStateMixin {
  // Estados
  bool cftv = false;
  bool alarme = false;
  bool comercial = false;
  bool residencial = false;
  bool outroSistema = false;
  bool outroCategoria = false;

  bool enviando = false;

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController(); // Novo Controller
  final _telefoneController = TextEditingController();
  final _controllerOutroSistema = TextEditingController();
  final _controllerOutroCategoria = TextEditingController();

  // Animações
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

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
    _nomeController.dispose();
    _emailController.dispose(); // Dispose do novo controller
    _telefoneController.dispose();
    _controllerOutroSistema.dispose();
    _controllerOutroCategoria.dispose();
    _animController.dispose();
    super.dispose();
  }

  bool get formValido {
    final nomeOk = _nomeController.text.trim().isNotEmpty;
    final emailOk = _emailController.text
        .trim()
        .isNotEmpty; // Validação do email
    final telefoneOk = _telefoneController.text.trim().isNotEmpty;

    final grupo1 = cftv || alarme || outroSistema;
    final grupo2 = comercial || residencial || outroCategoria;

    final outroSistemaOk =
        !outroSistema || _controllerOutroSistema.text.trim().isNotEmpty;
    final outroCategoriaOk =
        !outroCategoria || _controllerOutroCategoria.text.trim().isNotEmpty;

    return nomeOk &&
        emailOk &&
        telefoneOk &&
        grupo1 &&
        grupo2 &&
        outroSistemaOk &&
        outroCategoriaOk;
  }

  // --- MODAL PREMIUM ---
  void _mostrarModalFeedback({
    required bool sucesso,
    required String titulo,
    required String mensagem,
    VoidCallback? onConfirmar,
  }) {
    final azul = const Color(0xFF181883);
    final corIcone = sucesso
        ? const Color(0xFF10B981)
        : const Color(0xFFFF9900);
    final icone = sucesso
        ? Icons.check_circle_rounded
        : Icons.info_outline_rounded;

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
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
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
                      sucesso ? 'Voltar ao Início' : 'Entendi',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                if (sucesso) ...[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.of(
                        context,
                      ).pushReplacementNamed('/minhas_manifestacoes');
                    },
                    child: Text(
                      'Ver minhas manifestações',
                      style: TextStyle(
                        color: azul,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _enviar() {
    if (!formValido) {
      _mostrarModalFeedback(
        sucesso: false,
        titulo: 'Dados Incompletos',
        mensagem:
            'Por favor, preencha o nome, e-mail, telefone e selecione pelo menos uma opção em cada grupo.',
      );
      return;
    }

    // Simulação de envio
    setState(() => enviando = true);

    // Simula delay de rede
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => enviando = false);

      _mostrarModalFeedback(
        sucesso: true,
        titulo: 'Indicação Enviada',
        mensagem:
            'Agradecemos pela indicação! Nossa equipe comercial entrará em contato com o cliente em breve.',
        onConfirmar: () {
          Navigator.of(context).pushReplacementNamed('/home');
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF181883);
    final amarelo = const Color(0xFFFFD700);
    final laranja = const Color(0xFFFF9900);
    final cinzaTexto = const Color(0xFF4B5563);

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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: true,
                  leading: Container(
                    margin: const EdgeInsets.all(8),
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

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                            child: Image.asset(
                              'assets/logo.png',
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Text(
                          'Indicar Novo Cliente',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: azul,
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 60,
                          height: 4,
                          decoration: BoxDecoration(
                            color: amarelo,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Por gentileza, informe os dados da pessoa indicada, e nossa equipe entrará em contato.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cinzaTexto,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // --- 1. Dados Pessoais ---
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Dados do Cliente',
                            style: TextStyle(
                              color: azul,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildPremiumTextField(
                          controller: _nomeController,
                          hint: 'Nome Completo',
                          icon: Icons.person_outline_rounded,
                          azul: azul,
                          laranja: laranja,
                        ),
                        const SizedBox(height: 12),
                        // NOVO CAMPO: E-MAIL
                        _buildPremiumTextField(
                          controller: _emailController,
                          hint: 'E-mail',
                          icon: Icons.email_outlined,
                          inputType: TextInputType.emailAddress,
                          azul: azul,
                          laranja: laranja,
                        ),
                        const SizedBox(height: 12),
                        _buildPremiumTextField(
                          controller: _telefoneController,
                          hint: 'Telefone (com DDD)',
                          icon: Icons.phone_outlined,
                          inputType: TextInputType.phone,
                          azul: azul,
                          laranja: laranja,
                        ),

                        const SizedBox(height: 30),

                        // --- 2. Tipo de Sistema ---
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tipo de Sistema',
                            style: TextStyle(
                              color: azul,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: [
                            _SelectionCard(
                              label: 'Câmera (CFTV)',
                              icon: Icons.videocam_outlined,
                              isSelected: cftv,
                              onTap: () => setState(() => cftv = !cftv),
                              azul: azul,
                              laranja: laranja,
                            ),
                            const SizedBox(height: 8),
                            _SelectionCard(
                              label: 'Alarme Monitorado',
                              icon: Icons.notifications_active_outlined,
                              isSelected: alarme,
                              onTap: () => setState(() => alarme = !alarme),
                              azul: azul,
                              laranja: laranja,
                            ),
                            const SizedBox(height: 8),
                            _SelectionCard(
                              label: 'Outros',
                              icon: Icons.add_circle_outline,
                              isSelected: outroSistema,
                              onTap: () =>
                                  setState(() => outroSistema = !outroSistema),
                              azul: azul,
                              laranja: laranja,
                            ),
                          ],
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: outroSistema
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: _buildPremiumTextField(
                                    controller: _controllerOutroSistema,
                                    hint: 'Qual outro sistema?',
                                    azul: azul,
                                    laranja: laranja,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        const SizedBox(height: 30),

                        // --- 3. Categoria ---
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Categoria do Local',
                            style: TextStyle(
                              color: azul,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: [
                            _SelectionCard(
                              label: 'Comercial',
                              icon: Icons.store_mall_directory_outlined,
                              isSelected: comercial,
                              onTap: () =>
                                  setState(() => comercial = !comercial),
                              azul: azul,
                              laranja: laranja,
                            ),
                            const SizedBox(height: 8),
                            _SelectionCard(
                              label: 'Residencial',
                              icon: Icons.home_outlined,
                              isSelected: residencial,
                              onTap: () =>
                                  setState(() => residencial = !residencial),
                              azul: azul,
                              laranja: laranja,
                            ),
                            const SizedBox(height: 8),
                            _SelectionCard(
                              label: 'Outros',
                              icon: Icons.category_outlined,
                              isSelected: outroCategoria,
                              onTap: () => setState(
                                () => outroCategoria = !outroCategoria,
                              ),
                              azul: azul,
                              laranja: laranja,
                            ),
                          ],
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: outroCategoria
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: _buildPremiumTextField(
                                    controller: _controllerOutroCategoria,
                                    hint: 'Qual outra categoria?',
                                    azul: azul,
                                    laranja: laranja,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        const SizedBox(height: 32),

                        // Botão Enviar
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: laranja,
                              foregroundColor: Colors.white,
                              elevation: 8,
                              shadowColor: laranja.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: (!enviando && formValido)
                                ? _enviar
                                : null,
                            child: enviando
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.person_add_alt_1_rounded),
                                      SizedBox(width: 10),
                                      Text(
                                        'Enviar Indicação',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Componentes ---

  Widget _buildPremiumTextField({
    required TextEditingController controller,
    required String hint,
    required Color azul,
    required Color laranja,
    IconData? icon,
    TextInputType inputType = TextInputType.text,
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
        keyboardType: inputType,
        style: TextStyle(
          color: azul,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey[400]) : null,
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
}

// Card de Seleção Interativo
class _SelectionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color azul;
  final Color laranja;

  const _SelectionCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.azul,
    required this.laranja,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? laranja.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? laranja : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: laranja.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? laranja : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : Colors.grey[500],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? azul : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: laranja, size: 22)
            else
              Icon(Icons.circle_outlined, color: Colors.grey[300], size: 22),
          ],
        ),
      ),
    );
  }
}
