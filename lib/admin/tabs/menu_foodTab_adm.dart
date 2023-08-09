// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/blocs/pedidos_admin_bloc.dart';
import 'package:serve_bem_app/admin/widgets/addMenu_widget_admin.dart';
import 'package:serve_bem_app/admin/widgets/menuFood_widget_admin.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
class MenuFoodTabADM extends StatefulWidget {
  const MenuFoodTabADM({Key? key}) : super(key: key);

  @override
  State<MenuFoodTabADM> createState() => _MenuFoodTabADMState();
}

class _MenuFoodTabADMState extends State<MenuFoodTabADM> {
  final _pedidosBloc = PedidosBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation:FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.backGround,
        onPressed: () {
          showDialog(
              context: context, builder: (context) => const AddMenuDialogADM());
        },
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade800,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                margin: const EdgeInsets.all(8),
                elevation: 10.0,
                color: Colors.grey.shade600,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Prato Principal:",
                      style: TextStyle(
                        color: MyColors.backGround,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                      ),
                    ),
                  ),
                  _foodChoice(stream: _pedidosBloc.getOutPrincipalFoodItens)
                ]),
              ),
              Card(
                margin: const EdgeInsets.all(8),
                elevation: 10.0,
                color: Colors.grey.shade600,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Guarnição:",
                      style: TextStyle(
                        color: MyColors.backGround,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                      ),
                    ),
                  ),
                  _foodChoice(stream: _pedidosBloc.getOutGuarnicaoFoodItens)
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _foodChoice({required Stream<List<dynamic>>? stream}) => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.9,
        child: StreamBuilder<List>(
            stream: stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                );
              } else if (snapshot.data!.isEmpty) {
                return _noItemAdded();
              } else {
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data!
                      .map((op) => MenuWidgetADM(
                            op: op,
                            onSuccess: onSuccess,
                            onFail: onFail,
                          ))
                      .toList(),
                );
              }
            }),
      );

  Widget _noItemAdded() => Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.height * 0.3,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: MyColors.backGround,
          borderRadius: BorderRadius.circular(20),
          // ignore: prefer_const_literals_to_create_immutables
        ),
        child: Text(
          "Não há nenhum item adicionado!",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.07),
        ),
      );

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
