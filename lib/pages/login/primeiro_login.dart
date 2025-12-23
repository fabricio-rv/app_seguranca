// lib/pages/primeiro_login.dart
import 'package:flutter/material.dart';
import 'dart:async';

class PrimeiroLoginPage extends StatefulWidget {
  final String? doc;
  const PrimeiroLoginPage({Key? key, this.doc}) : super(key: key);

  @override
  _PrimeiroLoginPageState createState() => _PrimeiroLoginPageState();
}

class _PrimeiroLoginPageState extends State<PrimeiroLoginPage> {
  final TextEditingController smsController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmaSenhaController = TextEditingController();

  String cpf = "123.456.790-00"; // Mock (virá do Login)
  String numeroMascara = "(51) 9****-6445"; // Mock
  bool codigoValidado = false;
  String mensagem = "";

  Timer? _timer;
  int _tempoRestante = 0;

  @override
  void initState() {
    super.initState();
    if (widget.doc != null) {
      cpf = widget.doc!;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    smsController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmaSenhaController.dispose();
    super.dispose();
  }

  void enviarSMS() {
    setState(() {
      _tempoRestante = 60; // 1 minuto
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_tempoRestante > 0) {
        setState(() => _tempoRestante--);
      } else {
        timer.cancel();
      }
    });

    _showMsg("Código enviado para $numeroMascara");
  }

  void validarCodigo() {
    if (smsController.text == "1234") {
      setState(() => codigoValidado = true);
    } else {
      _showMsg("Código inválido!");
    }
  }

  void finalizarCadastro() {
    if (senhaController.text != confirmaSenhaController.text) {
      _showMsg("As senhas não coincidem.");
      return;
    }
    if (!emailController.text.contains("@")) {
      _showMsg("Digite um e-mail válido.");
      return;
    }
    _showMsg("Cadastro realizado com sucesso!");
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, "/home");
    });
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.orange),
    );
  }

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF181883);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              // 🔙 Arrow back
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: azul),
                  onPressed: () {
                    if (codigoValidado) {
                      setState(() => codigoValidado = false);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),

              // Dá respiro antes do conteúdo
              const SizedBox(height: 20),

              // =====================
              // Conteúdo central
              // =====================
              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // 👈 sobe o conteúdo
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),

                    // 🔹 Tela SMS
                    if (!codigoValidado) ...[
                      Text(
                        "Verificação via SMS",
                        style: TextStyle(
                          fontSize: 20,
                          color: azul,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "CPF: $cpf",
                        style: TextStyle(fontSize: 16, color: Colors.orange),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Enviamos um código para $numeroMascara",
                        style: TextStyle(fontSize: 16, color: azul),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: smsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Digite o código recebido",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFFFD700),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFFFD700),
                              width: 2.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: smsController.text.isEmpty
                              ? enviarSMS
                              : validarCodigo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD700),
                            foregroundColor: azul,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          child: Text(
                            smsController.text.isEmpty
                                ? "Enviar SMS"
                                : "Validar Código",
                          ),
                        ),
                      ),
                      if (_tempoRestante > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Reenvie em $_tempoRestante segundos",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                    ],

                    // 🔹 Tela Criar Senha
                    if (codigoValidado) ...[
                      Text(
                        "Crie sua nova senha",
                        style: TextStyle(
                          fontSize: 20,
                          color: azul,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: senhaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Nova senha",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFFFD700),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFFFD700),
                              width: 2.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: confirmaSenhaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Confirmar senha",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFFFD700),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFFFD700),
                              width: 2.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Digite seu e-mail de contato",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFFFD700),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFFFD700),
                              width: 2.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: finalizarCadastro,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD700),
                            foregroundColor: azul,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          child: const Text("Finalizar Cadastro"),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
