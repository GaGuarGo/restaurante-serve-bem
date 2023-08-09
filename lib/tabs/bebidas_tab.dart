// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/blocs/settings_admin_bloc.dart';
import 'package:serve_bem_app/blocs/menu_bloc.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/widgets/bebidas_widget.dart';

class BebidasTab extends StatefulWidget {
  var controller = DraggableScrollableController();
  BebidasTab({required this.controller});

  @override
  State<BebidasTab> createState() => _BebidasTabState();
}

class _BebidasTabState extends State<BebidasTab> {
  // List<Map<String, String>> op = [];
  final _settingsBloc = SettingBloc();
  final _menuBloc = MenuBloc();

  @override
  void initState() {
    super.initState();
    // if (mounted) {
    //   setState(() {
    //     op = MenuModel.of(context).drinks;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
      body: StreamBuilder<Map<String, dynamic>>(
          stream: _settingsBloc.outSettings,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                ),
              );
            } else {
              if (snapshot.data!['funcionamentoState'] == false) {
                return Center(
                  child: const Text(
                    "Estamos Fechados no Momento \n Horário de Funcionamento 11:00 - 14:30",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: MyColors.backGround,
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                  ),
                );
              } else {
                return StreamBuilder<List>(
                  stream: _menuBloc.outBebidas,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(MyColors.backGround),
                        ),
                      );
                    } else {
                      return ListView(
                        children: snapshot.data!
                            .map((op) => BebibasWidget(
                                  op: op,
                                  controller: widget.controller,
                                ))
                            .toList(),
                      );
                    }
                  },
                );
              }
            }
          }),
    );
  }
}

/*
GridView.builder(
        itemCount: op.length,
        padding: EdgeInsets.all(4.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          // childAspectRatio: 0.65,
        ),
        itemBuilder: (BuildContext context, int index) {
          return BebibasWidget(op: op[index]);
        },
      ),
*/
