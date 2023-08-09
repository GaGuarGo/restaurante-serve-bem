// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/blocs/pedidos_admin_bloc.dart';
import 'package:serve_bem_app/admin/widgets/addMenu_widget_admin.dart';
import 'package:serve_bem_app/admin/widgets/menuDrink_widget_admin.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

class MenuDrinkTabADM extends StatefulWidget {
  const MenuDrinkTabADM({Key? key}) : super(key: key);

  @override
  State<MenuDrinkTabADM> createState() => _MenuDrinkTabADMState();
}

class _MenuDrinkTabADMState extends State<MenuDrinkTabADM> {
  @override
  void initState() {
  
    super.initState();
  }

  final _pedidosBloc = PedidosBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyColors.backGround,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => const AddMenuDialogADM());
          },
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.grey.shade800,
        body: StreamBuilder<List>(
            stream: _pedidosBloc.getOutdrinkItens,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(MyColors.backGround)),
                );
              } else if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "Nenhuma Bebida Adicionada!",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      color: MyColors.backGround,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                );
              } else {
                return ListView(
                  children: snapshot.data!
                      .map((op) => MenuDrinkWidgetADM(
                            op: op,
                            onSuccess: onSuccess,
                            onFail: onFail,
                          ))
                      .toList(),
                );
              }
            }));
  }

  onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
        content: Text(
          "Sucesso!",
          style: TextStyle(color: Colors.white),
        )));
  }

  onFail() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
        content: Text(
          "Erro!",
          style: TextStyle(color: Colors.white),
        )));
  }
}
