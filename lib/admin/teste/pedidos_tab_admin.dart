// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, must_be_immutable
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/blocs/pedidos_admin_bloc.dart';
import 'package:serve_bem_app/admin/widgets/pedidos_widget_admin.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

class PedidosTabADM extends StatefulWidget {
  int status;
  PedidosTabADM({Key? key, required this.status}) : super(key: key);

  @override
  State<PedidosTabADM> createState() => _PedidosTabADMState();
}

class _PedidosTabADMState extends State<PedidosTabADM> {
  final _pedidosBloc = PedidosBloc();

  double totalOrderPrice = 0;
  double quantOrder = 0;

  @override
  void initState() {
    super.initState();
    getTotalOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      floatingActionButton: widget.status == 3
          ? FloatingActionButton(
              tooltip: 'Limpar Pedidos',
              onPressed: () async {
                // if (_pedidosBloc.canSend() == true) {
                //   if (widget.isOpen == false) {
                //     _pedidosBloc.fazerRelatorio(
                //       quant: quantOrder,
                //       price: totalOrderPrice,
                //       context: context,
                //       onFail: onFail,
                //       onSuccess: onSuccess,
                //     );
                //     setState(() {
                //       quantOrder = 0;
                //       totalOrderPrice = 0;
                //     });
                //   } else {
                //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //         duration: Duration(seconds: 1),
                //         backgroundColor: Colors.red,
                //         content: Text(
                //           "O restaurante ainda está aberto!",
                //           style: TextStyle(color: Colors.white),
                //         )));
                //   }
                // } else {
                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //       duration: Duration(seconds: 1),
                //       backgroundColor: Colors.red,
                //       content: Text(
                //         "O restaurante ainda possui pedidos em aberto!",
                //         style: TextStyle(color: Colors.white),
                //       )));
                // }
              },
              backgroundColor: MyColors.backGround,
              child: const Center(
                child: Icon(Icons.delete, color: Colors.white),
              ),
            )
          : Container(),
      body: StreamBuilder<OrderState>(
          stream: _pedidosBloc.outState,
          initialData: OrderState.IDLE,
          builder: (context, snapshot) {
            switch (snapshot.data!) {
              case OrderState.LOADING:
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                  ),
                );
              case OrderState.IDLE:

              case OrderState.SUCCESS:

              case OrderState.FAIL:
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      margin:
                          EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        onChanged: _pedidosBloc.onChangedSearchPedidos,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: 'Pesquisar Pedidos',
                            hintStyle: TextStyle(color: Colors.white),
                            icon: Icon(Icons.search, color: Colors.white),
                            border: InputBorder.none),
                        // onChanged: _userBloc.onChangedSearch,
                      ),
                    ),
                    widget.status == 3
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 2.0),
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                width: MediaQuery.of(context).size.width * 0.45,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade600,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "N° de Pedidos:  ${quantOrder}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 2.0),
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                width: MediaQuery.of(context).size.width * 0.45,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade600,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Total:  R\$ ${totalOrderPrice}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                    Expanded(
                      child: StreamBuilder<List>(
                        stream: _pedidosBloc.outPedidos,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(MyColors.backGround),
                              ),
                            );
                          } else if (snapshot.data!.isEmpty) {
                            return Center(
                              child: Text(
                                'Nenhum Pedido Encontrado',
                                style: TextStyle(color: MyColors.backGround),
                              ),
                            );
                          } else {
                            return ListView(
                              children: snapshot.data!
                                  .map((pedido) => PedidosWidgetADM(
                                        pedido: pedido,
                                        // oid: _pedidosBloc.oid,
                                        onSuccess: onSuccess2,
                                        onFail: onFail2,
                                        // status: widget.status,
                                      ))
                                  .toList(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
            }
          }),
    );
  }

  getTotalOrders() async {
    final orders =
        await FirebaseFirestore.instance.collection('pedidosC').get();

    orders.docs.forEach((op) async {
      final order = await FirebaseFirestore.instance
          .collection('pedidosC')
          .doc(op.id)
          .get();

      if (order['status'] == 3) {
        setState(() {
          totalOrderPrice = order['precoTotal'] + totalOrderPrice;
          quantOrder = quantOrder + 1;
        });
      }
    });
  }

  onSuccess2() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
        content: Text(
          "Sucesso!",
          style: TextStyle(color: Colors.white),
        )));
  }

  onFail2() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
        content: Text(
          "Erro!",
          style: TextStyle(color: Colors.white),
        )));
  }
}
*/