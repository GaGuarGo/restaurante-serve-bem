// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use, prefer_const_constructors, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/tabs/warning_tab.dart';

class BebibasWidget extends StatefulWidget {
  var controller = DraggableScrollableController();
  Map<String, dynamic> op;
  BebibasWidget({required this.op, required this.controller});

  @override
  State<BebibasWidget> createState() => _BebibasWidgetState();
}

class _BebibasWidgetState extends State<BebibasWidget> {
  Map<String, dynamic> drink = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      height: MediaQuery.of(context).size.height * 0.2,
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: '${widget.op['foto']}',
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.35,
              placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(MyColors.backGround),
              )),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.op['nome']}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Preço: R\$${widget.op['preco']},00',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: MyColors.backGround,
                        child: Center(
                          child: Text(
                            "Adicionar",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.034,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () {
                          drink = {
                            "foto": widget.op['foto'],
                            "nome": widget.op['nome'],
                            "preco": widget.op['preco'],
                            "quant": 1,
                            "precoT": double.parse(widget.op['preco']!),
                            "tipo": "bebida"
                          };

                          UserModel.of(context)
                              .addPedindo(pedido: drink, onFail: onFail);
                          widget.controller
                              .animateTo(.18,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeIn)
                              .then((value) {
                            widget.controller.animateTo(.12,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeIn);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onFail() {
    showDialog(
        context: context,
        builder: (context) => WarningTab(
              title: "Oopss....",
              description: "Você ja adicionou essa bebida!",
            ));
  }
}

/*
Padding(
      padding: const EdgeInsets.all(8.0),
      child:
    );
*/
