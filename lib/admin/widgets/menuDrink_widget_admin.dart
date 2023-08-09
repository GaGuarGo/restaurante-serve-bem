// ignore_for_file: must_be_immutable, deprecated_member_use, use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/blocs/pedidos_admin_bloc.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

class MenuDrinkWidgetADM extends StatefulWidget {
  Map<String, String> op;
  VoidCallback onSuccess;
  VoidCallback onFail;
  MenuDrinkWidgetADM(
      {required this.op, required this.onSuccess, required this.onFail});

  @override
  State<MenuDrinkWidgetADM> createState() => _MenuDrinkWidgetADMState();
}

class _MenuDrinkWidgetADMState extends State<MenuDrinkWidgetADM> {
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
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: MediaQuery.of(context).size.height * 0.2,
      child: StreamBuilder<OrderState>(
          stream: _pedidosBloc.outState,
          initialData: OrderState.IDLE,
          builder: (context, snapshot) {
            switch (snapshot.data!) {
              case OrderState.LOADING:
                return const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(MyColors.backGround)),
                );

              case OrderState.IDLE:
              case OrderState.SUCCESS:
              case OrderState.FAIL:
              default:
                return Card(
                  color: Colors.grey.shade600,
                  elevation: 10.0,
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: '${widget.op['foto']}',
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.35,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
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
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Preço: R\$${widget.op['preco']},00',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white),
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
                                      "Remover",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.034,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    _pedidosBloc.deleteDrinkMenu(
                                        id: widget.op['id']!,
                                        imageRef: widget.op['nome']!);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
            }
          }),
    );
  }
}
