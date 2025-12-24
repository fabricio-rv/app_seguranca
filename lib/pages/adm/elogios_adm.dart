import 'package:flutter/material.dart';

class ElogiosAdmPage extends StatefulWidget {
  const ElogiosAdmPage({Key? key}) : super(key: key);

  @override
  State<ElogiosAdmPage> createState() => _ElogiosAdmPageState();
}

class _ElogiosAdmPageState extends State<ElogiosAdmPage>
    with SingleTickerProviderStateMixin {
  final azul = const Color(0xFF181883);
  final amarelo = const Color(0xFFFFD700);
  final laranja = const Color(0xFFFF9900);
  final cinza = const Color(0xFF6B7280);
  final verde = const Color(0xFF10B981);

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  final List<Map<String, String>> elogios = [
    {
      "nome": "Carlos Alberto",
      "cpf": "023.754.753-40",
      "data": "16/07/2025 • 18:33",
      "comentario": "Equipe atenciosa, resolveram tudo com rapidez!",
      "status": "Novo",
    },
    {
      "nome": "Fernanda Lima",
      "cpf": "321.654.987-00",
      "data": "14/07/2025 • 09:15",
      "comentario": "Excelente atendimento, parabéns à equipe técnica.",
      "status": "Novo",
    },
  ];

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
    super.dispose();
  }

  // --- MODAL DE RESPOSTA ---
  void _abrirModalResposta(BuildContext context, String nomeCliente) {
    final TextEditingController _respostaController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.reply_rounded, color: azul, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      'Responder Elogio',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: azul,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Escreva uma mensagem de agradecimento para $nomeCliente:',
                  style: TextStyle(color: cinza, fontSize: 14),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _respostaController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Digite sua resposta aqui...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: amarelo, width: 2),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: cinza,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azul,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        // Aqui você implementaria a lógica real de envio
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Resposta enviada com sucesso!'),
                            backgroundColor: Color(0xFF10B981), // Verde
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text(
                        'Enviar Resposta',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF0),
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
                    children: [
                      Text(
                        'Elogios Recebidos',
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
                      const SizedBox(height: 24),

                      ...elogios.map(
                        (e) => _ElogioCard(
                          data: e,
                          azul: azul,
                          amarelo: amarelo,
                          laranja: laranja,
                          cinza: cinza,
                          verde: verde,
                          onResponder: () =>
                              _abrirModalResposta(context, e["nome"]!),
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
}

class _ElogioCard extends StatelessWidget {
  final Map<String, String> data;
  final Color azul;
  final Color amarelo;
  final Color laranja;
  final Color cinza;
  final Color verde;
  final VoidCallback onResponder; // Novo callback

  const _ElogioCard({
    required this.data,
    required this.azul,
    required this.amarelo,
    required this.laranja,
    required this.cinza,
    required this.verde,
    required this.onResponder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: amarelo, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data["nome"]!,
                  style: TextStyle(
                    color: azul,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(data["data"]!, style: TextStyle(color: cinza, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 4),
          Text(data["cpf"]!, style: TextStyle(color: cinza, fontSize: 13)),
          const SizedBox(height: 14),
          Text(
            data["comentario"]!,
            style: TextStyle(
              color: const Color(0xFF374151),
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Linha de Status e Ação
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: verde.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.thumb_up_rounded, color: verde, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Elogio',
                      style: TextStyle(
                        color: verde,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Botão Responder
              TextButton.icon(
                onPressed: onResponder,
                style: TextButton.styleFrom(
                  foregroundColor: azul,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  backgroundColor: azul.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.reply, size: 18),
                label: const Text(
                  'Responder',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
