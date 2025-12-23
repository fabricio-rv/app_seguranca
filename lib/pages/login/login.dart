import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController docController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool senhaVisivel = false;

  String tipoDoc = 'CPF'; // Padrão

  String get _labelDoc => tipoDoc == 'CPF' ? 'CPF' : 'CNPJ';
  MaskedInputFormatter get _mask => tipoDoc == 'CPF'
      ? MaskedInputFormatter('###.###.###-##')
      : MaskedInputFormatter('##.###.###/####-##');
  int get _maxLength => tipoDoc == 'CPF' ? 14 : 18;

  void _fazerLogin() {
    String doc = docController.text.trim();
    String senha = senhaController.text.trim();

    // CPF Usuário comum → Home
    if (doc == '123.456.789-00' && senha == '1234') {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    // CPF ADM → Manifestacoes Geral
    if (doc == '987.654.321-00' && senha == '1234') {
      Navigator.pushReplacementNamed(
        context,
        '/home_adm',
        arguments: {'role': 'adm'},
      );
      return;
    }

    // CPF que exige Primeiro Login
    if (doc == '123.456.790-00' && senha == '1234') {
      Navigator.pushReplacementNamed(
        context,
        '/primeiro_login',
        arguments: {'doc': doc}, // passa o doc pra próxima tela
      );
      return;
    }

    // Senha errada ou doc não reconhecido
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Erro'),
        content: Text('${_labelDoc} ou senha inválidos!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 120, fit: BoxFit.contain),
              const SizedBox(height: 24),
              // Dropdown CPF/CNPJ acima do campo
              Align(
                alignment: Alignment.centerLeft,
                child: DropdownButton<String>(
                  value: tipoDoc,
                  underline: SizedBox(),
                  items: [
                    DropdownMenuItem(value: 'CPF', child: Text('CPF')),
                    DropdownMenuItem(value: 'CNPJ', child: Text('CNPJ')),
                  ],
                  onChanged: (value) {
                    if (value != null && value != tipoDoc) {
                      setState(() {
                        tipoDoc = value;
                        docController.clear();
                      });
                    }
                  },
                  style: TextStyle(
                    color: Color(0xFFFF9900),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  icon: Icon(Icons.arrow_drop_down, color: Color(0xFFFF9900)),
                  dropdownColor: Colors.white,
                ),
              ),
              TextField(
                controller: docController,
                keyboardType: TextInputType.number,
                maxLength: _maxLength,
                inputFormatters: [_mask],
                style: TextStyle(color: Color(0xFF181883), fontSize: 16),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Color(0xFFFFD700), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Color(0xFFFFD700),
                      width: 2.2,
                    ),
                  ),
                  hintText: tipoDoc == 'CPF'
                      ? '000.000.000-00'
                      : '00.000.000/0000-00',
                ),
              ),

              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Senha',
                  style: TextStyle(
                    color: Color(0xFFFF9900),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: senhaController,
                obscureText: !senhaVisivel,
                style: TextStyle(color: Color(0xFF181883), fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Color(0xFFFFD700), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Color(0xFFFFD700),
                      width: 2.2,
                    ),
                  ),
                  hintText: 'Digite sua Senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      senhaVisivel ? Icons.visibility : Icons.visibility_off,
                      color: Color(0xFF181883),
                    ),
                    onPressed: () {
                      setState(() {
                        senhaVisivel = !senhaVisivel;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _fazerLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD700),
                    foregroundColor: Color(0xFF181883),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 1.2,
                    ),
                  ),
                  child: Text('Logar'),
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/esqueci_senha'),
                child: Text(
                  'Esqueceu sua senha?',
                  style: TextStyle(
                    color: Color(0xFF181883),
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
