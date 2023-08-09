// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';

import 'package:serve_bem_app/helpers/color_helper.dart';

import 'package:serve_bem_app/tabs/confirmedOrder_tab.dart';
import 'package:serve_bem_app/tabs/notConfirmedOrder2_tab.dart';

// import 'package:serve_bem_app/tabs/notConfirmedOrder_tab.dart';

class OrderScreen extends StatefulWidget {
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  //final _tabController = TabController(length: 2, vsync: );
  int selectedIndex = 0;

  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 2);
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
          backgroundColor: Colors.white,
          title: Text(
            "Lista de Pedidos",
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.06,
                fontWeight: FontWeight.w300),
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.black,
            labelColor: MyColors.backGround,
            controller: controller,
            indicatorColor: MyColors.backGround,
            // ignore: prefer_const_literals_to_create_immutables
            tabs: [
              Tab(
                icon: Icon(Icons.shopping_cart),
                text: "Não Confirmados",
              ),
              Tab(
                  icon: Icon(Icons.shopping_cart_checkout_outlined),
                  text: "Confirmados")
            ],
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: [
            //  Teste(
            //    controller: controller,
            //  ),
            NotConfirmedOrderTab(tabController: controller,),
            ConfirmedOrderTab(),
          ],
        ));
  }
}
