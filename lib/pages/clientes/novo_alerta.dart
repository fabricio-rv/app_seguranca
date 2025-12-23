import 'package:flutter/material.dart';

class NovoAvisoSegurancaPage extends StatelessWidget {
  const NovoAvisoSegurancaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF181883);
    final laranja = const Color(0xFFFF9900);

    final mockAlertas = [
      {
        "titulo": "Manutenção no sistema",
        "descricao": "Manutenção programada no servidor principal às 22h.",
        "data": "27/08/2025",
      },
      {
        "titulo": "Novo recurso de monitoramento ativo",
        "descricao": "Agora você pode acompanhar relatórios em tempo real.",
        "data": "25/08/2025",
      },
      {
        "titulo": "Interrupção temporária de energia",
        "descricao": "Possível instabilidade devido a obras na rede elétrica.",
        "data": "20/08/2025",
      },
      {
        "titulo": "Atualização concluída com sucesso",
        "descricao":
            "Sistema atualizado para a versão 2.3. Mais estável e rápido.",
        "data": "18/08/2025",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            expandedHeight: 70,
            flexibleSpace: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: azul),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', height: 100),
                  const SizedBox(height: 20),

                  // Mensagem amarela
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.yellow[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Essa aba é somente para leitura.\n'
                      'Aqui terão informações oficiais da Protepac.\n'
                      'Os alertas são removidos automaticamente após 30 dias.',
                      style: TextStyle(
                        color: azul,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Texto extra
                  Text(
                    "Acompanhe os avisos de segurança postados pela Protepac:",
                    style: TextStyle(
                      color: azul,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Lista de alertas mockados
                  Column(
                    children: mockAlertas.map((alerta) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          border: Border.all(color: laranja, width: 2),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.notifications_active,
                              color: azul,
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    alerta["titulo"]!,
                                    style: TextStyle(
                                      color: azul,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    alerta["descricao"]!,
                                    style: TextStyle(
                                      color: laranja,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    alerta["data"]!,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
