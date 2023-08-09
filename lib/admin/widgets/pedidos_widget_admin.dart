// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/blocs/pedidos_admin_bloc.dart';
import 'package:serve_bem_app/admin/widgets/pedidos_view_widget_admin.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

class PedidosWidgetADM extends StatefulWidget {
  final Map<String, dynamic> pedido;
  VoidCallback onSuccess;
  VoidCallback onFail;
  // int status;
  //String oid;
  PedidosWidgetADM({
    required this.pedido,
    // required this.oid,
    required this.onSuccess,
    required this.onFail,
    // required this.status,
  });

  @override
  State<PedidosWidgetADM> createState() => _PedidosWidgetADMState();
}

class _PedidosWidgetADMState extends State<PedidosWidgetADM> {
  List<dynamic> orderContent = [];

  final _pedidosBloc = PedidosBloc();
  @override
  void initState() {
    super.initState();
    orderContent = widget.pedido['content'];
    // print(widget.order);
  }

  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
    );

    return Container(
        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 6.0),
        child: //widget.status == widget.pedido['status']
            //     ?
            StreamBuilder<OrderState>(
                stream: _pedidosBloc.outState,
                initialData: OrderState.IDLE,
                builder: (context, snapshot) {
                  switch (snapshot.data!) {
                    case OrderState.LOADING:
                      return Card(
                        color: Colors.grey.shade600,
                        margin: EdgeInsets.all(12),
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                          ),
                      );
                    case OrderState.IDLE:

                    case OrderState.SUCCESS:

                    case OrderState.FAIL:
                      return Card(
                        color: Colors.grey.shade600,
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ExpansionTile(
                          textColor: MyColors.backGround,
                          title: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.pedido['nome']}  ${widget.pedido['hora']}",
                                  textAlign: TextAlign.start,
                                  style: _style,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    "Códido: ${widget.pedido['id']} ",
                                    textAlign: TextAlign.start,
                                    style: _style,
                                  ),
                                ),
                                widget.pedido['agendado'] == true
                                    ? Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          "Pedido Agendado para ${widget.pedido['horaPedido']} ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: MyColors.backGround,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          trailing: Text(
                            "R\$ ${widget.pedido['precoTotal']}0",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                                color: Colors.white),
                          ),
                          subtitle: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => PedidosViewADM(
                                        orderContent: orderContent,
                                        orderId: widget.pedido['id'],
                                      ));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 6),
                              height: MediaQuery.of(context).size.height * 0.07,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade500,
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
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 16.0),
                                  child: Text(
                                    "Forma de Pagamento: ${widget.pedido['pagamento']}",
                                    style: _style,
                                  ),
                                ),
                                widget.pedido['pagamento'] == "Dinheiro"
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2.0, horizontal: 16.0),
                                        child: Text(
                                          double.parse(widget
                                                      .pedido['precoTotal']
                                                      .toString()) !=
                                                  double.parse(widget
                                                      .pedido['troco']
                                                      .toString())
                                              ? "Troco Para: R\$ ${widget.pedido['troco']},00"
                                              : "Não Precisa de Troco",
                                          style: _style,
                                        ),
                                      )
                                    : Container(),
                                widget.pedido['pagamento'] == "Pix"
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2.0, horizontal: 16.0),
                                        child: Text(
                                          "Nome do Pix: ${widget.pedido['nomePix']}",
                                          style: _style,
                                        ),
                                      )
                                    : Container(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 16.0),
                                  child: Text(
                                    widget.pedido['entrega'] == true
                                        ? "Endereço Entrega: ${widget.pedido['endereco']}"
                                        : "Endereço de Entrega: Retirar no Restaurante",
                                    style: _style,
                                  ),
                                ),
                                /*
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 16.0),
                                  child: Text(
                                    widget.pedido['entrega'] == true
                                        ? "Horário Entrega: ${widget.pedido['horaPedido']}"
                                        : "Horário da Retirada: ${widget.pedido['horaPedido']}",
                                    style: _style,
                                  ),
                                ),
                                */
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          _pedidosBloc.deleteOrder(
                                            uid: widget.pedido['uid'],
                                            orderId: widget.pedido['id'],
                                          );
                                        },
                                        child: Text(
                                          "Excluir",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      widget.pedido['status'] != 0
                                          ? TextButton(
                                              onPressed: () {
                                                _pedidosBloc.decStatus(
                                                  orderId: widget.pedido['id'],
                                                  onSuccess: widget.onSuccess,
                                                  onFail: widget.onFail,
                                                );
                                              },
                                              child: Text("Anterior"),
                                            )
                                          : Container(),
                                      widget.pedido['status'] < 3
                                          ? TextButton(
                                              onPressed: () {
                                                _pedidosBloc.addStatus(
                                                  onSuccess: widget.onSuccess,
                                                  onFail: widget.onFail,
                                                  orderId: widget.pedido['id'],
                                                );
                                              },
                                              child: Text(
                                                "Próximo",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                  }
                })
        //: SizedBox(),
        );
  }
}
