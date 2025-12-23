// lib/pages/nova_indicacao_cliente.dart

import 'package:flutter/material.dart';
import '../../widgets/modal_mensagem_pos_envio.dart';

class NovaIndicacaoClientePage extends StatefulWidget {
  const NovaIndicacaoClientePage({Key? key}) : super(key: key);

  @override
  State<NovaIndicacaoClientePage> createState() =>
      _NovaIndicacaoClientePageState();
}

class _NovaIndicacaoClientePageState extends State<NovaIndicacaoClientePage> {
  bool cftv = false;
  bool alarme = false;
  bool comercial = false;
  bool residencial = false;

  // novos "Outro"
  bool outroSistema = false;
  bool outroCategoria = false;

  bool enviando = false;

  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();

  final _controllerOutroSistema = TextEditingController();
  final _controllerOutroCategoria = TextEditingController();

  bool get formValido {
    final nomeOk = _nomeController.text.trim().isNotEmpty;
    final telefoneOk = _telefoneController.text.trim().isNotEmpty;

    final grupo1 = cftv || alarme || outroSistema;
    final grupo2 = comercial || residencial || outroCategoria;

    final outroSistemaOk =
        !outroSistema || _controllerOutroSistema.text.trim().isNotEmpty;
    final outroCategoriaOk =
        !outroCategoria || _controllerOutroCategoria.text.trim().isNotEmpty;

    return nomeOk &&
        telefoneOk &&
        grupo1 &&
        grupo2 &&
        outroSistemaOk &&
        outroCategoriaOk;
  }

  void _enviar() {
    if (!formValido) {
      showDialog(
        context: context,
        builder: (_) => ModalMensagemPosEnvio(
          tipo: MensagemPosEnvioTipo.faltando,
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
                    'Por gentileza, informe os dados da pessoa indicada, e nossa equipe entrará em contato.',
                    style: TextStyle(
                      color: azul,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Nome
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nome completo',
                      style: TextStyle(
                        color: azul,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _nomeController,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() {}),
                    decoration: _inputDecoration(
                      laranja,
                      azul,
                      'Digite aqui...',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Telefone
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Telefone',
                      style: TextStyle(
                        color: azul,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _telefoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) => setState(() {}),
                    decoration: _inputDecoration(
                      laranja,
                      azul,
                      'Digite aqui...',
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tipo de Sistema
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tipo de sistema:',
                      style: TextStyle(
                        color: azul,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _CheckBoxTile(
                    value: cftv,
                    onChanged: (val) => setState(() => cftv = val!),
                    text: 'Câmera',
                    azul: azul,
                    laranja: laranja,
                  ),
                  const SizedBox(height: 8),
                  _CheckBoxTile(
                    value: alarme,
                    onChanged: (val) => setState(() => alarme = val!),
                    text: 'Alarme',
                    azul: azul,
                    laranja: laranja,
                  ),
                  const SizedBox(height: 8),
                  _CheckBoxTile(
                    value: outroSistema,
                    onChanged: (val) => setState(() => outroSistema = val!),
                    text: 'Outros',
                    azul: azul,
                    laranja: laranja,
                  ),
                  if (outroSistema)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextField(
                        controller: _controllerOutroSistema,
                        minLines: 2,
                        maxLines: null,
                        onChanged: (_) => setState(() {}),
                        decoration: _inputDecoration(
                          laranja,
                          azul,
                          'Descreva outro sistema...',
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Categoria
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Categoria:',
                      style: TextStyle(
                        color: azul,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _CheckBoxTile(
                    value: comercial,
                    onChanged: (val) => setState(() => comercial = val!),
                    text: 'Comercial',
                    azul: azul,
                    laranja: laranja,
                  ),
                  const SizedBox(height: 8),
                  _CheckBoxTile(
                    value: residencial,
                    onChanged: (val) => setState(() => residencial = val!),
                    text: 'Residencial',
                    azul: azul,
                    laranja: laranja,
                  ),
                  const SizedBox(height: 8),
                  _CheckBoxTile(
                    value: outroCategoria,
                    onChanged: (val) => setState(() => outroCategoria = val!),
                    text: 'Outros',
                    azul: azul,
                    laranja: laranja,
                  ),
                  if (outroCategoria)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextField(
                        controller: _controllerOutroCategoria,
                        minLines: 2,
                        maxLines: null,
                        onChanged: (_) => setState(() {}),
                        decoration: _inputDecoration(
                          laranja,
                          azul,
                          'Descreva outra categoria...',
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Botão Enviar
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
                          onPressed: (!enviando && formValido) ? _enviar : null,
                          child: enviando
                              ? const SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Color(0xFF181883),
                                  ),
                                )
                              : const Text('Enviar'),
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

  InputDecoration _inputDecoration(Color laranja, Color azul, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: azul),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: laranja, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: laranja, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: laranja, width: 2.2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      margin: const EdgeInsets.symmetric(vertical: 2),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
