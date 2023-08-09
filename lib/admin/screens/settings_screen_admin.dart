// ignore_for_file: deprecated_member_use, unused_element, avoid_print, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

import 'package:serve_bem_app/admin/blocs/pedidos_admin_bloc.dart';
import 'package:serve_bem_app/admin/blocs/settings_admin_bloc.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

class SettingsScrennADM extends StatefulWidget {
  const SettingsScrennADM({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsScrennADM> createState() => _SettingsScrennADMState();
}

class _SettingsScrennADMState extends State<SettingsScrennADM> {
  final _settingsBloc = SettingBloc();

  final _timeController = TextEditingController();

  final _pricePequenaController = TextEditingController();
  final _priceMediaController = TextEditingController();
  final _priceGrandeController = TextEditingController();

  final _pricePequenaFreteController = TextEditingController();
  final _priceMediaFreteController = TextEditingController();
  final _priceGrandeFreteController = TextEditingController();

  final _telefoneController = TextEditingController();
  final _localizacaoController = TextEditingController();

  void clear() {
    _pricePequenaController.clear();
    _priceMediaController.clear();
    _priceGrandeController.clear();

    _pricePequenaFreteController.clear();
    _priceMediaFreteController.clear();
    _priceGrandeFreteController.clear();

    _telefoneController.clear();
    _localizacaoController.clear();
  }

  final _startTime = TextEditingController();
  final _closeTime = TextEditingController();
  final _entregaTime = TextEditingController();

  final _pedidosBloc = PedidosBloc();

  String tamanho = "quantP";

  // final _pratoPrincipalController = TextEditingController();
  // final _guarnicaoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _settingsBloc.outState.listen((event) {
      switch (event) {
        case SettingsState.SUCCESS:
          _result(color: Colors.green, text: "Configurações Atualizadas!");
          clear();
          break;
        case SettingsState.FAIL:
          _result(color: Colors.red, text: "Erro ao Atualizar Configurações!");
          break;
        case SettingsState.IDLE:
          break;
        case SettingsState.LOADING:
          break;
      }
    });
  }

  _result({required Color color, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(text,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.grey.shade800,
        title: Text(
          "Configurações",
          style: TextStyle(
              color: MyColors.backGround,
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontWeight: FontWeight.w400),
        ),
      ),
      body: StreamBuilder<SettingsState>(
        stream: _settingsBloc.outState,
        initialData: SettingsState.IDLE,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case SettingsState.LOADING:
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                ),
              );
            case SettingsState.SUCCESS:

            case SettingsState.FAIL:
            case SettingsState.IDLE:
            default:
              return StreamBuilder<Map<String, dynamic>>(
                  stream: _settingsBloc.outSettings,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(MyColors.backGround),
                        ),
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nenhuma Configuração Definida',
                          style: TextStyle(color: MyColors.backGround),
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            _card(
                              height: 0.2,
                              title: "TEMPO MÍNIMO DE PREPARO:",
                              content: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          controller: _timeController,
                                          decoration: InputDecoration(
                                            icon: const Icon(
                                              Icons.access_time_filled,
                                              color: MyColors.backGround,
                                            ),
                                            hintText: "Digite um novo tempo",
                                            hintStyle: const TextStyle(
                                                color: MyColors.backGround),
                                            label: Text(
                                              "Tempo de Preparo: ${snapshot.data!['tempoPreparo']} min",
                                              style: const TextStyle(
                                                  color: MyColors.backGround),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      height: 50,
                                      child: RaisedButton(
                                        onPressed: () {
                                          if (_timeController
                                                      .text.codeUnits.length <=
                                                  2 &&
                                              _timeController.text.isNotEmpty) {
                                            _settingsBloc.changeSettings(
                                              key: 'tempoPreparo',
                                              newValue: int.parse(
                                                _timeController.text,
                                              ),
                                            );
                                          } else {
                                            _result(
                                                color: Colors.red,
                                                text:
                                                    "Digite um tempo válido!");
                                          }
                                        },
                                        color: MyColors.backGround,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Center(
                                          child: Text(
                                            "Definir",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.035),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            _card(
                              height: 0.3,
                              title: "INFORMAÇÕES RESTAURANTE",
                              content: Column(
                                children: [
                                  _priceField(
                                    hintText: "Digite um novo número",
                                    labelText:
                                        "Contato: ${snapshot.data!['telefoneContato']}",
                                    keyChange: 'telefoneContato',
                                    controller: _telefoneController,
                                    icon: Icons.phone_android,
                                    choice: true,
                                  ),
                                  _priceField(
                                    hintText: "Insira um novo Endereço",
                                    labelText: "Insira o link do Google Maps",
                                    keyChange: 'localizacao',
                                    controller: _localizacaoController,
                                    icon: Icons.location_on_sharp,
                                    textInputType: TextInputType.streetAddress,
                                    choice: true,
                                  ),
                                ],
                              ),
                            ),
                            _card(
                              height: 0.2,
                              title: "HORARIO DE ENTREGA E DE RETIRADA:",
                              content: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 2.0),
                                child: _timeField(
                                    buttonTitle:
                                        'Horario Entrega: A partir das ${snapshot.data!['horarioEntrega']}',
                                    selectedTime: _entregaTime,
                                    key: "horarioEntrega"),
                              ),
                            ),
                            _card(
                                height: 0.32,
                                title: "HORÁRIO DE FUNCIONAMENTO",
                                content: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _timeField(
                                        buttonTitle:
                                            'Horário de Abertura: ${snapshot.data!['horarioA']}',
                                        selectedTime: _startTime,
                                        key: 'horarioA'),
                                    _timeField(
                                        buttonTitle:
                                            "Horário de Fechamento: ${snapshot.data!['horarioF']}",
                                        selectedTime: _closeTime,
                                        key: 'horarioF'),
                                  ],
                                )),
                            _card(
                              height: 0.22,
                              title: "FUNCIONAMENTO:",
                              content: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: RaisedButton(
                                  onPressed: () {
                                    if (snapshot.data!['funcionamento'] ==
                                        "FECHADO") {
                                      if (_pedidosBloc
                                              .pratosPrincipais.isEmpty ||
                                          _pedidosBloc.guarnicao.isEmpty) {
                                        _result(
                                            color: Colors.red,
                                            text:
                                                "O cardápio está vazio! \nAdicione pelo menos um prato principal e uma guarnição ao cardápio primeiro!");
                                      } else {
                                        _settingsBloc.changeSettings(
                                          key: "funcionamento",
                                          newValue: snapshot
                                                  .data!['funcionamento']
                                                  .toString()
                                                  .contains("ABERTO")
                                              ? "FECHADO"
                                              : "ABERTO",
                                        );
                                        _settingsBloc.changeSettings(
                                            key: "funcionamentoState",
                                            newValue: snapshot
                                                    .data!['funcionamento']
                                                    .toString()
                                                    .contains("ABERTO")
                                                ? false
                                                : true);
                                      }
                                    } else {
                                      _settingsBloc.changeSettings(
                                        key: "funcionamento",
                                        newValue: snapshot
                                                .data!['funcionamento']
                                                .toString()
                                                .contains("ABERTO")
                                            ? "FECHADO"
                                            : "ABERTO",
                                      );
                                      _settingsBloc.changeSettings(
                                          key: "funcionamentoState",
                                          newValue: snapshot
                                                  .data!['funcionamento']
                                                  .toString()
                                                  .contains("ABERTO")
                                              ? false
                                              : true);
                                    }
                                  },
                                  color: MyColors.backGround,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                    child: Text(
                                      "${snapshot.data!['funcionamento']}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                    ),
                                  ),
                                ),
                              ),
                            ),/*
                            _card(
                              height: 0.4,
                              title: "INFORMAÇÕES TAMANHOS:",
                              content: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  DropdownButton<String>(
                                      hint: const Text(
                                        "Selecione o Tamanho:",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      alignment: Alignment.center,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      dropdownColor: Colors.grey.shade600,
                                      iconEnabledColor: Colors.white,
                                      value: tamanho,
                                      items: const [
                                        DropdownMenuItem<String>(
                                          child: Text("Pequena"),
                                          value: "quantP",
                                        ),
                                        DropdownMenuItem<String>(
                                          child: Text("Média"),
                                          value: "quantM",
                                        ),
                                        DropdownMenuItem<String>(
                                          child: Text("Grande"),
                                          value: "quantG",
                                        ),
                                      ],
                                      onChanged: (String? value) {
                                        setState(() {
                                          tamanho = value!;
                                        });
                                      }),
                                  _priceField(
                                    hintText: "Digite uma nova Quantidade",
                                    labelText: "N° Pratos Principais:",
                                    keyChange: tamanho,
                                    controller: _pratoPrincipalController,
                                  ),
                                  _priceField(
                                    hintText: "Digite uma nova Quantidade",
                                    labelText: "N° Guarnições:",
                                    keyChange: tamanho,
                                    controller: _guarnicaoController,
                                  ),
                                ],
                              ),
                            ),
                            */
                            _card(
                              height: 0.4,
                              title: "PREÇOS DAS MARMITAS:",
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _priceField(
                                    hintText: "Digite o novo Preço",
                                    labelText:
                                        "Pequena: R\$${snapshot.data!['precoP']},00",
                                    controller: _pricePequenaController,
                                    keyChange: 'precoP',
                                  ),
                                  _priceField(
                                    hintText: "Digite o novo Preço",
                                    labelText:
                                        "Média: R\$${snapshot.data!['precoM']},00",
                                    controller: _priceMediaController,
                                    keyChange: 'precoM',
                                  ),
                                  _priceField(
                                    hintText: "Digite o novo Preço",
                                    labelText:
                                        "Grande: R\$${snapshot.data!['precoG']},00",
                                    controller: _priceGrandeController,
                                    keyChange: 'precoG',
                                  ),
                                ],
                              ),
                            ),
                            _card(
                              height: 0.4,
                              title: "PREÇOS DOS FRETES:",
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _priceField(
                                    hintText: "Digite o novo Preço",
                                    labelText:
                                        "Pequena: R\$${snapshot.data!['entregaP']},00",
                                    controller: _pricePequenaFreteController,
                                    keyChange: 'entregaP',
                                  ),
                                  _priceField(
                                    hintText: "Digite o novo Preço",
                                    labelText:
                                        "Média: R\$${snapshot.data!['entregaM']},00",
                                    controller: _priceMediaFreteController,
                                    keyChange: 'entregaM',
                                  ),
                                  _priceField(
                                    hintText: "Digite o novo Preço",
                                    labelText:
                                        "Grande: R\$${snapshot.data!['entregaG']},00",
                                    controller: _priceGrandeFreteController,
                                    keyChange: 'entregaG',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  });
          }
        },
      ),
    );
  }

  Widget _timeField(
          {required String buttonTitle,
          required TextEditingController selectedTime,
          required String key}) =>
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.10,
              width: MediaQuery.of(context).size.width * 0.3,
              child: OutlineButton(
                onPressed: () async {
                  var time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  //print(selectedTime);
                  if (time != null) {
                    setState(() {
                      selectedTime.text = time.format(context);
                    });
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                textColor: MyColors.backGround,
                color: MyColors.backGround,
                borderSide: const BorderSide(
                  color: MyColors.backGround,
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
                child: Center(
                  child: Text(
                    selectedTime.text.isEmpty
                        ? buttonTitle
                        : "Novo Horário: ${selectedTime.text}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: MyColors.backGround,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 100,
              height: 50,
              child: RaisedButton(
                onPressed: () {
                  if (selectedTime.text.isNotEmpty) {
                    _settingsBloc.changeSettings(
                        key: key, newValue: selectedTime.text);
                    selectedTime.clear();
                  } else {
                    _result(color: Colors.red, text: "Horário Inválido!");
                  }
                },
                color: MyColors.backGround,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    "Definir",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: MediaQuery.of(context).size.width * 0.035),
                  ),
                ),
              ),
            )
          ],
        ),
      );

  Widget _priceField({
    required String hintText,
    required String labelText,
    required String keyChange,
    required TextEditingController controller,
    IconData? icon,
    TextInputType? textInputType,
    bool? choice = false,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextField(
                  keyboardType: textInputType ?? TextInputType.number,
                  controller: controller,
                  decoration: InputDecoration(
                    icon: Icon(
                      icon ?? Icons.dinner_dining_rounded,
                      color: MyColors.backGround,
                    ),
                    hintText: hintText,
                    hintStyle: const TextStyle(color: MyColors.backGround),
                    label: Text(
                      labelText,
                      style: const TextStyle(color: MyColors.backGround),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 100,
              height: 50,
              child: RaisedButton(
                onPressed: choice == false
                    ? () {
                        if (controller.text.isNotEmpty &&
                            controller.text.codeUnits.length <= 2) {
                          _settingsBloc.changeSettings(
                              key: keyChange,
                              newValue: int.parse(controller.text));
                        } else {
                          _result(
                              color: Colors.red,
                              text: "Digite um valor válido");
                        }
                      }
                    : () {
                        if (controller.text.isNotEmpty) {
                          _settingsBloc.changeSettings(
                              key: keyChange, newValue: controller.text);
                        } else {
                          _result(
                              color: Colors.red,
                              text: "Digite um valor válido");
                        }
                      },
                color: MyColors.backGround,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    "Definir",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: MediaQuery.of(context).size.width * 0.035),
                  ),
                ),
              ),
            )
          ],
        ),
      );

  Widget _card(
          {required double height,
          required String title,
          required Widget content}) =>
      Container(
        margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
        height: MediaQuery.of(context).size.height * height,
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 16.0,
          color: Colors.grey.shade700,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // height: height / 1.2,
                margin:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
                alignment: Alignment.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
              ),
              Expanded(child: content),
            ],
          ),
        ),
      );
}
