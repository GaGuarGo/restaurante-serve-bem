// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/screens/screen_grafico/itemGrafico_class.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

class GraficoScreenTab2ADM extends StatefulWidget {
  final List<ItemGrafico> list;
  final Map<String, dynamic> info;

  const GraficoScreenTab2ADM({Key? key, required this.list, required this.info})
      : super(key: key);

  @override
  State<GraficoScreenTab2ADM> createState() => _GraficoScreenTab2ADMState();
}

class _GraficoScreenTab2ADMState extends State<GraficoScreenTab2ADM> {
  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: MediaQuery.of(context).size.width * 0.05);

    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("PORCENTAGEM DE VENDAS POR TAMANHO:",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: MyColors.backGround,
                    fontWeight: FontWeight.w700,
                    textBaseline: TextBaseline.alphabetic,
                    fontSize: MediaQuery.of(context).size.width * 0.05)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              porcentagemTamanho(
                  title: "Tamanho Pequeno",
                  height: widget.info['quantP'] / widget.info['totalQuant'],
                  quant: widget.info['quantP'],
                  price: widget.info['priceP'],
                  haveData: widget.info.values.any((element) => element != 0)),
              porcentagemTamanho(
                  title: "Tamanho Médio",
                  height: widget.info['quantM'] / widget.info['totalQuant'],
                  quant: widget.info['quantM'],
                  price: widget.info['priceM'],
                  haveData: widget.info.values.any((element) => element != 0)),
              porcentagemTamanho(
                title: "Tamanho Grande",
                height: widget.info['quantG'] / widget.info['totalQuant'],
                quant: widget.info['quantG'],
                price: widget.info['priceG'],
                haveData: widget.info.values.any((element) => element != 0),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: MyColors.backGround,
                borderRadius: BorderRadius.circular(12)),
            child: widget.info.values.any((element) => element != 0)
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Marmitas Vendidas: R\$${widget.info['totalPrice']}"
                        "0",
                        style: _style,
                      ),
                      Text(
                        "Bebidas Vendidas: R\$${widget.info['priceB']} ",
                        style: _style,
                      ),
                      Text(
                        "Total dos fretes: R\$${widget.info['priceT']}",
                        style: _style,
                      ),
                      Text(
                        "Quantidade Total Vendida: ${widget.info['totalQuant']} ",
                        style: _style,
                      ),
                    ],
                  )
                : Text(
                    "Nenhuma informação sobre esse mês!",
                    style: _style,
                  ),
          )
        ],
      ),
    );
  }

  Widget porcentagemTamanho({
    required String title,
    required double height,
    required int quant,
    required double price,
    required bool haveData,
  }) =>
      SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                  border: Border.all(color: MyColors.backGround),
                  borderRadius: BorderRadius.circular(12)),
              child: haveData == true
                  ? Stack(
                    alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          width: MediaQuery.of(context).size.width * 0.15,
                          height:
                              MediaQuery.of(context).size.height * 0.3 * height,
                          decoration: BoxDecoration(
                            color: MyColors.backGround,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        Center(
                            child: Text(
                          "${(height * 100).toStringAsFixed(1)}" "%",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        )),
                      ],
                    )
                  : Center(
                      child: Text(
                      "Vazio",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    )),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: MyColors.backGround, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Quantidade: $quant",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Valor: R\$$price" "0",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      );
}
