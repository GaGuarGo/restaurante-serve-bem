// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/widgets/pedidos_tile_admin.dart';

class PedidosViewADM extends StatefulWidget {
  List<dynamic> orderContent;
  String orderId;
  PedidosViewADM({required this.orderContent, required this.orderId});

  @override
  State<PedidosViewADM> createState() => _PedidosViewADMState();
}

class _PedidosViewADMState extends State<PedidosViewADM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade600,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Pedido: ${widget.orderId}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            //fontSize: MediaQuery.of(context).size.width * 0.04
          ),
        ),
        backgroundColor: Colors.grey.shade600,
        elevation: 0.0,
      ),
      body: ListView(
        children: widget.orderContent
            .map((order) => PedidosTileADM(order: order))
            .toList(),
      ),
    );
  }
}
