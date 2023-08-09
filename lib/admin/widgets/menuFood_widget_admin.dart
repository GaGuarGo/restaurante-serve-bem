// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/blocs/pedidos_admin_bloc.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

class MenuWidgetADM extends StatefulWidget {
  Map<String, dynamic> op = {};
  VoidCallback onSuccess;
  VoidCallback onFail;

  MenuWidgetADM(
      {required this.op, required this.onSuccess, required this.onFail});

  @override
  State<MenuWidgetADM> createState() => _MenuWidgetADMState();
}

class _MenuWidgetADMState extends State<MenuWidgetADM> {
  final _pedidosBloc = PedidosBloc();

  @override
  void initState() {
  
    super.initState();

    _pedidosBloc.outState.listen((event) {
      switch (event) {
        case OrderState.SUCCESS:
          widget.onSuccess;
          break;
        case OrderState.FAIL:
          widget.onFail;
          break;
        case OrderState.IDLE:
        case OrderState.LOADING:
      }
    });
  }

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
      child: StreamBuilder<OrderState>(
          stream: _pedidosBloc.outState,
          initialData: OrderState.IDLE,
          builder: (context, snapshot) {
            switch (snapshot.data!) {
              case OrderState.LOADING:
                return const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white)),
                );

              case OrderState.IDLE:
              case OrderState.SUCCESS:
              case OrderState.FAIL:
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: '${widget.op['foto']}',
                        placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(Colors.white),
                        )),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
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
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _pedidosBloc.deleteFoodMenu(
                                itemId: widget.op['id'],
                                imageRef: widget.op['nome'],
                                onSuccess: widget.onSuccess,
                                onFail: widget.onFail,
                              );
                            },
                            child: const Chip(
                              elevation: 12,
                              backgroundColor: Colors.white,
                              label: Icon(
                                Icons.delete,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
            }
          }),
    );
  }
}
