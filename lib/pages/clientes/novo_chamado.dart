// lib/pages/novo_chamado_tecnico.dart

import 'package:flutter/material.dart';
import '../../widgets/modal_mensagem_pos_envio.dart';
import 'package:flutter/services.dart';

class NovoChamadoTecnicoPage extends StatefulWidget {
  const NovoChamadoTecnicoPage({Key? key}) : super(key: key);

  @override
  State<NovoChamadoTecnicoPage> createState() => _NovoChamadoTecnicoPageState();
}

class _NovoChamadoTecnicoPageState extends State<NovoChamadoTecnicoPage> {
  bool cftv = false;
  bool alarme = false;
  bool outro = false;

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerOutro = TextEditingController();

  static const int maxLength = 500;
  static const int minLength = 2;

  bool get _formValido {
    // Precisa ter pelo menos 1 check
    final hasCheck = cftv || alarme || outro;

    // Regra para descrição principal
    final textoPrincipalOk = _controller.text.trim().length >= minLength;

    // Se for "Outro", precisa também escrever algo
    final outroOk = !outro || _controllerOutro.text.trim().isNotEmpty;

    // ✅ Se marcou "Outro", exige os dois textos
    if (outro) {
      return hasCheck && textoPrincipalOk && outroOk;
    }

    // ✅ Se marcou apenas câmera/alarme, exige só o texto principal
    return hasCheck && textoPrincipalOk;
  }

  void _enviar() {
    if (!_formValido) {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(
          context,
        ).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder:
            (
              BuildContext buildContext,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return Center(
                child: ModalMensagemPosEnvio(
                  tipo: MensagemPosEnvioTipo.faltando,
                  onVoltar: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                ),
              );
            },
      );
      return;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder:
          (
            BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return Center(
              child: ModalMensagemPosEnvio(
                tipo: MensagemPosEnvioTipo.sucesso,
                onVerManif: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.of(
                    context,
                  ).pushReplacementNamed('/minhas_manifestacoes');
                },
                onProsseguir: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
            );
          },
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
            automaticallyImplyLeading: false, // removemos o padrão
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: false, // não fixa, rola junto
            floating: false,
            snap: false,
            expandedHeight: 70,
            flexibleSpace: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: azul),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    '', // Deixe vazio se não quer título na barra
                    style: TextStyle(
                      color: azul,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
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
                    'Por gentileza, especifique sua necessidade de chamado técnico, manutenção, revisão que nossa equipe entrará em contato.',
                    style: TextStyle(
                      color: azul,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _CheckBoxTile(
                    value: cftv,
                    onChanged: (val) => setState(() => cftv = val!),
                    text: 'Câmera',
                    azul: azul,
                    laranja: laranja,
                  ),
                  const SizedBox(height: 16),
                  _CheckBoxTile(
                    value: alarme,
                    onChanged: (val) => setState(() => alarme = val!),
                    text: 'Alarme',
                    azul: azul,
                    laranja: laranja,
                  ),
                  const SizedBox(height: 16),

                  _CheckBoxTile(
                    value: outro,
                    onChanged: (val) => setState(() => outro = val!),
                    text: 'Outros',
                    azul: azul,
                    laranja: laranja,
                  ),
                  if (outro) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controllerOutro,
                      minLines: 2,
                      maxLines: null, // cresce conforme digita
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(color: azul, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Descreva outro tipo de chamado...',
                        hintStyle: TextStyle(color: azul),
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
                        contentPadding: EdgeInsets.fromLTRB(24, 14, 24, 14),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Descreva seu Chamado Técnico, Manutenção, Revisão',
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
                          onPressed: _formValido ? _enviar : null,
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

class _CheckBoxTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;
  final Color azul;
  final Color laranja;

  const _CheckBoxTile({
    required this.value,
    required this.onChanged,
    required this.text,
    required this.azul,
    required this.laranja,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: laranja, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          text,
          style: TextStyle(
            color: azul,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        activeColor: laranja,
        checkColor: azul,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
