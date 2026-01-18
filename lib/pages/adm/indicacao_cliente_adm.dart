import 'package:flutter/material.dart';

class IndicacaoClienteAdmPage extends StatefulWidget {
  const IndicacaoClienteAdmPage({Key? key}) : super(key: key);

  @override
  State<IndicacaoClienteAdmPage> createState() =>
      _IndicacaoClienteAdmPageState();
}

class _IndicacaoClienteAdmPageState extends State<IndicacaoClienteAdmPage>
    with SingleTickerProviderStateMixin {
  final azul = const Color(0xFF181883);
  final amarelo = const Color(0xFFFFD700);
  final laranja = const Color(0xFFFF9900);
  final cinza = const Color(0xFF6B7280);
  final verde = const Color(0xFF10B981);

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  final List<Map<String, dynamic>> indicacoes = [
    {
      "nome": "Marcos Paulo",
      "doc": "123.654.789-00",
      "telefone": "(51) 99999-1111",
      "email": "marcos@email.com",
      "servico": "Câmeras de Segurança",
      "comentario": "Indicação para orçamento residencial.",
      "data": DateTime(2025, 8, 22, 16, 45),
      "status": "Aberto",
    },
    {
      "nome": "Luciana Prado",
      "doc": "321.987.654-00",
      "telefone": "(51) 98888-2222",
      "email": "luciana@email.com",
      "servico": "Alarme",
      "comentario": "Orçamento para loja de roupas.",
      "data": DateTime(2025, 8, 21, 9, 30),
      "status": "Aberto",
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
                        'Indicações',
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
                      ...indicacoes.map(_IndicacaoCard),
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

  Widget _IndicacaoCard(Map<String, dynamic> i) {
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
                  i["nome"],
                  style: TextStyle(
                    color: azul,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                _fmt(i["data"]),
                style: TextStyle(color: cinza, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(i["doc"], style: TextStyle(color: cinza, fontSize: 13)),
          const SizedBox(height: 12),
          Text(
            i["servico"],
            style: TextStyle(
              color: azul,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(i["comentario"], style: TextStyle(color: cinza)),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.phone, color: azul, size: 18),
              const SizedBox(width: 6),
              Text(i["telefone"], style: TextStyle(color: cinza)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.email, color: azul, size: 18),
              const SizedBox(width: 6),
              Text(i["email"], style: TextStyle(color: cinza)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.reply_rounded, color: azul, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      'Responder',
                      style: TextStyle(
                        color: azul,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
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
                  i["status"],
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

  String _fmt(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year} • '
        '${d.hour.toString().padLeft(2, '0')}:'
        '${d.minute.toString().padLeft(2, '0')}';
  }
}
