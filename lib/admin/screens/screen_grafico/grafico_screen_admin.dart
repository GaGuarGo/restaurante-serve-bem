// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/blocs/grafico_admin_bloc.dart';
import 'package:serve_bem_app/admin/screens/screen_grafico/grafico_tab2_admin.dart';
import 'package:serve_bem_app/admin/screens/screen_grafico/grafico_tab_admin.dart';
import 'package:serve_bem_app/admin/screens/screen_grafico/itemGrafico_class.dart';
import 'package:serve_bem_app/admin/widgets/confirmDeleting_widget_admin.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'dart:core';

class GraficoScreenADM extends StatefulWidget {
  const GraficoScreenADM({Key? key}) : super(key: key);

  @override
  State<GraficoScreenADM> createState() => _GraficoScreenADMState();
}

class _GraficoScreenADMState extends State<GraficoScreenADM>
    with TickerProviderStateMixin {
  String mesAtual = "";
  final _graficoBloc = GraficoBlocADM();
  late bool isShowingMainData;
  late TabController controller;

  List<DropdownMenuItem<String>> meses = [];

  @override
  void initState() {
    super.initState();

    mesAtual = _graficoBloc.mesAtual(DateTime.now().month);
    isShowingMainData = true;
    controller = TabController(vsync: this, length: 2);

    meses = _graficoBloc.itemsMeses;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _textAppBarStyle = TextStyle(
        color: MyColors.backGround,
        fontSize: MediaQuery.of(context).size.width * 0.06,
        fontWeight: FontWeight.bold);

    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.grey.shade800,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Gráfico do Mês: ",
              style: _textAppBarStyle,
            ),
            DropdownButton<String>(
              borderRadius: BorderRadius.circular(12),
              dropdownColor: Colors.grey.shade700,
              style: TextStyle(color: Colors.white, fontSize: 20),
              iconEnabledColor: MyColors.backGround,
              iconDisabledColor: MyColors.backGround,
              underline: Container(),
              items: meses,
              value: mesAtual,
              onChanged: (String? value) {
                setState(() {
                  mesAtual = value!;
                });
                // _graficoBloc.listaGrafico.clear();

                setState(() {
                  //  _graficoBloc.listaGraficoPizza.clear();
                  _graficoBloc.addGrafico(mesEscolhido: mesAtual);
                  // _graficoBloc.addGraficoPizza(mesEscolhido: mesAtual);
                });
              },
            ),
          ],
        ),
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: MyColors.backGround,
          controller: controller,
          indicatorColor: MyColors.backGround,
          // ignore: prefer_const_literals_to_create_immutables
          tabs: const [
            Tab(icon: Icon(Icons.calendar_month), text: "Mensal"),
            Tab(icon: Icon(Icons.leaderboard), text: "Tamanho"),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Deletar Reletório Completo",
            onPressed: () {
              showDialog(
                  context: context, builder: (context) => ConfirmingDeleting());
            },
            icon: Icon(
              Icons.playlist_remove_rounded,
              color: MyColors.backGround,
            ),
            iconSize: MediaQuery.of(context).size.width * 0.08,
          ),
        ],
      ),
      body: StreamBuilder<List<ItemGrafico>>(
        stream: _graficoBloc.getOutGrafico,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(MyColors.backGround),
              ),
            );
          } else {
            return TabBarView(
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                GraficoScreenTabADM(list: snapshot.data!),
                StreamBuilder<Map<String, dynamic>>(
                    stream: _graficoBloc.getOutGraficoPizza,
                    builder: (context, snapshotP) {
                      if (!snapshotP.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(MyColors.backGround),
                          ),
                        );
                      } else {
                        return GraficoScreenTab2ADM(
                          list: snapshot.data!,
                          info: snapshotP.data!,
                        );
                      }
                    }),
              ],
            );
          }
        },
      ),
    );
  }
}
