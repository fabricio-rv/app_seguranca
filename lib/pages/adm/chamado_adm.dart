import 'package:flutter/material.dart';

class ChamadoAdmPage extends StatefulWidget {
  const ChamadoAdmPage({Key? key}) : super(key: key);

  @override
  State<ChamadoAdmPage> createState() => _ChamadoAdmPageState();
}

class _ChamadoAdmPageState extends State<ChamadoAdmPage>
    with SingleTickerProviderStateMixin {
  final azul = const Color(0xFF181883);
  final amarelo = const Color(0xFFFFD700);
  final laranja = const Color(0xFFFF9900);
  final cinza = const Color(0xFF6B7280);
  final fundo = const Color(0xFFFFFDF0);
  final verde = const Color(0xFF10B981);

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  final List<Map<String, dynamic>> chamados = [
    {
      "nome": "João Silva",
      "doc": "123.456.789-00",
      "titulo": "Chamado Técnico",
      "descricao": "Câmera da frente não está funcionando.",
      "dataChamado": DateTime(2025, 8, 28, 10, 45),
      "status": "Aberto",
      "resposta": null,
      "dataResposta": null,
      "respondidoPor": null,
    },
    {
      "nome": "Maria Oliveira",
      "doc": "987.654.321-00",
      "titulo": "Revisão de Alarme",
      "descricao": "O alarme disparou sem motivo aparente.",
      "dataChamado": DateTime(2025, 8, 27, 15, 12),
      "status": "Aberto",
      "resposta": null,
      "dataResposta": null,
      "respondidoPor": null,
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
      backgroundColor: fundo,
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
                        'Chamados',
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
                      ...chamados.map(
                        (c) => _ChamadoCard(
                          chamado: c,
                          azul: azul,
                          amarelo: amarelo,
                          laranja: laranja,
                          cinza: cinza,
                          verde: verde,
                          onResponder: () => _abrirResposta(context, c),
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

  void _abrirResposta(BuildContext context, Map<String, dynamic> chamado) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Responder chamado',
                style: TextStyle(
                  color: azul,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Chamado aberto em ${_fmt(chamado["dataChamado"])}',
                style: TextStyle(color: cinza, fontSize: 13),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Digite sua resposta...',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: amarelo, width: 1.6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: amarelo, width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Voltar', style: TextStyle(color: azul)),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: amarelo,
                        foregroundColor: azul,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          chamado["resposta"] = controller.text;
                          chamado["dataResposta"] = DateTime.now();
                          chamado["respondidoPor"] = "João Silva (ADM)";
                          chamado["status"] = "Concluído";
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Enviar',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

class _ChamadoCard extends StatelessWidget {
  final Map<String, dynamic> chamado;
  final Color azul;
  final Color amarelo;
  final Color laranja;
  final Color cinza;
  final Color verde;
  final VoidCallback onResponder;

  const _ChamadoCard({
    required this.chamado,
    required this.azul,
    required this.amarelo,
    required this.laranja,
    required this.cinza,
    required this.verde,
    required this.onResponder,
  });

  @override
  Widget build(BuildContext context) {
    final bool concluido = chamado['status'] == 'Concluído';

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
                  chamado['nome'],
                  style: TextStyle(
                    color: azul,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                _fmt(chamado["dataChamado"]),
                style: TextStyle(color: cinza, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(chamado['doc'], style: TextStyle(color: cinza, fontSize: 13)),
          const SizedBox(height: 14),
          Text(
            chamado['titulo'],
            style: TextStyle(
              color: azul,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            chamado['descricao'],
            style: TextStyle(color: cinza, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              InkWell(
                onTap: onResponder,
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
                  color: concluido
                      ? verde.withOpacity(0.15)
                      : amarelo.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  chamado['status'],
                  style: TextStyle(
                    color: concluido ? verde : laranja,
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
