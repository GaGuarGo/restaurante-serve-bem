// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/blocs/pedidos_admin_bloc.dart';
import 'package:serve_bem_app/admin/tabs/menuPhoto_tab_adm.dart';
import 'package:serve_bem_app/admin/tabs/menu_drinkTab_adm.dart';
import 'package:serve_bem_app/admin/tabs/menu_foodTab_adm.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/menu_model.dart';

class MenuScreenADM extends StatefulWidget {
  bool isOpen;
  MenuScreenADM({Key? key, required this.isOpen}) : super(key: key);

  @override
  State<MenuScreenADM> createState() => _MenuScreenADMState();
}

class _MenuScreenADMState extends State<MenuScreenADM>
    with TickerProviderStateMixin {
  late TabController controller;

  int _selectedIndex = 0;

  final _pedidosBloc = PedidosBloc();

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 3);
    MenuModel.of(context).getMenu();
    controller.addListener(() {
      setState(() {
        _selectedIndex = controller.index;
      });
    });

    _pedidosBloc.outState.listen((state) {
      switch (state) {
        case OrderState.IDLE:
          break;
        case OrderState.LOADING:
          break;
        case OrderState.SUCCESS:
          result(title: "Menu Removido Com Sucesso!", color: Colors.green);
          break;
        case OrderState.FAIL:
          result(title: "Falha ao Remover Menu!", color: Colors.red);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: _selectedIndex == 2
            ? Container()
            : FloatingActionButton(
                backgroundColor: widget.isOpen == false
                    ? MyColors.backGround
                    : Colors.grey.shade600,
                onPressed: widget.isOpen == false
                    ? () {
                        _pedidosBloc.deleteMenu();
                      }
                    : null,
                child: const Center(
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
        backgroundColor: Colors.grey.shade800,
        appBar: AppBar(
          centerTitle: true,
          elevation: 10.0,
          backgroundColor: Colors.grey.shade800,
          title: Text(
            "Configurar Menu",
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
              Tab(icon: Icon(Icons.restaurant_outlined), text: "Comida"),
              Tab(icon: Icon(Icons.local_drink_outlined), text: "Bebida"),
              Tab(icon: Icon(Icons.menu_book_outlined), text: "Cardápio"),
            ],
          ),
        ),
        body: StreamBuilder<OrderState>(
            stream: _pedidosBloc.outState,
            initialData: OrderState.IDLE,
            builder: (context, snapshot) {
              switch (snapshot.data) {
                case OrderState.LOADING:
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                    ),
                  );
                case OrderState.IDLE:
                case OrderState.SUCCESS:
                case OrderState.FAIL:
                default:
                  return TabBarView(
                    controller: controller,
                    children: const [
                      MenuFoodTabADM(),
                      MenuDrinkTabADM(),
                      MenuPhotoTabADM(),
                    ],
                  );
              }
            }));
  }

  result({String? title, Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(
        title!,
        style: const TextStyle(color: Colors.white),
      ),
    ));
  }
}
