import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar_geral.dart';

class HomeAdmPage extends StatelessWidget {
  const HomeAdmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF181883);
    final amarelo = const Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final width = constraints.maxWidth;

            final logoHeight = math.min(130.0, height * 0.2);
            final bottomNavHeight = 64.0;
            final verticalPadding = 16.0;

            final availableHeight =
                height - logoHeight - bottomNavHeight - verticalPadding * 3;

            final rowGap = 18.0;
            final usableHeight = availableHeight - rowGap * 2;
            final rowHeight = usableHeight / 3;

            final horizontalPadding = 16.0;
            final gridWidth = width - horizontalPadding * 2;
            final crossSpacing = 14.0;
            final itemWidth = (gridWidth - crossSpacing * 2) / 3;
            final aspectRatio = itemWidth / rowHeight;

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, const Color(0xFFFFFDF0)],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  SizedBox(
                    height: logoHeight,
                    child: Center(
                      child: Image.asset(
                        'assets/logo.png',
                        height: logoHeight,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 42),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _GridRow(
                          height: rowHeight,
                          aspectRatio: aspectRatio,
                          buttons: const [
                            _HomeButton(
                              'Chamados',
                              Icons.build_circle_rounded,
                              '/chamado_adm',
                            ),
                            _HomeButton(
                              'Indicações',
                              Icons.person_add_alt_1,
                              '/indicacao_cliente_adm',
                            ),
                            _HomeButton(
                              'Alertas',
                              Icons.warning_amber_rounded,
                              '/alertas_protepac_adm',
                            ),
                          ],
                        ),
                        SizedBox(height: rowGap),
                        _GridRow(
                          height: rowHeight,
                          aspectRatio: aspectRatio,
                          buttons: const [
                            _HomeButton(
                              'Orçamentos',
                              Icons.request_page_rounded,
                              '/solicitacao_orcamento_adm',
                            ),
                            _HomeButton(
                              'Elogios',
                              Icons.thumb_up_alt_rounded,
                              '/elogios_adm',
                            ),
                            _HomeButton(
                              'Reclamações',
                              Icons.thumb_down_alt_rounded,
                              '/reclamacao_adm',
                            ),
                          ],
                        ),
                        SizedBox(height: rowGap),
                        _GridRow(
                          height: rowHeight,
                          aspectRatio: aspectRatio,
                          buttons: const [
                            _HomeButton(
                              'Adicionar Cliente',
                              Icons.person_add_alt_1,
                              '/adicionar_cliente',
                            ),
                            _HomeButton(
                              'Editar Cliente',
                              Icons.edit_rounded,
                              '/editar_cliente',
                            ),
                            _HomeButton(
                              'Sugestões',
                              Icons.lightbulb_outline_rounded,
                              '/sugestao_adm',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBarGeral(
        selectedIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home_adm');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/perfil_adm');
          }
        },
      ),
    );
  }
}

class _HomeButton {
  final String title;
  final IconData icon;
  final String route;
  const _HomeButton(this.title, this.icon, this.route);
}

class _GridRow extends StatelessWidget {
  final double height;
  final double aspectRatio;
  final List<_HomeButton> buttons;

  const _GridRow({
    required this.height,
    required this.aspectRatio,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 14,
        mainAxisSpacing: 0,
        childAspectRatio: aspectRatio,
        children: buttons
            .map(
              (b) => _HomeCard(
                title: b.title,
                icon: b.icon,
                onTap: () => Navigator.pushNamed(context, b.route),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _HomeCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _HomeCard({
    required this.title,
    required this.icon,
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
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scale = Tween<double>(
      begin: 1,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
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
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: amarelo, width: 1.4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: azul, size: 34),
              const SizedBox(height: 8),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: azul,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
