// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar.dart';

class HomePage extends StatelessWidget {
  // Nova lista de botões na ordem solicitada
  final List<_MenuButton> buttons = [
    _MenuButton(
      'Solicitar Chamado Técnico,\nManutenção, Revisão',
      Icons.build_circle_rounded,
      '/novo_chamado_tecnico',
    ),
    _MenuButton('Alertas Protepac', Icons.warning, '/novo_aviso_seguranca'),
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
    _MenuButton('Elogio', Icons.thumb_up, '/novo_elogio'),
    _MenuButton('Reclamação', Icons.thumb_down, '/nova_reclamacao'),
    _MenuButton('Sugestão', Icons.lightbulb_outline, '/nova_sugestao'),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = 2;
    final isSmallDevice = screenWidth < 350;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
              child: Column(
                children: [
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/logo.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final b = buttons[index];
                return _MenuCard(
                  title: b.title,
                  icon: b.icon,
                  onTap: () {
                    Navigator.pushNamed(context, b.route);
                  },
                  isSmall: isSmallDevice,
                );
              }, childCount: buttons.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: screenWidth < 350
                    ? 1.1
                    : screenWidth < 410
                    ? 1.2
                    : 1.35,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 18)),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/minhas_manifestacoes');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/perfil');
          }
        },
      ),
    );
  }
}

class _MenuButton {
  final String title;
  final IconData icon;
  final String route;
  _MenuButton(this.title, this.icon, this.route);
}

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSmall;
  const _MenuCard({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    // Fontes responsivas
    double fontSize = isSmall ? 12 : (title.length > 30 ? 11 : 14);
    double iconSize = isSmall ? 35 : 40;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFFFD700), width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Color(0xFF181883), size: iconSize),
              const SizedBox(height: 10),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF181883),
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
