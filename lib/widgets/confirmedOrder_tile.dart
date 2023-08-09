// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

class ConfimedOrderTile extends StatefulWidget {
  final Map<String, dynamic> order;
  ConfimedOrderTile({required this.order});

  @override
  State<ConfimedOrderTile> createState() => _ConfimedOrderTileState();
}

class _ConfimedOrderTileState extends State<ConfimedOrderTile> {
  List<dynamic> orderContent = [];

  @override
  void initState() {
    
    super.initState();
    orderContent = widget.order['conteudo'];
    // print(widget.order);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.32,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Tamanho: ${widget.order['tamanho']}",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w300)),
                  Text("Quantidade: ${widget.order['quantidade']}",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w300)),
                ],
              )),
          Expanded(
            child: ListView(
              children: orderContent.map((op) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(255, 234, 234, 234),
                  ),
                  height: MediaQuery.of(context).size.height * 0.12,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: ListTile(
                    iconColor: Colors.grey,
                    textColor: Colors.grey,
                    style: ListTileStyle.drawer,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: "${op['foto']}",
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.12,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                        )),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    title: Text(
                      "${op["nome"]}",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w300),
                    ),
                    trailing: op['tipo'] == 'bebida'
                        ? Text("${op['quant']}",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.w300))
                        : const Text(""),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
