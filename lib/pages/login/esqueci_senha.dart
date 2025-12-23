// lib/pages/esqueci_senha.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EsqueciSenhaPage extends StatefulWidget {
  @override
  _EsqueciSenhaPageState createState() => _EsqueciSenhaPageState();
}

class _EsqueciSenhaPageState extends State<EsqueciSenhaPage> {
  final TextEditingController docController = TextEditingController();
  final TextEditingController smsController = TextEditingController();
  final TextEditingController novaSenhaController = TextEditingController();
  final TextEditingController confirmarSenhaController =
      TextEditingController();

  bool enviouSMS = false;
  bool codigoValidado = false;
  String tipoDoc = "CPF";
  String numeroMascara = "(51) 9****-6445"; // mockado

  @override
  void initState() {
    super.initState();
    docController.addListener(_formatarDoc);
  }

  @override
  void dispose() {
    docController.removeListener(_formatarDoc);
    docController.dispose();
    smsController.dispose();
    novaSenhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  // --- máscara CPF / CNPJ ---
  void _formatarDoc() {
    String clean = docController.text.replaceAll(RegExp(r'\D'), '');
    String formatted = "";

    if (tipoDoc == "CPF") {
      if (clean.length > 11) clean = clean.substring(0, 11);
      for (int i = 0; i < clean.length; i++) {
        if (i == 3 || i == 6) formatted += '.';
        if (i == 9) formatted += '-';
        formatted += clean[i];
      }
    } else {
      if (clean.length > 14) clean = clean.substring(0, 14);
      for (int i = 0; i < clean.length; i++) {
        if (i == 2 || i == 5) formatted += '.';
        if (i == 8) formatted += '/';
        if (i == 12) formatted += '-';
        formatted += clean[i];
      }
    }

    if (docController.text != formatted) {
      docController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void enviarSMS() {
    final cleanDoc = docController.text.replaceAll(RegExp(r'\D'), '');
    if (cleanDoc == "12345678900" || cleanDoc == "12345678000199") {
      setState(() => enviouSMS = true);
    } else {
      _showMsg("$tipoDoc não encontrado no sistema.");
    }
  }

  void validarCodigo() {
    if (smsController.text == "1234") {
      setState(() => codigoValidado = true);
    } else {
      _showMsg("Código inválido!");
    }
  }

  void alterarSenha() {
    if (novaSenhaController.text.isEmpty ||
        novaSenhaController.text != confirmarSenhaController.text) {
      _showMsg("As senhas não coincidem.");
      return;
    }
    _showMsg("Senha alterada com sucesso!");
    Navigator.pop(context);
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.orange),
    );
  }

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF181883);
    final laranja = const Color(0xFFFF9900);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 🔙 Flechinha azul
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: azul),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Logo
                    Image.asset(
                      "assets/logo.png",
                      height: 120,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 40),

                    // Etapa 1: CPF/CNPJ
                    if (!enviouSMS && !codigoValidado) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownButton<String>(
                          value: tipoDoc,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: "CPF", child: Text("CPF")),
                            DropdownMenuItem(
                              value: "CNPJ",
                              child: Text("CNPJ"),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                tipoDoc = value;
                                docController.clear();
                              });
                            }
                          },
                          style: TextStyle(
                            color: laranja,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          icon: Icon(Icons.arrow_drop_down, color: laranja),
                          dropdownColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: docController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: TextStyle(color: azul, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: tipoDoc == "CPF"
                              ? "000.000.000-00"
                              : "00.000.000/0000-00",
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: enviarSMS,
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
                          child: const Text("Enviar SMS"),
                        ),
                      ),
                    ],

                    // Etapa 2: Verificação SMS
                    if (enviouSMS && !codigoValidado) ...[
                      const SizedBox(height: 30),
                      Text(
                        "Verificação via SMS",
                        style: TextStyle(
                          color: azul,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Enviamos um código para $numeroMascara",
                        style: TextStyle(color: azul, fontSize: 16),
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: validarCodigo,
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
                          child: const Text("Validar Código"),
                        ),
                      ),
                    ],

                    // Etapa 3: Redefinição senha
                    if (codigoValidado) ...[
                      const SizedBox(height: 30),
                      Text(
                        "Redefina sua Senha",
                        style: TextStyle(
                          color: azul,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: novaSenhaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Nova Senha",
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
                        controller: confirmarSenhaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Confirmar Senha",
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
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: alterarSenha,
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
                          child: const Text("Alterar Senha"),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
