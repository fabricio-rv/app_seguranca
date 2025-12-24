import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NovaReclamacaoPage extends StatefulWidget {
  const NovaReclamacaoPage({Key? key}) : super(key: key);

  @override
  State<NovaReclamacaoPage> createState() => _NovaReclamacaoPageState();
}

class _NovaReclamacaoPageState extends State<NovaReclamacaoPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  static const int maxLength = 500;
  static const int minLength =
      10; // Ajustei levemente para ser mais realista, mas pode voltar a 2

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
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  bool get _formValido => _controller.text.trim().length >= minLength;

  // --- MODAL PREMIUM PERSONALIZADO ---
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
                // Ícone com brilho
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
                      Navigator.pop(ctx); // Fecha o modal
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
    if (!_formValido) {
      _mostrarModalFeedback(
        sucesso: false,
        titulo: 'Texto muito curto',
        mensagem:
            'Por favor, detalhe melhor sua reclamação. Escreva pelo menos $minLength caracteres para que possamos entender.',
      );
      return;
    }

    // Simulação de envio com sucesso
    _mostrarModalFeedback(
      sucesso: true,
      titulo: 'Reclamação Enviada',
      mensagem:
          'Sua reclamação foi registrada com sucesso. Nossa equipe já está trabalhando para resolver e você será notificado em breve.',
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
      // Fundo Gradiente Suave (Padrão das novas telas)
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
                // App Bar Flutuante e Limpa
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
                        // Logo com leve sombra para destaque
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

                        // Título e Subtítulo Modernizados
                        Text(
                          'Nova Reclamação',
                          style: TextStyle(
                            color: azul,
                            fontWeight: FontWeight.w800,
                            fontSize: 26,
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
                          'Escreva sua reclamação para a Protepac.\nVamos analisar e tomar as providências necessárias.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cinzaTexto,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Área do Formulário (Estilo Card)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFF3F4F6)),
                            boxShadow: [
                              BoxShadow(
                                color: azul.withOpacity(0.06),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.edit_note_rounded,
                                    color: laranja,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Deixe sua reclamação',
                                      style: TextStyle(
                                        color: azul,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Campo de Texto Premium
                              TextField(
                                controller: _controller,
                                minLines: 5,
                                maxLines: 10,
                                maxLength: maxLength,
                                style: TextStyle(color: azul, fontSize: 16),
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText: 'Descreva o ocorrido aqui...',
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  filled: true,
                                  fillColor: const Color(0xFFF9FAFB),
                                  contentPadding: const EdgeInsets.all(16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.grey[200]!,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: laranja,
                                      width: 1.5,
                                    ),
                                  ),
                                  counterText: '', // Oculta o contador padrão
                                ),
                              ),

                              // Contador personalizado e elegante
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    '${_controller.text.length} / $maxLength',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          _controller.text.length >= maxLength
                                          ? Colors.red
                                          : Colors.grey[500],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Botão de Envio (Estilo Gradiente/Sólido)
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: laranja,
                              foregroundColor: Colors
                                  .white, // Texto branco para contraste no laranja
                              elevation: 8,
                              shadowColor: laranja.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: _formValido ? _enviar : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.send_rounded),
                                SizedBox(width: 10),
                                Text(
                                  'Enviar Reclamação',
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
}
