import 'package:flutter/material.dart';
import 'package:protepac/widgets/bottom_navbar.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage>
    with SingleTickerProviderStateMixin {
  // Dados fictícios
  final String nome = 'Alexandre Gerhardt';
  final String cpf = '12345678901';
  final String senha = '123456';
  String email = 'usuario@email.com';

  late TextEditingController emailController;

  // Controle de Animação
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: email);

    // Configuração da animação de entrada (Fade In)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    _controller.dispose();
    super.dispose();
  }

  String _maskCpf(String cpf) {
    if (cpf.length != 11) return cpf;
    return '***.***.${cpf.substring(6, 9)}-${cpf.substring(9)}';
  }

  // --- FUNÇÃO PARA MOSTRAR MODAL PREMIUM ---
  void _mostrarDialogoConfirmacao({
    required String titulo,
    required String mensagem,
    required String textoConfirmar,
    required VoidCallback onConfirmar,
    IconData icone = Icons.info_outline,
    Color corPrincipal = const Color(0xFF181883),
    bool isDestructive = false, // Se for 'Sair', fica vermelho
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ícone de destaque
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (isDestructive ? Colors.red : corPrincipal)
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icone,
                    size: 32,
                    color: isDestructive ? Colors.red : corPrincipal,
                  ),
                ),
                const SizedBox(height: 20),
                // Título
                Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF181883),
                  ),
                ),
                const SizedBox(height: 12),
                // Mensagem
                Text(
                  mensagem,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                // Botões
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            Navigator.pop(context), // Fecha o modal
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: isDestructive
                              ? Colors.red
                              : corPrincipal,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Fecha o modal primeiro
                          onConfirmar(); // Executa a ação
                        },
                        child: Text(
                          textoConfirmar,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Paleta de Cores
    final azul = const Color(0xFF181883);
    final amarelo = const Color(0xFFFFD700);
    final cinza = const Color(0xFF6B7280);
    final borda = const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fade,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFFFF), Color(0xFFFFFDF2)],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
              child: Column(
                children: [
                  // 1. Cabeçalho
                  _buildHeader(azul, amarelo),

                  const SizedBox(height: 30),

                  // 2. Dados Pessoais
                  _buildSectionTitle('Dados Pessoais', azul),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    borda: borda,
                    children: [
                      _buildReadOnlyRow(
                        Icons.person_outline,
                        'Nome Completo',
                        nome,
                        azul,
                        cinza,
                      ),
                      Divider(height: 24, color: borda.withOpacity(0.5)),
                      _buildReadOnlyRow(
                        Icons.badge_outlined,
                        'CPF',
                        _maskCpf(cpf),
                        azul,
                        cinza,
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // 3. Conta e Segurança
                  _buildSectionTitle('Conta e Segurança', azul),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borda),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Campo de E-mail
                        Text(
                          'E-mail de contato',
                          style: TextStyle(color: cinza, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: azul,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: azul.withOpacity(0.7),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: borda),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: amarelo,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Botão Salvar E-mail (COM MODAL)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: azul,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              // Abre o modal de confirmação
                              _mostrarDialogoConfirmacao(
                                titulo: 'Atualizar E-mail',
                                mensagem:
                                    'Confirma a alteração do seu e-mail de contato para "${emailController.text}"?',
                                textoConfirmar: 'Confirmar',
                                icone: Icons.mark_email_read_rounded,
                                onConfirmar: () {
                                  setState(() {
                                    email = emailController.text;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'E-mail atualizado com sucesso!',
                                          ),
                                        ],
                                      ),
                                      backgroundColor: const Color(0xFF10B981),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Atualizar E-mail',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),

                        Divider(height: 30, color: borda),

                        // Senha (COM MODAL DE REDIRECIONAMENTO)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  color: cinza,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Senha',
                                      style: TextStyle(
                                        color: cinza,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '*' * senha.length,
                                      style: TextStyle(
                                        color: azul,
                                        fontSize: 18,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                // Abre modal explicando o fluxo de senha
                                _mostrarDialogoConfirmacao(
                                  titulo: 'Alterar Senha',
                                  mensagem:
                                      'Por motivos de segurança, você será redirecionado para a tela de recuperação de senha.',
                                  textoConfirmar: 'Prosseguir',
                                  icone: Icons.lock_reset_rounded,
                                  onConfirmar: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/esqueci_senha',
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Alterar',
                                style: TextStyle(
                                  color: azul,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 4. Botão de Logout (COM MODAL DESTRUTIVO)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.red.withOpacity(0.02),
                      ),
                      onPressed: () {
                        // Modal de Logout
                        _mostrarDialogoConfirmacao(
                          titulo: 'Sair do Aplicativo',
                          mensagem: 'Tem certeza que deseja sair da sua conta?',
                          textoConfirmar: 'Sair Agora',
                          icone: Icons.power_settings_new_rounded,
                          isDestructive: true, // Deixa o modal vermelho
                          onConfirmar: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.logout_rounded, color: Colors.red[400]),
                      label: Text(
                        'Sair do Aplicativo',
                        style: TextStyle(
                          color: Colors.red[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Opacity(
                    opacity: 0.5,
                    child: Image.asset('assets/logo.png', height: 40),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/minhas_manifestacoes');
          }
        },
      ),
    );
  }

  // --- Widgets Auxiliares ---

  Widget _buildHeader(Color azul, Color amarelo) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: amarelo, width: 2),
            boxShadow: [
              BoxShadow(
                color: azul.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person_rounded,
              size: 60,
              color: azul.withOpacity(0.8),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          nome,
          style: TextStyle(
            color: azul,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: amarelo.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Cliente Protepac',
            style: TextStyle(
              color: const Color(0xFFB48600),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: color.withOpacity(0.2))),
      ],
    );
  }

  Widget _buildInfoCard({
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildReadOnlyRow(
    IconData icon,
    String label,
    String value,
    Color azul,
    Color cinza,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: azul.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: azul, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: cinza, fontSize: 12)),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: azul,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
