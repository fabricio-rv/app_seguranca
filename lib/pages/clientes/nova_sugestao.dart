import 'package:flutter/material.dart';
import '../../widgets/modal_mensagem_pos_envio.dart';
import 'package:flutter/services.dart';

class NovaSugestaoPage extends StatefulWidget {
  const NovaSugestaoPage({Key? key}) : super(key: key);

  @override
  State<NovaSugestaoPage> createState() => _NovaSugestaoPageState();
}

class _NovaSugestaoPageState extends State<NovaSugestaoPage> {
  final TextEditingController _controller = TextEditingController();
  static const int maxLength = 500;
  static const int minLength = 5;

  void _enviar() {
    if (_controller.text.trim().length < minLength) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ModalMensagemPosEnvio(
          tipo: MensagemPosEnvioTipo.faltando, // <-- Corrija aqui!
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
            'Agradecemos pela mensagem! Nossa equipe vai avaliar sua sugestão e qualquer coisa entrará em contato.',
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
    final azul = Color(0xFF181883);
    final laranja = Color(0xFFFF9900);

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
                    'Por gentileza, escreva sua sugestão, que será avaliada pela nossa equipe.',
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
                      'Deixe sua sugestão para a Protepac',
                      style: TextStyle(
                        color: laranja,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.left,
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
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        style: TextStyle(color: azul, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Digite aqui...',
                          hintStyle: TextStyle(color: Color(0xFF181883)),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(color: laranja, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(
                              color: Color(0xFFFFD700),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(
                              color: Color(0xFFFFD700),
                              width: 2.1,
                            ),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 45),
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
                      if (_controller.text.isNotEmpty &&
                          _controller.text.length < minLength)
                        Positioned(
                          bottom: 11,
                          left: 16,
                          child: Text(
                            'Mínimo $minLength caracteres',
                            style: TextStyle(
                              fontSize: 12,
                              color: azul,
                              fontWeight: FontWeight.bold,
                            ),
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
                            elevation: 0,
                          ),
                          onPressed: _controller.text.trim().length >= minLength
                              ? _enviar
                              : null,
                          child: const Text('Enviar'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
