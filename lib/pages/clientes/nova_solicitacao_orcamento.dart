import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NovaSolicitacaoOrcamentoPage extends StatefulWidget {
  const NovaSolicitacaoOrcamentoPage({Key? key}) : super(key: key);

  @override
  State<NovaSolicitacaoOrcamentoPage> createState() =>
      _NovaSolicitacaoOrcamentoPageState();
}

class _NovaSolicitacaoOrcamentoPageState
    extends State<NovaSolicitacaoOrcamentoPage>
    with SingleTickerProviderStateMixin {
  // Estados do formulário
  bool ampliacaoCameras = false;
  bool ampliacaoAlarme = false;
  bool outros = false;

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerOutros = TextEditingController();

  static const int maxLength = 500;
  static const int minLength = 5;

  // Animações
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Configuração da animação de entrada
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
    _controller.dispose();
    _controllerOutros.dispose();
    _animController.dispose();
    super.dispose();
  }

  bool get formValido {
    final marcado = ampliacaoCameras || ampliacaoAlarme || outros;

    // Regra do campo principal
    final textoPrincipalOk =
        _controller.text.trim().isEmpty ||
        _controller.text.trim().length >= minLength;

    // Regra do campo "Outros"
    final outroOk = !outros || _controllerOutros.text.trim().isNotEmpty;

    return marcado && outroOk && textoPrincipalOk;
  }

  // --- MODAL PREMIUM (Reutilizável) ---
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
            'Por favor, selecione pelo menos uma opção e preencha os detalhes necessários para prosseguirmos.',
      );
      return;
    }

    _mostrarModalFeedback(
      sucesso: true,
      titulo: 'Solicitação Enviada',
      mensagem:
          'Recebemos seu pedido de orçamento. Nossa equipe comercial entrará em contato em breve com os valores.',
      onConfirmar: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
    );
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
                // App Bar
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
                            child: Image.asset(
                              'assets/logo.png',
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Títulos
                        Text(
                          'Solicitação de Orçamento',
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
                          'Por gentileza, especifique sua necessidade de orçamento, que nossa equipe entrará em contato.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cinzaTexto,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Seção de Seleção (Estilo Card Interativo)
                        Column(
                          children: [
                            _SelectionCard(
                              label: 'Instalação/Ampliação de Câmeras',
                              icon: Icons.videocam_rounded,
                              isSelected: ampliacaoCameras,
                              onTap: () => setState(
                                () => ampliacaoCameras = !ampliacaoCameras,
                              ),
                              azul: azul,
                              laranja: laranja,
                            ),
                            const SizedBox(height: 12),
                            _SelectionCard(
                              label: 'Instalação/Ampliação do Alarme',
                              icon: Icons.security_rounded,
                              isSelected: ampliacaoAlarme,
                              onTap: () => setState(
                                () => ampliacaoAlarme = !ampliacaoAlarme,
                              ),
                              azul: azul,
                              laranja: laranja,
                            ),
                            const SizedBox(height: 12),
                            _SelectionCard(
                              label: 'Outros',
                              icon: Icons.add_circle_outline_rounded,
                              isSelected: outros,
                              onTap: () => setState(() => outros = !outros),
                              azul: azul,
                              laranja: laranja,
                            ),
                          ],
                        ),

                        // Campo condicional para "Outros"
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: outros
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: _buildPremiumTextField(
                                    controller: _controllerOutros,
                                    hint:
                                        'Descreva outro tipo de solicitação...',
                                    azul: azul,
                                    laranja: laranja,
                                    minLines: 2,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        const SizedBox(height: 30),

                        // Título para o campo de descrição
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Detalhes Adicionais',
                            style: TextStyle(
                              color: azul,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Campo de Descrição Principal
                        _buildPremiumTextField(
                          controller: _controller,
                          hint:
                              'Digite aqui mais detalhes sobre o que você precisa...',
                          azul: azul,
                          laranja: laranja,
                          minLines: 4,
                          showCounter: true,
                        ),

                        const SizedBox(height: 32),

                        // Botão de Envio
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
                            onPressed: formValido ? _enviar : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.request_quote_rounded),
                                SizedBox(width: 10),
                                Text(
                                  'Solicitar Orçamento',
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

  // --- Widgets Auxiliares ---

  Widget _buildPremiumTextField({
    required TextEditingController controller,
    required String hint,
    required Color azul,
    required Color laranja,
    int minLines = 1,
    bool showCounter = false,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: controller,
            minLines: minLines,
            maxLines: null,
            maxLength: showCounter ? maxLength : null,
            style: TextStyle(color: azul, fontSize: 15),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFF3F4F6),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: laranja, width: 1.5),
              ),
              counterText: '', // Remove contador padrão
            ),
          ),
          if (showCounter)
            Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 8),
              child: Text(
                '${controller.text.length} / $maxLength',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Card de Seleção Interativo (Substitui o Checkbox comum)
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
