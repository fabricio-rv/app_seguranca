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
                        'Elogios',
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

  const _ElogioCard({
    required this.data,
    required this.azul,
    required this.amarelo,
    required this.laranja,
    required this.cinza,
    required this.verde,
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
            style: TextStyle(color: cinza, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Row(
                children: [
                  Icon(Icons.thumb_up_rounded, color: verde, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'Elogio',
                    style: TextStyle(color: verde, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: amarelo.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data["status"]!,
                  style: TextStyle(
                    color: laranja,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
