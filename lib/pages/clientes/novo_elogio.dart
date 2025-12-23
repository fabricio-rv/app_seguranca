// lib/pages/novo_elogio.dart

import 'package:flutter/material.dart';
import '../../widgets/modal_mensagem_pos_envio.dart';
import 'package:flutter/services.dart';

class NovoElogioPage extends StatefulWidget {
  const NovoElogioPage({Key? key}) : super(key: key);

  @override
  State<NovoElogioPage> createState() => _NovoElogioPageState();
}

class _NovoElogioPageState extends State<NovoElogioPage> {
  final TextEditingController _controller = TextEditingController();
  static const int maxLength = 500;
  static const int minLength = 2;

  bool get _formValido => _controller.text.trim().length >= minLength;

  void _enviar() {
    if (!_formValido) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ModalMensagemPosEnvio(
          tipo: MensagemPosEnvioTipo.faltando,
          mensagemCustomizada:
              'Por favor, escreva pelo menos $minLength caracteres.',
          onVoltar: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ModalMensagemPosEnvio(
        tipo: MensagemPosEnvioTipo.sucesso,
        mensagemCustomizada:
            'Muito obrigado pelo seu elogio! Nossa equipe agradece.',
        onVerManif: () {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).pushReplacementNamed('/minhas_manifestacoes');
        },
        onProsseguir: () {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).pushReplacementNamed('/home');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF181883);
    final laranja = const Color(0xFFFF9900);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: false,
            floating: false,
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
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Escreva seu elogio para a Protepac.\nSua mensagem é muito importante para nós.',
                    style: TextStyle(
                      color: azul,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Deixe seu elogio para a Protepac',
                      style: TextStyle(
                        color: laranja,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      TextField(
                        controller: _controller,
                        minLines: 5,
                        maxLines: 16,
                        maxLength: maxLength,
                        style: TextStyle(color: azul, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Digite seu elogio aqui...',
                          hintStyle: TextStyle(color: azul.withOpacity(0.6)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(color: laranja, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(color: laranja, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(color: laranja, width: 2.2),
                          ),
                          contentPadding: const EdgeInsets.fromLTRB(
                            24,
                            12,
                            24,
                            45,
                          ),
                          counterText: '',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      Positioned(
                        bottom: 11,
                        right: 17,
                        child: Text(
                          '${_controller.text.length}/$maxLength',
                          style: TextStyle(fontSize: 12, color: azul),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: laranja,
                            foregroundColor: azul,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          onPressed: _formValido ? _enviar : null,
                          child: const Text('Enviar'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
