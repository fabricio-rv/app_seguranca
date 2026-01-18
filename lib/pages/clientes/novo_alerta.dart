import 'package:flutter/material.dart';

class NovoAvisoSegurancaPage extends StatefulWidget {
  const NovoAvisoSegurancaPage({Key? key}) : super(key: key);

  @override
  State<NovoAvisoSegurancaPage> createState() => _NovoAvisoSegurancaPageState();
}

class _NovoAvisoSegurancaPageState extends State<NovoAvisoSegurancaPage>
    with SingleTickerProviderStateMixin {
  // Cores
  final azul = const Color(0xFF181883);
  final laranja = const Color(0xFFFF9900);
  final cinzaTexto = const Color(0xFF4B5563);

  // Mock de dados
  final mockAlertas = [
    {
      "titulo": "Manutenção no sistema",
      "descricao":
          "Manutenção programada no servidor principal às 22h. O acesso pode ficar indisponível por alguns minutos.",
      "data": "27/08/2025",
      "tipo": "alerta", // Para decidir o ícone
    },
    {
      "titulo": "Novo recurso de monitoramento",
      "descricao":
          "Agora você pode acompanhar relatórios em tempo real diretamente pelo app. Atualize sua versão.",
      "data": "25/08/2025",
      "tipo": "novidade",
    },
    {
      "titulo": "Interrupção de energia",
      "descricao":
          "Possível instabilidade na região central devido a obras na rede elétrica pública.",
      "data": "20/08/2025",
      "tipo": "aviso",
    },
    {
      "titulo": "Atualização concluída",
      "descricao":
          "Sistema atualizado para a versão 2.3. Mais estabilidade e correções de segurança aplicadas.",
      "data": "18/08/2025",
      "tipo": "sucesso",
    },
  ];

  // Animações
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              slivers: [
                // App Bar Flutuante
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: true,
                  leading: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_rounded, color: azul),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo
                        Hero(
                          tag: 'logo',
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: azul.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/logo.png',
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Título
                        Text(
                          'Alertas de Segurança',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: azul,
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 60,
                          height: 4,
                          decoration: BoxDecoration(
                            color: laranja,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Card de Informação (O antigo "Amarelo")
                        // Agora muito mais elegante e legível
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: laranja.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: laranja.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: laranja,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Atenção',
                                      style: TextStyle(
                                        color: azul,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Esta aba contém informações oficiais da Protepac. Os alertas são removidos automaticamente após 30 dias.',
                                      style: TextStyle(
                                        color: azul.withOpacity(0.8),
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Histórico de Avisos',
                            style: TextStyle(
                              color: azul,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Lista de Alertas
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: mockAlertas.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final alerta = mockAlertas[index];
                            return _buildAlertCard(alerta);
                          },
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, String> alerta) {
    // Lógica para ícone baseado no tipo (simulada)
    IconData iconData;
    Color iconColor;

    switch (alerta['tipo']) {
      case 'alerta':
        iconData = Icons.warning_amber_rounded;
        iconColor = Colors.redAccent;
        break;
      case 'novidade':
        iconData = Icons.new_releases_rounded;
        iconColor = const Color(0xFF181883); // Azul
        break;
      case 'sucesso':
        iconData = Icons.check_circle_outline_rounded;
        iconColor = Colors.green;
        break;
      default:
        iconData = Icons.notifications_none_rounded;
        iconColor = const Color(0xFFFF9900); // Laranja
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF181883).withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Ícone Circular
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              // Título
              Expanded(
                child: Text(
                  alerta['titulo']!,
                  style: const TextStyle(
                    color: Color(0xFF181883),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Descrição
          Text(
            alerta['descricao']!,
            style: const TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          // Rodapé com Data
          Row(
            children: [
              Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 12,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      alerta['data']!,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
