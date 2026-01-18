import 'package:flutter/material.dart';

class AlertasProtepacAdmPage extends StatefulWidget {
  const AlertasProtepacAdmPage({Key? key}) : super(key: key);

  @override
  State<AlertasProtepacAdmPage> createState() => _AlertasProtepacAdmPageState();
}

class _AlertasProtepacAdmPageState extends State<AlertasProtepacAdmPage>
    with SingleTickerProviderStateMixin {
  final azul = const Color(0xFF181883);
  final amarelo = const Color(0xFFFFD700);
  final laranja = const Color(0xFFFF9900);
  final cinza = const Color(0xFF6B7280);

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    tituloController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  void _publicarAlerta() {
    if (tituloController.text.trim().isEmpty ||
        descricaoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha todos os campos"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Modal de Sucesso Premium (Simulado com SnackBar por enquanto, ou pode ser um Dialog)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text("Alerta enviado: ${tituloController.text}")),
          ],
        ),
        backgroundColor: const Color(0xFF10B981), // Verde sucesso
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    tituloController.clear();
    descricaoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF0),
      // --- HEADER PRESERVADO (Conforme solicitado) ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              backgroundColor: azul,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8),
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
            Container(height: 2, width: double.infinity, color: amarelo),
          ],
        ),
      ),
      // --- CORPO REMODELADO ---
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFFFFDF0)],
          ),
        ),
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔔 Título (Preservado o estilo, ajustado layout)
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Alertas aos Clientes',
                              style: TextStyle(
                                color: azul,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
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
                      ),

                      const SizedBox(height: 32),

                      // 📌 Card principal Moderno
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: amarelo, width: 1.4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cabeçalho do Card
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: laranja.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.warning_amber_rounded,
                                    color: laranja,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  'Novo Alerta',
                                  style: TextStyle(
                                    color: azul,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Campo Título
                            _buildLabel('Título do Alerta'),
                            const SizedBox(height: 8),
                            _buildInput(
                              controller: tituloController,
                              hint: 'Ex: Manutenção programada',
                            ),

                            const SizedBox(height: 20),

                            // Campo Descrição
                            _buildLabel('Descrição Detalhada'),
                            const SizedBox(height: 8),
                            _buildInput(
                              controller: descricaoController,
                              hint:
                                  'Informe os detalhes do alerta para os clientes...',
                              maxLines: 5,
                            ),

                            const SizedBox(height: 32),

                            // Botão Publicar Premium
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _publicarAlerta,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: amarelo,
                                  foregroundColor: azul,
                                  elevation: 4,
                                  shadowColor: amarelo.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.send_rounded, size: 20),
                                    SizedBox(width: 10),
                                    Text(
                                      'Publicar e Notificar',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(color: azul, fontWeight: FontWeight.w700, fontSize: 15),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF181883).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          color: const Color(0xFF181883),
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: amarelo.withOpacity(0.6), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: amarelo, width: 2.0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
