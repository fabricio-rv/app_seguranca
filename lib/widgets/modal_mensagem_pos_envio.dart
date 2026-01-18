import 'package:flutter/material.dart';

enum MensagemPosEnvioTipo { sucesso, erro, faltando }

class ModalMensagemPosEnvio extends StatelessWidget {
  final MensagemPosEnvioTipo tipo;
  final VoidCallback? onVerManif;
  final VoidCallback? onProsseguir;
  final VoidCallback? onTentarNovamente;
  final VoidCallback? onVoltar;
  final String? mensagemCustomizada;

  const ModalMensagemPosEnvio({
    Key? key,
    required this.tipo,
    this.onVerManif,
    this.onProsseguir,
    this.onTentarNovamente,
    this.onVoltar,
    this.mensagemCustomizada,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF181883);
    const laranja = Color(0xFFFF9900);

    String mensagem = '';
    Widget botoesWidget;

    if (tipo == MensagemPosEnvioTipo.sucesso) {
      mensagem =
          mensagemCustomizada ??
          'Agradecemos pela mensagem! Nossa equipe comercial entrará em contato em breve.';

      botoesWidget = LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 380) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ModalButton(
                  texto: 'Ver Manifestações',
                  corBorda: azul,
                  corTexto: laranja,
                  onPressed: onVerManif,
                ),
                const SizedBox(height: 12),
                _ModalButton(
                  texto: 'Prosseguir',
                  corBorda: laranja,
                  corTexto: azul,
                  onPressed: onProsseguir,
                ),
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ModalButton(
                  texto: 'Ver Manifestações',
                  corBorda: azul,
                  corTexto: laranja,
                  onPressed: onVerManif,
                ),
                const SizedBox(width: 12),
                _ModalButton(
                  texto: 'Prosseguir',
                  corBorda: laranja,
                  corTexto: azul,
                  onPressed: onProsseguir,
                ),
              ],
            );
          }
        },
      );
    } else if (tipo == MensagemPosEnvioTipo.erro) {
      mensagem = 'Erro ao enviar sua mensagem!';
      botoesWidget = Center(
        child: _ModalButton(
          texto: 'Tentar Novamente',
          corBorda: laranja,
          corTexto: azul,
          onPressed: onTentarNovamente,
        ),
      );
    } else {
      mensagem = 'Preencher os dados obrigatórios!';
      botoesWidget = SizedBox(
        width: double.infinity,
        child: _ModalButton(
          texto: 'Voltar',
          corBorda: laranja,
          corTexto: azul,
          onPressed: onVoltar,
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.white, // ✅ sempre branco
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              mensagem,
              style: const TextStyle(
                color: azul,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            botoesWidget,
          ],
        ),
      ),
    );
  }
}

class _ModalButton extends StatelessWidget {
  final String texto;
  final Color corBorda;
  final Color corTexto;
  final VoidCallback? onPressed;
  const _ModalButton({
    required this.texto,
    required this.corBorda,
    required this.corTexto,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: corTexto,
        side: BorderSide(color: corBorda, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white, // ✅ sempre branco
      ),
      onPressed: onPressed,
      child: Text(
        texto,
        textAlign: TextAlign.center,
        softWrap: true,
        overflow: TextOverflow.visible,
      ),
    );
  }
}
