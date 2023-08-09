// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, must_be_immutable

import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/teste/pedidosTeste_admin_bloc.dart';
import 'package:serve_bem_app/admin/teste/pedidosTeste_widget.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

class PedidosTesteTabADM extends StatefulWidget {
  int status;
  PedidosTesteTabADM({Key? key, required this.status}) : super(key: key);

  @override
  State<PedidosTesteTabADM> createState() => _PedidosTesteTabADMState();
}

class _PedidosTesteTabADMState extends State<PedidosTesteTabADM> {
  final _pedidosBlocTeste = PedidosBlocTeste();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              // onChanged: _pedidosBloc.onChangedSearchNCO,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                  hintText: 'Pesquisar Pedidos',
                  hintStyle: TextStyle(color: Colors.white),
                  icon: Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none),
              // onChanged: _userBloc.onChangedSearch,
            ),
          ),
          Expanded(
            child: StreamBuilder<List>(
              stream: _pedidosBlocTeste.outPedidos,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                    ),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhum Pedido Encontrado',
                      style: TextStyle(color: MyColors.backGround),
                    ),
                  );
                } else {
                  return ListView(
                    children: snapshot.data!
                        .map((pedido) => PedidosTesteWidgetADM(
                              pedido: pedido,
                              // oid: _pedidosBloc.oid,
                              onSuccess: onSuccess2,
                              onFail: onFail2,
                              status: widget.status,
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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
        content: Text(
          "Sucesso!",
          style: TextStyle(color: Colors.white),
        )));
  }

  onFail2() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
        content: Text(
          "Erro!",
          style: TextStyle(color: Colors.white),
        )));
  }
}
