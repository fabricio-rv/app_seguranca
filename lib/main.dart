import 'package:flutter/material.dart';

// --- IMPORTAÇÕES (Ajuste conforme os nomes exatos dos seus arquivos) ---

// TELAS COMUNS / LOGIN
import 'pages/login/login.dart';
import 'pages/login/primeiro_login.dart';
import 'pages/login/esqueci_senha.dart';

// TELAS DO CLIENTE
import 'pages/clientes/home.dart';
import 'pages/clientes/minhas_manifestacoes.dart';
import 'pages/clientes/perfil.dart';
import 'pages/clientes/novo_chamado.dart'; // Corrigido
import 'pages/clientes/novo_alerta.dart'; // Corrigido (se o arquivo for novo_alerta.dart, avise)
import 'pages/clientes/nova_indicacao_cliente.dart';
import 'pages/clientes/nova_solicitacao_orcamento.dart';
import 'pages/clientes/nova_reclamacao.dart';
import 'pages/clientes/novo_elogio.dart';
import 'pages/clientes/nova_sugestao.dart';

// TELAS DO ADMINISTRADOR (ADM)
import 'pages/adm/home_adm.dart';
import 'pages/adm/perfil_adm.dart';
import 'pages/adm/chamado_adm.dart';
import 'pages/adm/reclamacao_adm.dart';
import 'pages/adm/sugestao_adm.dart';
import 'pages/adm/elogios_adm.dart';
import 'pages/adm/indicacao_cliente_adm.dart';
import 'pages/adm/solicitacao_orcamento_adm.dart';
import 'pages/adm/alertas_protepac_adm.dart';
import 'pages/adm/adicionar_cliente.dart';
import 'pages/adm/editar_cliente.dart';

void main() => runApp(ProtepacApp());

class ProtepacApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Protepac',
      debugShowCheckedModeBanner: false,
      
      // Tema Global
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF181883), // Azul Protepac
        
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF181883),
          secondary: Color(0xFFFF9900), // Laranja Protepac
          surface: Colors.white,
        ),
        
        // Define a fonte padrão (opcional, se quiser mudar no futuro)
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF333333)),
        ),
        
        // Estilo padrão da AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF181883)),
          titleTextStyle: TextStyle(
            color: Color(0xFF181883),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Rota Inicial
      initialRoute: '/login', // Geralmente começa no Login

      // Gerenciador de Rotas
      onGenerateRoute: (settings) {
        switch (settings.name) {
          
          // --- ROTAS DE AUTENTICAÇÃO ---
          case '/login':
            return MaterialPageRoute(builder: (_) => LoginPage());
          case '/primeiro_login':
            return MaterialPageRoute(builder: (_) => PrimeiroLoginPage());
          case '/esqueci_senha':
            return MaterialPageRoute(builder: (_) => EsqueciSenhaPage());

          // --- ROTAS DO CLIENTE ---
          case '/home':
            return MaterialPageRoute(builder: (_) => HomePage());
          case '/perfil':
            return MaterialPageRoute(builder: (_) => PerfilPage());
          case '/minhas_manifestacoes':
            return MaterialPageRoute(builder: (_) => MinhasManifestacoesPage());
          
          // Formulários do Cliente
          case '/novo_chamado':
            return MaterialPageRoute(builder: (_) => NovoChamadoTecnicoPage());
          case '/novo_alerta': // Ou '/novo_alerta' dependendo do nome do arquivo
            return MaterialPageRoute(builder: (_) => NovoAvisoSegurancaPage());
          case '/nova_indicacao_cliente':
            return MaterialPageRoute(builder: (_) => NovaIndicacaoClientePage());
          case '/nova_solicitacao_orcamento':
            return MaterialPageRoute(builder: (_) => NovaSolicitacaoOrcamentoPage());
          case '/nova_reclamacao':
            return MaterialPageRoute(builder: (_) => NovaReclamacaoPage());
          case '/novo_elogio':
            return MaterialPageRoute(builder: (_) => NovoElogioPage());
          case '/nova_sugestao':
            return MaterialPageRoute(builder: (_) => NovaSugestaoPage());

          // --- ROTAS DO ADMINISTRADOR ---
          case '/home_adm':
            return MaterialPageRoute(builder: (_) => HomeAdmPage());
          case '/perfil_adm':
            return MaterialPageRoute(builder: (_) => PerfilAdmPage());
          
          // Gestão ADM
          case '/chamado_adm':
            return MaterialPageRoute(builder: (_) => ChamadoAdmPage());
          case '/reclamacao_adm':
            return MaterialPageRoute(builder: (_) => ReclamacaoAdmPage());
          case '/sugestao_adm':
            return MaterialPageRoute(builder: (_) => SugestaoAdmPage());
          case '/elogios_adm':
            return MaterialPageRoute(builder: (_) => ElogiosAdmPage());
          case '/indicacao_cliente_adm':
            return MaterialPageRoute(builder: (_) => IndicacaoClienteAdmPage());
          case '/solicitacao_orcamento_adm':
            return MaterialPageRoute(builder: (_) => SolicitacaoOrcamentoAdmPage());
          case '/alertas_protepac_adm':
            return MaterialPageRoute(builder: (_) => AlertasProtepacAdmPage());
          
          // Gestão de Clientes (CRUD)
          case '/adicionar_cliente':
            return MaterialPageRoute(builder: (_) => AdicionarAdmPage());
          case '/editar_cliente':
            return MaterialPageRoute(builder: (_) => EditarClientePage());

          // Rota padrão para erro (404)
          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text('Rota não encontrada: ${settings.name}'),
                ),
              ),
            );
        }
      },
    );
  }
}