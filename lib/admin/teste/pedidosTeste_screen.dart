// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/teste/pedidosTeste_tab_admin.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

class PedidosTesteScreenADM extends StatefulWidget {
  const PedidosTesteScreenADM({Key? key}) : super(key: key);

  @override
  State<PedidosTesteScreenADM> createState() => _PedidosTesteScreenADMState();
}

class _PedidosTesteScreenADMState extends State<PedidosTesteScreenADM>
    with TickerProviderStateMixin {

  late TabController controller;


  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 10.0,
        backgroundColor: Colors.grey.shade800,
        title: Text(
          "Lista de Pedidos",
          style: TextStyle(
              color: MyColors.backGround,
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontWeight: FontWeight.w400),
        ),
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: MyColors.backGround,
          controller: controller,
          indicatorColor: MyColors.backGround,

          // ignore: prefer_const_literals_to_create_immutables
          tabs: const [
            Tab(
              icon: Icon(Icons.shopping_cart),
              text: "Não Confirmados",
            ),
            Tab(icon: Icon(Icons.dining_rounded), text: "Em preparo"),
            Tab(icon: Icon(Icons.delivery_dining), text: "Entrega"),
            Tab(icon: Icon(Icons.domain_verification_rounded), text: "Feitos"),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          PedidosTesteTabADM(status: 0),
          PedidosTesteTabADM(status: 1),
          PedidosTesteTabADM(status: 2),
          PedidosTesteTabADM(status: 3),
        ],
      ),
    );
  }
}
