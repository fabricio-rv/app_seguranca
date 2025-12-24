import 'package:flutter/material.dart';
import 'package:protepac/widgets/bottom_navbar.dart';

class MinhasManifestacoesPage extends StatefulWidget {
  @override
  State<MinhasManifestacoesPage> createState() =>
      _MinhasManifestacoesPageState();
}

class _MinhasManifestacoesPageState extends State<MinhasManifestacoesPage>
    with SingleTickerProviderStateMixin {
  // --- Variáveis de Animação (Iguais à Home) ---
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  // Paleta de cores
  final Color corAzul = const Color(0xFF181883);
  final Color corLaranja = const Color(0xFFFF9900);
  final Color corFundoResposta = const Color(0xFFEFF2F7);

  List<Manifestacao> manifestacoes = [
    Manifestacao(
      tipo: 'Elogio',
      icon: Icons.thumb_up_alt_rounded,
      texto: 'Equipe atenciosa, resolveram tudo com rapidez!',
      resposta: 'Muito obrigado pelo seu elogio! Nossa equipe agradece.',
      dataHora: DateTime(2025, 7, 16, 18, 33),
      dataResposta: DateTime(2025, 7, 17, 09, 10),
      visto: true,
    ),
    Manifestacao(
      tipo: 'Reclamação',
      icon: Icons.thumb_down_alt_rounded,
      texto: 'Fiquei aguardando retorno e não fui atendido.',
      resposta: 'Pedimos desculpas pelo transtorno, já estamos ajustando.',
      dataHora: DateTime(2025, 7, 15, 9, 15),
      dataResposta: DateTime(2025, 7, 15, 14, 20),
      visto: true,
    ),
    Manifestacao(
      tipo: 'Chamado técnico',
      icon: Icons.build_circle_rounded,
      texto: 'CFTV - Imagens da câmera frontal estão fora do ar.',
      resposta: 'Chamado registrado, técnico será enviado em breve.',
      dataHora: DateTime(2025, 7, 14, 14, 55),
      dataResposta: DateTime(2025, 7, 14, 15, 30),
      visto: true,
    ),
    Manifestacao(
      tipo: 'Aviso Segurança',
      icon: Icons.security_rounded,
      texto:
          'Câmera - Câmera da frente apresentou alerta de movimento suspeito.',
      resposta: 'Equipe de segurança notificada, monitoramento reforçado.',
      dataHora: DateTime(2025, 7, 13, 11, 25),
      dataResposta: DateTime(2025, 7, 13, 11, 40),
      visto: true,
    ),
    Manifestacao(
      tipo: 'Solic. Orçamento',
      icon: Icons.request_page_rounded,
      texto:
          'Alarme - Gostaria de orçamento para ampliação do sistema de alarme.',
      resposta:
          'Seu pedido de orçamento foi recebido, retornaremos com valores.',
      dataHora: DateTime(2025, 7, 12, 10, 12),
      dataResposta: DateTime(2025, 7, 13, 08, 00),
      visto: true,
    ),
    Manifestacao(
      tipo: 'Indicação Cliente',
      icon: Icons.person_add_alt_1_rounded,
      texto: 'Maria Silva Pereira - 51996756445\nCFTV - Comercial.',
      resposta: 'Agradecemos pela indicação, nossa equipe fará contato.',
      dataHora: DateTime(2025, 7, 11, 13, 44),
      dataResposta: DateTime(2025, 7, 11, 14, 00),
      visto: true,
    ),
    Manifestacao(
      tipo: 'Sugestão',
      icon: Icons.lightbulb_outline_rounded,
      texto: 'Poderiam adicionar notificações por WhatsApp.',
      resposta: null,
      dataHora: DateTime(2025, 7, 10, 15, 55),
      visto: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Configuração da Animação (Copiado da Home)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
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
    return Scaffold(
      backgroundColor: Colors.white, // Base branca
      body: Container(
        // --- 1. Fundo Gradiente (Copiado da Home) ---
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFFFFDF0)],
          ),
        ),
        // --- 2. Animações de Entrada (Copiado da Home) ---
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: CustomScrollView(
              slivers: [
                _buildHeader(),
                SliverPadding(
                  // Espaçamento do topo ajustado conforme pedido anterior
                  padding: const EdgeInsets.only(
                    top: 30,
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  sliver: SliverList.separated(
                    itemCount: manifestacoes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _buildManifestacaoCard(manifestacoes[index]);
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/perfil');
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(
          top: 50,
          bottom: 20,
          left: 24,
          right: 24,
        ),
        decoration: BoxDecoration(
          color: corAzul,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'Minhas Manifestações',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 24,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'Acompanhe o status dos seus chamados',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManifestacaoCard(Manifestacao m) {
    bool respondido = m.resposta != null && m.resposta!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CABEÇALHO DO CARD
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: corAzul.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(m.icon, color: corAzul, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.tipo,
                        style: TextStyle(
                          color: corAzul,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDataHora(m.dataHora),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: respondido
                        ? Colors.green.withOpacity(0.1)
                        : corLaranja.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: respondido ? Colors.green : corLaranja,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        respondido ? Icons.check_circle : Icons.hourglass_top,
                        size: 14,
                        color: respondido ? Colors.green : corLaranja,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        respondido ? 'Respondido' : 'Pendente',
                        style: TextStyle(
                          color: respondido ? Colors.green : corLaranja,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // TEXTO DO USUÁRIO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              m.texto,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ÁREA DE RESPOSTA
          if (respondido)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: corFundoResposta,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                border: Border(
                  top: BorderSide(color: Colors.grey.withOpacity(0.1)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.support_agent_rounded,
                        size: 18,
                        color: corLaranja,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Resposta da Equipe",
                        style: TextStyle(
                          color: corLaranja,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      if (m.dataResposta != null)
                        Text(
                          _formatDataHora(m.dataResposta!),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    m.resposta!,
                    style: TextStyle(
                      color: corAzul.withOpacity(0.8),
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox(height: 6),
        ],
      ),
    );
  }

  // --- 3. Correção da Data com Ano ---
  String _formatDataHora(DateTime dt) {
    String doisDigitos(int n) => n.toString().padLeft(2, '0');
    // Adicionado /${dt.year}
    return '${doisDigitos(dt.day)}/${doisDigitos(dt.month)}/${dt.year} ${doisDigitos(dt.hour)}:${doisDigitos(dt.minute)}';
  }
}

class Manifestacao {
  final String tipo;
  final IconData icon;
  final String texto;
  final String? resposta;
  final DateTime dataHora;
  final DateTime? dataResposta;
  final bool visto;

  Manifestacao({
    required this.tipo,
    required this.icon,
    required this.texto,
    this.resposta,
    required this.dataHora,
    this.dataResposta,
    required this.visto,
  });

  Manifestacao copyWith({
    String? tipo,
    IconData? icon,
    String? texto,
    String? resposta,
    DateTime? dataHora,
    DateTime? dataResposta,
    bool? visto,
  }) {
    return Manifestacao(
      tipo: tipo ?? this.tipo,
      icon: icon ?? this.icon,
      texto: texto ?? this.texto,
      resposta: resposta ?? this.resposta,
      dataHora: dataHora ?? this.dataHora,
      dataResposta: dataResposta ?? this.dataResposta,
      visto: visto ?? this.visto,
    );
  }
}
