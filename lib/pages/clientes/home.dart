import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../widgets/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  // Lista atualizada com textos curtos
  final List<_MenuButton> buttons = [
    _MenuButton(
      'Solicitar Chamado', // Nome ajustado
      Icons.build_circle_rounded,
      '/novo_chamado',
    ),
    _MenuButton(
      'Alertas Protepac',
      Icons.warning_amber_rounded,
      '/novo_alerta',
    ),
    _MenuButton(
      'Indicação de Novo Cliente',
      Icons.person_add_alt_1,
      '/nova_indicacao_cliente',
    ),
    _MenuButton(
      'Solicitação de Orçamento',
      Icons.request_page_rounded,
      '/nova_solicitacao_orcamento',
    ),
    _MenuButton('Elogio', Icons.thumb_up_alt_rounded, '/novo_elogio'),
    _MenuButton('Reclamação', Icons.thumb_down_alt_rounded, '/nova_reclamacao'),
    _MenuButton('Sugestão', Icons.lightbulb_outline_rounded, '/nova_sugestao'),
  ];

  @override
  void initState() {
    super.initState();
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
    final azul = const Color(0xFF181883);
    final amarelo = const Color(0xFFFFD700);

    // Recupera argumentos para manter a navegação fluida
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxHeight = constraints.maxHeight;
              final maxWidth = constraints.maxWidth;

              // 1. Definição de Alturas (Proporção)
              // Header um pouco menor para dar espaço ao grid
              final headerHeight = maxHeight * 0.18;
              final gridAreaHeight = maxHeight * 0.82;

              // 2. Configuração do Grid Matemático
              const int rowCount = 4; // 4 Linhas
              const int colCount = 2; // 2 Colunas

              // AUMENTADO O ESPAÇAMENTO PARA DIMINUIR AS CAIXAS
              const double gap = 20.0; // Espaço entre caixas maior
              const double paddingH = 28.0; // Margem lateral maior

              // Altura disponível para os cards (subtraindo espaçamentos)
              final totalGapHeight = (rowCount - 1) * gap;
              // Margem inferior para não colar na navbar
              final bottomMargin = 16.0;

              final cardHeight =
                  (gridAreaHeight - totalGapHeight - bottomMargin) / rowCount;

              // Largura do card
              final totalGapWidth = (colCount - 3) * gap;
              final cardWidth =
                  (maxWidth - (paddingH * 3) - totalGapWidth) / colCount;

              // Aspect Ratio exato para o Flutter desenhar sem scroll
              final childAspectRatio = cardWidth / cardHeight;

              return FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: paddingH),
                    child: Column(
                      children: [
                        // --- HEADER (LOGO) ---
                        SizedBox(
                          height: headerHeight,
                          width: double.infinity,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Image.asset(
                                'assets/logo.png',
                                fit: BoxFit.contain,
                                // Limita altura do logo para não estourar em telas wide
                                height: headerHeight * 0.85,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        // --- GRID DE BOTÕES ---
                        SizedBox(
                          height: gridAreaHeight - bottomMargin,
                          child: GridView.builder(
                            physics:
                                const NeverScrollableScrollPhysics(), // SEM SCROLL
                            itemCount: buttons.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: colCount,
                                  mainAxisSpacing: gap,
                                  crossAxisSpacing: gap,
                                  childAspectRatio: childAspectRatio,
                                ),
                            itemBuilder: (context, index) {
                              return _HomeCard(
                                item: buttons[index],
                                cardHeight: cardHeight,
                                azul: azul,
                                amarelo: amarelo,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    buttons[index].route,
                                    arguments: args,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home', arguments: args);
          } else if (index == 1) {
            Navigator.pushReplacementNamed(
              context,
              '/minhas_manifestacoes',
              arguments: args,
            );
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/perfil', arguments: args);
          }
        },
      ),
    );
  }
}

// Modelo de Dados
class _MenuButton {
  final String title;
  final IconData icon;
  final String route;
  _MenuButton(this.title, this.icon, this.route);
}

// Card Moderno (Responsivo & Clean)
class _HomeCard extends StatefulWidget {
  final _MenuButton item;
  final double cardHeight;
  final Color azul;
  final Color amarelo;
  final VoidCallback onTap;

  const _HomeCard({
    required this.item,
    required this.cardHeight,
    required this.azul,
    required this.amarelo,
    required this.onTap,
  });

  @override
  State<_HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<_HomeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scale = Tween<double>(
      begin: 1,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lógica para telas muito pequenas
    final isCompact = widget.cardHeight < 90;

    // Ícones aumentados conforme solicitado
    final iconSize = isCompact ? 34.0 : 45.0;

    // Fonte ajustada
    final fontSize = isCompact ? 12.5 : 15.0;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: widget.amarelo.withOpacity(0.5), // Borda sutil
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.azul.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícone Limpo (Sem fundo amarelo)
                Icon(widget.item.icon, color: widget.azul, size: iconSize),

                SizedBox(height: isCompact ? 6 : 10),

                // Texto com quebra de linha inteligente
                Text(
                  widget.item.title,
                  textAlign: TextAlign.center,
                  maxLines: 3, // Permite até 3 linhas para telas estreitas
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.azul,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    height: 1.15, // Espaçamento entre linhas confortável
                    letterSpacing: -0.3,
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
