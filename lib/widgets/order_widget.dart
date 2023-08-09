// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/user_model.dart';

class OrderWidget extends StatefulWidget {
  String id;
  dynamic order;
  OrderWidget({required this.order, required this.id});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  // int quant = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.white),
        height: MediaQuery.of(context).size.height * 0.12,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: widget.order['tipo'] != "bebida"
            ? ListTile(
                iconColor: Colors.grey,
                textColor: Colors.grey,
                style: ListTileStyle.drawer,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: "${widget.order['foto']}",
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
                  "${widget.order["nome"]}",
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.w300),
                ),
              )
            : ListTile(
                iconColor: Colors.grey,
                textColor: Colors.grey,
                style: ListTileStyle.drawer,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: "${widget.order['foto']}",
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
                  "${widget.order["nome"]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.w300),
                ),
                trailing: ScopedModelDescendant<UserModel>(
                    builder: (context, snapshot, model) {
                  if (model.loadingaddOrDecDrink == true) {
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                    );
                  } else {
                    return Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            UserModel.of(context).addOrDecDrink(
                                id: widget.id,
                                drink: widget.order,
                                choice: true);
                            UserModel.of(context).notifyListeners();
                          }),
                      Text("${widget.order['quant']}"),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          UserModel.of(context).addOrDecDrink(
                              id: widget.id,
                              drink: widget.order,
                              choice: false);
                          UserModel.of(context).notifyListeners();
                        },
                      ),
                    ]);
                  }
                }),
              ));
  }
}
