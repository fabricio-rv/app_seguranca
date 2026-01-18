import 'package:flutter/material.dart';

class SugestaoAdmPage extends StatefulWidget {
  const SugestaoAdmPage({Key? key}) : super(key: key);

  @override
  State<SugestaoAdmPage> createState() => _SugestaoAdmPageState();
}

class _SugestaoAdmPageState extends State<SugestaoAdmPage>
    with SingleTickerProviderStateMixin {
  final azul = const Color(0xFF181883);
  final amarelo = const Color(0xFFFFD700);
  final laranja = const Color(0xFFFF9900);
  final cinza = const Color(0xFF6B7280);
  final verde = const Color(0xFF10B981);

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  final List<Map<String, String>> sugestoes = [
    {
      'nome': 'Pedro Santos',
      'cpf': '321.654.987-00',
      'titulo': 'Melhoria no App',
      'data': '28/08/2025 • 14:20',
      'mensagem': 'Seria ótimo poder acompanhar o status em tempo real.',
      'status': 'Nova',
    },
    {
      'nome': 'Ana Souza',
      'cpf': '789.123.456-00',
      'titulo': 'Atendimento',
      'data': '27/08/2025 • 16:45',
      'mensagem': 'Sugiro ampliar o horário de atendimento.',
      'status': 'Nova',
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
                        'Sugestões',
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

                      ...sugestoes.map(
                        (s) => _SugestaoCard(
                          data: s,
                          azul: azul,
                          amarelo: amarelo,
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

class _SugestaoCard extends StatelessWidget {
  final Map<String, String> data;
  final Color azul;
  final Color amarelo;
  final Color cinza;
  final Color verde;

  const _SugestaoCard({
    required this.data,
    required this.azul,
    required this.amarelo,
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
                  data['nome']!,
                  style: TextStyle(
                    color: azul,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(data['data']!, style: TextStyle(color: cinza, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 4),
          Text(data['cpf']!, style: TextStyle(color: cinza, fontSize: 13)),
          const SizedBox(height: 14),
          Text(
            data['titulo']!,
            style: TextStyle(
              color: azul,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(data['mensagem']!, style: TextStyle(color: cinza, fontSize: 14)),
          const SizedBox(height: 16),
          Row(
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: verde, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'Sugestão',
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
                  data['status']!,
                  style: TextStyle(
                    color: verde,
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
