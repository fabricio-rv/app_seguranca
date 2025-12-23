import 'package:flutter/material.dart';
import 'package:protepac/widgets/bottom_navbar.dart';

class MinhasManifestacoesPage extends StatefulWidget {
  @override
  State<MinhasManifestacoesPage> createState() =>
      _MinhasManifestacoesPageState();
}

class _MinhasManifestacoesPageState extends State<MinhasManifestacoesPage> {
  List<Manifestacao> manifestacoes = [
    Manifestacao(
      tipo: 'Elogio',
      icon: Icons.thumb_up_alt_rounded,
      texto: 'Equipe atenciosa, resolveram tudo com rapidez!',
      resposta: 'Muito obrigado pelo seu elogio! Nossa equipe agradece.',
      dataHora: DateTime(2025, 7, 16, 18, 33),
      visto: false,
    ),
    Manifestacao(
      tipo: 'Reclamação',
      icon: Icons.thumb_down_alt_rounded,
      texto: 'Fiquei aguardando retorno e não fui atendido.',
      resposta: 'Pedimos desculpas pelo transtorno, já estamos ajustando.',
      dataHora: DateTime(2025, 7, 15, 9, 15),
      visto: false,
    ),
    Manifestacao(
      tipo: 'Chamado técnico',
      icon: Icons.build_circle_rounded,
      texto: 'CFTV - Imagens da câmera frontal estão fora do ar.',
      resposta: 'Chamado registrado, técnico será enviado em breve.',
      dataHora: DateTime(2025, 7, 14, 14, 55),
      visto: true,
    ),
    Manifestacao(
      tipo: 'Aviso Segurança',
      icon: Icons.security_rounded,
      texto:
          'Câmera - Câmera da frente apresentou alerta de movimento suspeito.',
      resposta: 'Equipe de segurança notificada, monitoramento reforçado.',
      dataHora: DateTime(2025, 7, 13, 11, 25),
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
      visto: true,
    ),
    Manifestacao(
      tipo: 'Indicação Cliente',
      icon: Icons.person_add_alt_1_rounded,
      texto: 'Maria Silva Pereira - 51996756445\nCFTV - Comercial.',
      resposta: 'Agradecemos pela indicação, nossa equipe fará contato.',
      dataHora: DateTime(2025, 7, 11, 13, 44),
      visto: true,
    ),
    Manifestacao(
      tipo: 'Sugestão',
      icon: Icons.lightbulb_outline_rounded,
      texto: 'Poderiam adicionar notificações por WhatsApp.',
      resposta: 'Sugestão recebida, vamos avaliar em nossa equipe.',
      dataHora: DateTime(2025, 7, 10, 15, 55),
      visto: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF181883);
    final laranja = const Color(0xFFFF9900);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
              child: Column(
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Minhas Manifestações',
                    style: TextStyle(
                      color: azul,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            sliver: SliverList.separated(
              itemCount: manifestacoes.length,
              separatorBuilder: (_, __) => SizedBox(height: 16),
              itemBuilder: (context, index) {
                final m = manifestacoes[index];
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 12,
                  ), // margem pra não colar na tela
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFFFD700), width: 2),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // altura só o suficiente
                    children: [
                      Row(
                        children: [
                          Icon(m.icon, color: azul),
                          SizedBox(width: 7),
                          Text(
                            m.tipo,
                            style: TextStyle(
                              color: azul,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Spacer(),
                          Text(
                            _formatDataHora(m.dataHora),
                            style: TextStyle(
                              color: laranja,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        m.texto,
                        style: TextStyle(color: azul, fontSize: 15),
                      ),
                      SizedBox(height: 12),
                      if (m.resposta != null) ...[
                        Text(
                          "Resposta:",
                          style: TextStyle(
                            color: laranja,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                m.resposta!,
                                style: TextStyle(color: laranja, fontSize: 14),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: m.visto
                                      ? Colors.green
                                      : Color(0xFFFF9900),
                                  width: 2.2,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  m.visto
                                      ? Icons.check_circle
                                      : Icons.hourglass_bottom,
                                  color: m.visto
                                      ? Colors.green
                                      : Color(0xFFFF9900),
                                  size: 26,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 26)),
        ],
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

  String _formatDataHora(DateTime dt) {
    String doisDigitos(int n) => n.toString().padLeft(2, '0');
    return '${doisDigitos(dt.day)}/${doisDigitos(dt.month)}/${dt.year} ${doisDigitos(dt.hour)}:${doisDigitos(dt.minute)}';
  }
}

class Manifestacao {
  final String tipo;
  final IconData icon;
  final String texto;
  final String? resposta;
  final DateTime dataHora;
  final bool visto;

  Manifestacao({
    required this.tipo,
    required this.icon,
    required this.texto,
    this.resposta,
    required this.dataHora,
    required this.visto,
  });

  Manifestacao copyWith({
    String? tipo,
    IconData? icon,
    String? texto,
    String? resposta,
    DateTime? dataHora,
    bool? visto,
  }) {
    return Manifestacao(
      tipo: tipo ?? this.tipo,
      icon: icon ?? this.icon,
      texto: texto ?? this.texto,
      resposta: resposta ?? this.resposta,
      dataHora: dataHora ?? this.dataHora,
      visto: visto ?? this.visto,
    );
  }
}
