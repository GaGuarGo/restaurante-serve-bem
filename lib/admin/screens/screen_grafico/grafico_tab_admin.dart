// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/screens/screen_grafico/itemGrafico_class.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class GraficoScreenTabADM extends StatefulWidget {
  final List<ItemGrafico> list;
  GraficoScreenTabADM({required this.list});

  @override
  State<GraficoScreenTabADM> createState() => _GraficoScreenTabADMState();
}

class _GraficoScreenTabADMState extends State<GraficoScreenTabADM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: SfCartesianChart(
          enableAxisAnimation: true,
          primaryXAxis: CategoryAxis(),

          // Chart title
          title: ChartTitle(
              text: 'Valor das Vendas Diariamente',
              textStyle: const TextStyle(color: MyColors.backGround)),
          // Enable legend
          legend: Legend(isVisible: false),
          // Enable tooltip
          tooltipBehavior: TooltipBehavior(enable: true),
          zoomPanBehavior: ZoomPanBehavior(
            zoomMode: ZoomMode.xy,
            enablePinching: true,
            enablePanning: true,
          ),
          series: <ChartSeries<ItemGrafico, dynamic>>[
            LineSeries<ItemGrafico, dynamic>(
              color: MyColors.backGround,
              pointColorMapper: (ItemGrafico item, _) => MyColors.backGround,
              dataSource: widget.list,
              xValueMapper: (ItemGrafico item, _) =>
                  "Dia ${item.hora.toDate().day}",
              yValueMapper: (ItemGrafico item, _) => item.totalPrice,
              name: 'Vendas',
              // Enable data label
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                color: MyColors.backGround,
              ),
            ),
          ]),
    );
  }
}
