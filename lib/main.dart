import 'package:flutter/material.dart';

// CLIENTES
import 'pages/login/esqueci_senha.dart';
import 'pages/clientes/home.dart';
import 'pages/login/login.dart';
import 'pages/clientes/minhas_manifestacoes.dart';
import 'pages/clientes/nova_indicacao_cliente.dart';
import 'pages/clientes/nova_solicitacao_orcamento.dart';
import 'pages/clientes/nova_sugestao.dart';
import 'pages/clientes/novo_alerta.dart';
import 'pages/clientes/novo_chamado.dart';
import 'pages/clientes/novo_elogio.dart';
import 'pages/clientes/nova_reclamacao.dart';

// PERFIL
import 'pages/clientes/perfil.dart';

// LOGIN
import 'pages/login/primeiro_login.dart';

// ADM
import 'pages/adm/home_adm.dart';
import 'pages/adm/chamado_adm.dart';
import 'pages/adm/reclamacao_adm.dart';
import 'pages/adm/sugestao_adm.dart';
import 'pages/adm/indicacao_cliente_adm.dart';
import 'pages/adm/solicitacao_orcamento_adm.dart';
import 'pages/adm/alertas_protepac_adm.dart';
import 'pages/clientes/manifestacoes_geral.dart';
import 'pages/adm/elogios_adm.dart';
import 'pages/adm/perfil_adm.dart';
import 'pages/adm/adicionar_cliente.dart';
import 'pages/adm/editar_cliente.dart';

void main() => runApp(ProtepacApp());

class ProtepacApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Protepac',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF181883), // azul
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF181883), // azul
          secondary: Color(0xFFFF9900), // laranja
          surface: Colors.white,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      ),
      initialRoute: '/home_adm',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          // LOGIN / PERFIL
          case '/login':
            return MaterialPageRoute(builder: (_) => LoginPage());
          case '/primeiro_login':
            return MaterialPageRoute(builder: (_) => PrimeiroLoginPage());
          case '/esqueci_senha':
            return MaterialPageRoute(builder: (_) => EsqueciSenhaPage());
          case '/perfil':
            return MaterialPageRoute(builder: (_) => PerfilPage());

          // CLIENTES
          case '/home':
            return MaterialPageRoute(builder: (_) => HomePage());
          case '/minhas_manifestacoes':
            return MaterialPageRoute(builder: (_) => MinhasManifestacoesPage());
          case '/nova_indicacao_cliente':
            return MaterialPageRoute(
              builder: (_) => NovaIndicacaoClientePage(),
            );
          case '/nova_solicitacao_orcamento':
            return MaterialPageRoute(
              builder: (_) => NovaSolicitacaoOrcamentoPage(),
            );
          case '/nova_sugestao':
            return MaterialPageRoute(builder: (_) => NovaSugestaoPage());
          case '/novo_aviso_seguranca':
            return MaterialPageRoute(builder: (_) => NovoAvisoSegurancaPage());
          case '/novo_chamado_tecnico':
            return MaterialPageRoute(builder: (_) => NovoChamadoTecnicoPage());
          case '/novo_elogio':
            return MaterialPageRoute(builder: (_) => NovoElogioPage());
          case '/nova_reclamacao':
            return MaterialPageRoute(builder: (_) => NovaReclamacaoPage());

          // ADM
          case '/home_adm':
            return MaterialPageRoute(builder: (_) => HomeAdmPage());
          case '/chamado_adm':
            return MaterialPageRoute(builder: (_) => ChamadoAdmPage());
          case '/reclamacao_adm':
            return MaterialPageRoute(builder: (_) => ReclamacaoAdmPage());
          case '/sugestao_adm':
            return MaterialPageRoute(builder: (_) => SugestaoAdmPage());
          case '/indicacao_cliente_adm':
            return MaterialPageRoute(builder: (_) => IndicacaoClienteAdmPage());
          case '/solicitacao_orcamento_adm':
            return MaterialPageRoute(
              builder: (_) => SolicitacaoOrcamentoAdmPage(),
            );
          case '/alertas_protepac_adm':
            return MaterialPageRoute(builder: (_) => AlertasProtepacAdmPage());
          case '/elogios_adm':
            return MaterialPageRoute(builder: (_) => ElogiosAdmPage());
          case '/manifestacoes_geral':
            return MaterialPageRoute(builder: (_) => ManifestacoesGeralPage());
          case '/perfil_adm':
            return MaterialPageRoute(builder: (_) => PerfilAdmPage());
          case '/perfil_adm':
            return MaterialPageRoute(builder: (_) => PerfilAdmPage());
          case '/editar_cliente':
            return MaterialPageRoute(builder: (_) => EditarClientePage());
          case '/adicionar_cliente':
            return MaterialPageRoute(builder: (_) => AdicionarAdmPage());
        }
        return null;
      },
    );
  }
}
