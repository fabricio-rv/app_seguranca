import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar_geral.dart';

class PerfilAdmPage extends StatefulWidget {
  @override
  State<PerfilAdmPage> createState() => _PerfilAdmPageState();
}

class _PerfilAdmPageState extends State<PerfilAdmPage>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
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
    final cinza = const Color(0xFF6B7280);
    final borda = const Color(0xFFE5E7EB);
    final verde = const Color(0xFF10B981);

    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFFFFDF2),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 72, 20, 40),
              child: Column(
                children: [
                  _header(azul, amarelo),
                  const SizedBox(height: 28),
                  _infoCard(
                    title: 'Identidade',
                    icon: Icons.badge_rounded,
                    azul: azul,
                    amarelo: amarelo,
                    borda: borda,
                    children: [
                      _row('Nome', 'João Silva Santos', azul, cinza),
                      _row('E-mail', 'joao.silva@protepac.com.br', azul, cinza),
                      _row('CPF', '123.456.789-**', azul, cinza),
                      _row('Perfil', 'Administrador', azul, cinza),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _infoCard(
                    title: 'Acesso',
                    icon: Icons.lock_clock_rounded,
                    azul: azul,
                    amarelo: amarelo,
                    borda: borda,
                    children: [
                      _row('Último login', '23/12/2025 • 14:30', azul, cinza),
                      _rowStatus('Status', 'Ativa', verde),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _acoesCard(azul, amarelo, cinza, borda),
                  const SizedBox(height: 28),
                  _alterarSenha(azul),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBarGeral(
        selectedIndex: 1,
        onTap: (i) {
          if (i == 0) {
            Navigator.pushReplacementNamed(context, '/home_adm');
          }
        },
      ),
    );
  }

  Widget _header(Color azul, Color amarelo) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [amarelo, amarelo.withOpacity(0.4)],
            ),
          ),
          child: CircleAvatar(
            radius: 58,
            backgroundColor: azul,
            child: Icon(Icons.person_rounded, size: 72, color: amarelo),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'João Silva Santos',
          style: TextStyle(
            color: azul,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Administrador Protepac',
          style: TextStyle(
            color: azul.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _infoCard({
    required String title,
    required IconData icon,
    required Color azul,
    required Color amarelo,
    required Color borda,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borda),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      amarelo.withOpacity(0.35),
                      amarelo.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: amarelo),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: azul,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...children.map(
            (c) => Padding(padding: const EdgeInsets.only(bottom: 14), child: c),
          ),
        ],
      ),
    );
  }

  Widget _acoesCard(Color azul, Color amarelo, Color cinza, Color borda) {
    final acoes = [
      _acao(Icons.check_circle, 'Respondeu chamado', 'Chamado #1247', 'Hoje • 14:30', const Color(0xFF10B981)),
      _acao(Icons.notifications, 'Enviou alerta', 'Alerta de segurança', 'Hoje • 12:15', const Color(0xFFF59E0B)),
      _acao(Icons.person_add, 'Adicionou cliente', 'ABC Segurança', 'Ontem • 09:45', azul),
      _acao(Icons.edit, 'Editou perfil', 'Dados atualizados', '22/12 • 16:10', azul),
    ];

    final visiveis = _expanded ? acoes : acoes.take(3).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borda),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      amarelo.withOpacity(0.35),
                      amarelo.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.history_rounded, color: amarelo),
              ),
              const SizedBox(width: 12),
              Text(
                'Ações Recentes',
                style: TextStyle(
                  color: azul,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...visiveis.map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (a['color'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(a['icon'], color: a['color']),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a['t'], style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text(a['d'], style: TextStyle(color: cinza, fontSize: 12)),
                      ],
                    ),
                  ),
                  Text(a['h'], style: TextStyle(color: cinza, fontSize: 11)),
                ],
              ),
            ),
          ),
          Center(
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _expanded ? 'Ver menos' : 'Ver histórico completo →',
                  style: TextStyle(color: azul, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String l, String v, Color azul, Color cinza) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l, style: TextStyle(color: cinza)),
        Text(v, style: TextStyle(color: azul, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _rowStatus(String l, String v, Color c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l, style: const TextStyle(color: Color(0xFF6B7280))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: c.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            v,
            style: TextStyle(color: c, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _alterarSenha(Color azul) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/esqueci_senha'),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              azul.withOpacity(0.08),
              azul.withOpacity(0.04),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: azul.withOpacity(0.35), width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.lock_rounded, color: azul),
            const SizedBox(width: 12),
            Text(
              'Alterar senha de acesso',
              style: TextStyle(
                color: azul,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _acao(
    IconData i,
    String t,
    String d,
    String h,
    Color c,
  ) =>
      {'icon': i, 't': t, 'd': d, 'h': h, 'color': c};
}
