// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, avoid_unnecessary_containers, use_key_in_widget_constructors, must_be_immutable, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

import 'package:serve_bem_app/models/user_model.dart';

import 'package:serve_bem_app/widgets/order_widget.dart';

class OrderTab extends StatefulWidget {
  void Function() onSuccess;
  String id;
  Map<String, dynamic> data;

  OrderTab({required this.data, required this.id, required this.onSuccess});

  @override
  State<OrderTab> createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> {
  List<dynamic> orderContent = [];

  @override
  void initState() {
    super.initState();

    UserModel.of(context).addListener(() {
      if (mounted) {
        setState(() {
          orderContent = widget.data['conteudo'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.045,
        fontWeight: FontWeight.w300);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 12.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(6),
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView(
                  children: orderContent
                      .map((doc) => OrderWidget(
                            order: doc,
                            id: widget.data["oid"],
                          ))
                      .toList()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      child: Text(
                        'Tamanho: ${widget.data['tamanho']}',
                        style: _style,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Quantidade:',
                            style: _style,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: UserModel.of(context).isPriceLoading == false
                                ? Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          UserModel.of(context).addOrDec(
                                              id: widget.data["oid"],
                                              choice: true);
                                        },
                                      ),
                                      Text(
                                        "${widget.data['quantidade']}",
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          UserModel.of(context).addOrDec(
                                              id: widget.data["oid"],
                                              choice: false);
                                        },
                                      ),
                                    ],
                                  )
                                : CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        MyColors.backGround),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 8),
                      child: Text(
                        'Marmita: R\$ ${widget.data['preco']}.00',
                        style: _style,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 8),
                      child: Text(
                        'Bebidas: R\$ ${widget.data['precoB']}',
                        style: _style,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 8),
                      child: Text(
                        'Total: R\$ ${widget.data['precoT']}',
                        style: _style,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.2,
                  alignment: Alignment.center,
                  // margin: EdgeInsets.symmetric(vertical: 4),
                  child: Center(
                    child: RaisedButton(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white,
                      child: Center(
                        child: Icon(
                          CupertinoIcons.trash,
                          color: MyColors.backGround,
                          size: MediaQuery.of(context).size.width * 0.15,
                        ),
                      ),
                      onPressed: () {
                        UserModel.of(context).deleteOrder(
                            orderId: widget.data["oid"],
                            onSuccess: widget.onSuccess);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
