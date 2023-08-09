// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/blocs/pedidos_admin_bloc.dart';
import 'package:serve_bem_app/admin/widgets/pedidos_widget_admin.dart';

import '../../../helpers/color_helper.dart';

class PedidosTabDOADM extends StatefulWidget {
  @override
  State<PedidosTabDOADM> createState() => PedidosTabDOADMState();
}

class PedidosTabDOADMState extends State<PedidosTabDOADM> {
  final _pedidosBloc = PedidosBloc();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              style: TextStyle(color: Colors.white),
              onChanged: _pedidosBloc.onChangedSearchDO,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  hintText: 'Pesquisar Pedidos',
                  hintStyle: TextStyle(color: Colors.white),
                  icon: Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none),
              // onChanged: _userBloc.onChangedSearch,
            ),
          ),
          Expanded(
            child: StreamBuilder<List>(
              stream: _pedidosBloc.outdOrders,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(MyColors.backGround),
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
                              //oid: _pedidosBloc.oid,
                              onSuccess: onSuccess2,
                              onFail: onFail2,
                              // status: 1,
                            ))
                        .toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
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
