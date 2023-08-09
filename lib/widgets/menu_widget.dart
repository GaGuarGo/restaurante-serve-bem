// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/tabs/warning_tab.dart';

// ignore: must_be_immutable
class MenuWidget extends StatefulWidget {
  Map<String, dynamic> op;
  var controller = DraggableScrollableController();
  MenuWidget({required this.op, required this.controller});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.height * 0.3,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: MyColors.backGround,
        borderRadius: BorderRadius.circular(20),
        // ignore: prefer_const_literals_to_create_immutables
      ),
      child: Row(
        //  mainAxisSize: MainAxisSize.max,
        //  mainAxisAlignment: MainAxisAlignment.center,
        //  crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            child: CachedNetworkImage(
              imageUrl: '${widget.op['foto']}',
              placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              )),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              // width: 200,
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.height * 0.20,
              alignment: Alignment.centerLeft,
              filterQuality: FilterQuality.high,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 2.0),
                  child: Text(
                    '${widget.op['nome']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    UserModel.of(context)
                        .addPedindo(pedido: widget.op, onFail: _onFail);
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
                  child: Chip(
                    elevation: 12,
                    backgroundColor: Colors.white,
                    label: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onFail() {
    showDialog(
        context: context,
        builder: (context) => WarningTab(
              title: "Ops......",
              description: "Você já adicionou esse item ao seu pedido!",
            ));
  }
}
