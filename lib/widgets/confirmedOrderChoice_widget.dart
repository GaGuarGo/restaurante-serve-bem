// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:serve_bem_app/widgets/confirmedOrder_tile.dart';

class ConfirmedOrderChoice extends StatefulWidget {
  List<dynamic> content;
  String orderId;
  ConfirmedOrderChoice({Key? key, required this.content, required this.orderId})
      : super(key: key);

  @override
  State<ConfirmedOrderChoice> createState() => _ConfirmedOrderChoiceState();
}

class _ConfirmedOrderChoiceState extends State<ConfirmedOrderChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.grey),
        title: Text(
          "Pedido: ${widget.orderId}",
          style: const TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        margin: const EdgeInsets.all(4),
        //  height: MediaQuery.of(context).size.height * 0.35,
        decoration: const BoxDecoration(
            //  borderRadius: BorderRadius.circular(12),
            //border: Border.all(color: MyColors.backGround),
            ),
        child: ListView(
          children: widget.content.map((op) {
            return ConfimedOrderTile(
              order: op,
            );
          }).toList(),
        ),
      ),
    );
  }
}
