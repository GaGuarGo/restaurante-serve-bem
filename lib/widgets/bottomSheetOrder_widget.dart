// ignore_for_file: deprecated_member_use, unused_field, must_be_immutable, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:serve_bem_app/admin/blocs/settings_admin_bloc.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/user_model.dart';

class BottomSheetOrder extends StatefulWidget {
  String address;
  bool isDelivery;
  String change;
  String payment;
  String namePix;
  List<Map<String, dynamic>> orderList;
  void Function() onSuccess;
  // dynamic confirmarPedido;

  BottomSheetOrder({
    Key? key,
    required this.address,
    required this.isDelivery,
    required this.change,
    required this.payment,
    required this.namePix,
    required this.onSuccess,
    required this.orderList,
  }) : super(key: key);

  @override
  State<BottomSheetOrder> createState() => _BottomSheetOrderState();
}

class _BottomSheetOrderState extends State<BottomSheetOrder> {
  TimeOfDay? _timePicked;
  final _settingsBloc = SettingBloc();

  bool isScheduled = false;
  String horarioAgendado = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          color: Colors.white),
      child: StreamBuilder<Map<String, dynamic>>(
          stream: _settingsBloc.outSettings,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                ),
              );
            } else {
              final listaHoraAbertura =
                  snapshot.data!['horarioA'].toString().split(':');
              int horaAbertura = int.parse(listaHoraAbertura[0]);
              int minAbertura = int.parse(listaHoraAbertura[1]);

              final listaHoraDelRet =
                  snapshot.data!['horarioEntrega'].toString().split(':');
              int horaDelRet = int.parse(listaHoraAbertura[0]);
              int minDelRet = int.parse(listaHoraAbertura[1]);

              final listaHoraFechamento =
                  snapshot.data!['horarioF'].toString().split(':');
              int horaFechamento = int.parse(listaHoraFechamento[0]);
              int minFechamento = int.parse(listaHoraFechamento[1]);

              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Image.asset(
                      'assets/logoof.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: RaisedButton(
                            onPressed: () async {
                              final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              if (time != null) {
                                if (mounted) {
                                  setState(() {
                                    _timePicked = time;
                                    isScheduled = true;
                                    horarioAgendado =
                                        _timePicked!.format(context);
                                  });
                                }
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: MyColors.backGround,
                            child: Text(
                              _timePicked == null
                                  ? "Agendar"
                                  : "Horário Agendado: ${_timePicked?.format(context)}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: RaisedButton(
                            onPressed: _timePicked == null
                                ? () {
                                    if (mounted) {
                                      setState(() {
                                        isScheduled = false;
                                      });

                                      pedirAgora(
                                        horaAbertura: horaAbertura,
                                        minAbertura: minAbertura,
                                        horaFechamento: horaFechamento,
                                        minFechamento: minFechamento,
                                        horaDelRet: horaDelRet,
                                        minDelRet: minDelRet,
                                      );
                                    }
                                  }
                                : () {
                                    if (_timePicked != null) {
                                      agendar(
                                        horaAbertura: horaAbertura,
                                        minAbertura: minAbertura,
                                        horaFechamento: horaFechamento,
                                        minFechamento: minFechamento,
                                        minPreparo:
                                            snapshot.data!['tempoPreparo'],
                                        horaDelRet: horaDelRet,
                                        minDelRet: minDelRet,
                                      );
                                    }
                                  },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: _timePicked == null
                                ? MyColors.backGround
                                : Colors.green,
                            child: Text(
                              _timePicked == null
                                  ? "Pedir Agora"
                                  : "Concluir Pedido",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
          }),
    );
  }

  agendar({
    required int horaAbertura,
    required int minAbertura,
    required int horaFechamento,
    required int minFechamento,
    required int minPreparo,
    required int horaDelRet,
    required int minDelRet,
  }) async {
    int hora = _timePicked!.hour;
    int minuto = _timePicked!.minute;

    final _timeNow = TimeOfDay.now();
    int horaAgora = _timeNow.hour;
    int minAgora = _timeNow.minute;

    int minutoAbertura = (horaDelRet * 60) + minDelRet;
    int minutoFechamento = (horaFechamento * 60) + minFechamento;
    int minutoEscolhido = (hora * 60) + minuto;
    int minutoAgora = (horaAgora * 60) + minAgora;

    // print("Minutos Agora: $minutoAgora");
    // print("Minutos Abertura: $minutoAbertura");
    // print("Minutos Fechamento: $minutoFechamento");

    if (minutoEscolhido > minutoAgora) {
      if (minutoEscolhido >= minutoAbertura &&
          minutoEscolhido <= minutoFechamento) {
        if (minutoEscolhido > minutoAgora + minPreparo) {
          Navigator.of(context, rootNavigator: true).pop();
          fazerPedido();
        } else {
          result(
              color: Colors.red,
              text: "Há um tempo mínimo de preparo de $minPreparo minutos!");
        }
      } else {
        result(
            color: Colors.red,
            text: minFechamento < 10
                ? "O Horário de Retirada/Entrega deve ser entre $horaAbertura:$minAbertura e $horaFechamento:0$minFechamento"
                : minAbertura < 10
                    ? "O Horário de Retirada/Entrega deve ser entre $horaAbertura:0$minAbertura e $horaFechamento:$minFechamento"
                    : minFechamento < 10 && minAbertura < 10
                        ? "O Horário de Retirada/Entrega deve ser entre $horaAbertura:0$minAbertura e $horaFechamento:0$minFechamento"
                        : "O Horário de Retirada/Entrega deve ser entre $horaAbertura:$minAbertura e $horaFechamento:$minFechamento");
      }
    } else {
      result(color: Colors.red, text: "Digite um horário Válido!");
    }
  }

  pedirAgora(
      {required int horaAbertura,
      required int minAbertura,
      required int horaFechamento,
      required int minFechamento,
      required int horaDelRet,
      required int minDelRet}) async {
    final _timeNow = TimeOfDay.now();

    int hora = _timeNow.hour;
    int minuto = _timeNow.minute;

    int minutoAbertura = (horaDelRet * 60) + minDelRet;
    int minutoFechamento = (horaFechamento * 60) + minFechamento;
    int minutoEscolhido = (hora * 60) + minuto;

    if (minutoEscolhido >= minutoAbertura &&
        minutoEscolhido <= minutoFechamento) {
      Navigator.pop(context);
      fazerPedido();
    } else {
      result(
          color: Colors.red,
          text: minFechamento < 10
              ? "Só aceitamos pedidos sem agendamento entre $horaAbertura:$minAbertura/$horaFechamento:0$minFechamento"
              : minAbertura < 10
                  ? "Só aceitamos pedidos sem agendamento entre $horaAbertura:0$minAbertura/$horaFechamento:$minFechamento"
                  : minFechamento < 10 && minAbertura < 10
                      ? "Só aceitamos pedidos sem agendamento entre $horaAbertura:0$minAbertura/$horaFechamento:0$minFechamento"
                      : "Só aceitamos pedidos sem agendamento entre $horaAbertura:$minAbertura/$horaFechamento:$minFechamento");
    }
  }

  result({Color? color, String? text}) {
    Navigator.of(context, rootNavigator: true).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: color,
        content: Text(
          text!,
          style: const TextStyle(color: Colors.white),
        )));
  }

  fazerPedido() async {
    UserModel.of(context).confirmarPedido(
      orderList: widget.orderList,
      address: widget.address,
      delivery: widget.isDelivery,
      change: widget.change,
      payment: widget.payment,
      namePix: widget.namePix,
      orderTime: horarioAgendado,
      onSuccess: widget.onSuccess,
      onFail: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Erro ao Confirmar Pedido!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      },
      isScheduled: isScheduled,
    );
  }
}
