// ignore_for_file: use_key_in_widget_constructors, unnecessary_new, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/blocs/settings_admin_bloc.dart';
import 'package:serve_bem_app/admin/tabs/pedidosTab/pedidosNC_tab_admin.dart';
import 'package:serve_bem_app/admin/tabs/pedidosTab/pedidos_DEO_tab_admin.dart';
import 'package:serve_bem_app/admin/tabs/pedidosTab/pedidos_DNO_tab_admin.dart';
import 'package:serve_bem_app/admin/tabs/pedidosTab/pedidos_DO_tab_admin.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

enum OrderOptions { ordercr, orderdr }

class PedidosScreenADM extends StatefulWidget {
  @override
  State<PedidosScreenADM> createState() => _PedidosScreenADMState();
}

class _PedidosScreenADMState extends State<PedidosScreenADM>
    with TickerProviderStateMixin {
  //int selectedIndex = 0;

  late TabController controller;
  final _settingsBloc = SettingBloc();

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
        backgroundColor: Colors.grey.shade800,
        /*
        floatingActionButton: StreamBuilder<bool>(
            stream: _pedidosBloc.outOrdemPedidos,
            builder: (context, snapshot) {
              return FloatingActionButton(
                onPressed: _pedidosBloc.mudarOrdemPedidos,
                backgroundColor: MyColors.backGround,
                child: Center(
                    child: snapshot.hasData
                        ? Icon(
                            snapshot.data == true
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            color: Colors.white,
                          )
                        : const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )),
              );
            }),
            */
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
              Tab(
                  icon: Icon(Icons.domain_verification_rounded),
                  text: "Feitos"),
            ],
          ),
        ),
        body: StreamBuilder<Map<String, dynamic>>(
            stream: _settingsBloc.outSettings,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Center();
              else
                return TabBarView(
                  controller: controller,
                  children: [
                    PedidosTabNCADM(),
                    PedidosTabDOADM(),
                    PedidosTabDEOADM(),
                    PedidosTabDNOADM(
                      isOpen: snapshot.data!['funcionamentoState'],
                    ),
                    // PedidosTabADM(status: 0),
                    // PedidosTabADM(status: 1),
                    // PedidosTabADM(status: 2),
                    // PedidosTabADM(status: 3),
                  ],
                );
            }));
  }
}
