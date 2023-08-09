// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, curly_braces_in_flow_control_structures, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/blocs/settings_admin_bloc.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/widgets/confirmedOrderChoice_widget.dart';

import '../helpers/color_helper.dart';

class ConfirmedOrderWidget extends StatefulWidget {
  final String orderId;

  ConfirmedOrderWidget({required this.orderId});

  @override
  State<ConfirmedOrderWidget> createState() => _ConfirmedOrderWidgetState();
}

class _ConfirmedOrderWidgetState extends State<ConfirmedOrderWidget> {
  bool isExtended = false;

  final _settingsBloc = SettingBloc();

  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: MediaQuery.of(context).size.width * 0.05);
    return StreamBuilder<Map<String, dynamic>>(
        stream: _settingsBloc.outSettings,
        builder: (context, snapshotSettings) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6.0),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pedidosC')
                  .doc(widget.orderId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.hasError ||
                    !snapshot.requireData.exists) {
                  return Center(
                    child: Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(MyColors.backGround)),
                    ),
                  );
                } else {
                  int status = snapshot.data?.get("status");
                  List<dynamic> content = snapshot.data!.get("content");

                  final timestampPedido = snapshot.data?.get('hora');
                  final listatimeStampPedido =
                      timestampPedido.toString().split('-');
                  final horaPedidoFeito = listatimeStampPedido[1];
                  final listaHoraPedido = horaPedidoFeito.split(':');
                  int tempoPreparo = snapshotSettings.data!['tempoPreparo'];
                  final horaPrevista = TimeOfDay(
                      hour: int.parse(listaHoraPedido[1]) + tempoPreparo >= 60
                          ? int.parse(listaHoraPedido[0]) + 1
                          : int.parse(listaHoraPedido[0]),
                      minute:
                          (int.parse(listaHoraPedido[1]) + tempoPreparo) % 60);

                  String horarioPrevito = horaPrevista.format(context);

                  // ignore: unused_local_variable
                  String entrega = "Retirar no Local";
                  snapshot.data!.get('entrega') == false
                      ? entrega = "Retirar no Local"
                      : "Delivery";

                  return Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ExpansionTile(
                      initiallyExpanded: isExtended,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Código do Pedido: ${snapshot.data?.id}"),
                          SizedBox(
                            height: 3,
                          ),
                          Text("Hora do Pedido: ${snapshot.data?.get('hora')}"),
                        ],
                      ),
                      //trailing: Icon(Icons.arrow_drop_down),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCircle("1", "Mandando", status, 0),
                            Container(
                              height: 1.0,
                              width: MediaQuery.of(context).size.width * 0.07,
                              color: Colors.grey[500],
                            ),
                            _buildCircle("2", "Preparando", status, 1),
                            Container(
                              height: 1.0,
                              width: MediaQuery.of(context).size.width * 0.07,
                              color: Colors.grey[500],
                            ),
                            _buildCircle(
                                "3",
                                snapshot.data!.get('entrega') == true
                                    ? "Entrega"
                                    : "Retirada",
                                status,
                                2),
                          ],
                        ),
                      ),
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => ConfirmedOrderChoice(
                                      orderId: widget.orderId,
                                      content: content,
                                    ));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 6),
                            height: MediaQuery.of(context).size.height * 0.07,
                            decoration: BoxDecoration(
                                color: MyColors.backGround,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Abrir Pedido",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(Icons.open_in_new, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Text("Hora do Pedido: ${snapshot.data?.get('hora')}", style: _style,),
                              Text(
                                "Preco Total: R\$ ${snapshot.data?.get('precoTotal')}",
                                style: _style,
                              ),
                              snapshot.data?.get('entrega') == true
                                  ? Text(
                                      "Taxa de Entrega Inclusa: R\$ ${snapshot.data?.get('taxa')}.00",
                                      style: _style,
                                    )
                                  : Container(),
                              snapshot.data?.get('entrega') == false
                                  ? Text(
                                      "Endereço da Entrega: Retirar no Local",
                                      style: _style,
                                    )
                                  : Text(
                                      "Endereço da Entrega: ${snapshot.data?.get('endereco')}",
                                      style: _style,
                                    ),
                              Text(
                                "Pagamento: ${snapshot.data?.get('pagamento')}",
                                style: _style,
                              ),

                              snapshot.data?.get('pagamento') == "Dinheiro"
                                  ? Text(
                                      int.parse(snapshot.data!.get('troco')) ==
                                              snapshot.data!.get("precoTotal")
                                          ? "Não Precisa de Troco"
                                          : "Troco: R\$ ${snapshot.data?.get('troco')},00",
                                      style: _style,
                                    )
                                  : Text(""),
                              Text(
                                snapshot.data!.get("agendado") == true
                                    ? "Horario Agendado: ${snapshot.data!.get('horaPedido')}"
                                    : "Horario Previsto: $horarioPrevito ",
                                style: _style,
                              ),
                              Row(
                                mainAxisAlignment:
                                    snapshot.data!.get('entrega') == true
                                        ? MainAxisAlignment.spaceAround
                                        : MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    //width: MediaQuery.of(context).size.width * 0.3,
                                    margin: EdgeInsets.symmetric(vertical: 12),
                                    child: snapshot.data!.get('status') < 1
                                        ? RaisedButton(
                                            elevation: 6,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),

                                            color: MyColors.backGround,
                                            //controller: _buttonController,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Deletar Pedido',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.045,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Icon(
                                                  CupertinoIcons.trash,
                                                  color: Colors.white,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.045,
                                                )
                                              ],
                                            ),
                                            onPressed: () {
                                              UserModel.of(context)
                                                  .deletarPedidoConfirmado(
                                                      id: widget.orderId,
                                                      onSuccess: onSuccess);
                                            },
                                          )
                                        : Container(),
                                  ),
                                  snapshot.data!.get('entrega') == true
                                      ? Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          //width: MediaQuery.of(context).size.width * 0.3,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 12),
                                          child: RaisedButton(
                                            elevation: 6,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),

                                            color: MyColors.backGround,
                                            //controller: _buttonController,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Chegou!',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.045,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.045,
                                                )
                                              ],
                                            ),
                                            onPressed: snapshot
                                                        .data!['status'] ==
                                                    3
                                                ? null
                                                : () {
                                                    UserModel.of(context)
                                                        .confirmarPedidoChegou(
                                                            id: widget.orderId,
                                                            onFail: onFail);
                                                  },
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          );
        });
  }

  onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Seu pedido foi removido!",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: MyColors.backGround,
    ));
  }

  onFail() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Seu pedido ainda não saiu para entrega!",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: MyColors.backGround,
    ));
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color? backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      backColor = MyColors.backGround;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white)),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
      );
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: MediaQuery.of(context).size.width * 0.04,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}
