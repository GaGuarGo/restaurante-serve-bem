// ignore: import_of_legacy_library_into_null_safe
// ignore_for_file: deprecated_member_use, prefer_const_constructors';, prefer_const_constructors, curly_braces_in_flow_control_structures, must_be_immutable, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/blocs/settings_admin_bloc.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/menu_model.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/tabs/info_tab.dart';
import 'package:serve_bem_app/tabs/warning_tab.dart';
import 'package:serve_bem_app/widgets/menu_tile.dart';

class MenuTab extends StatefulWidget {
  late Function onSuccess;
  List<Map<String, dynamic>> pedidos;
  String tamanho;
  var controller = DraggableScrollableController();
  var homeController = PageController();
  int pageIndex;

  MenuTab({
    required this.pedidos,
    required this.tamanho,
    required this.controller,
    required this.homeController,
    required this.pageIndex,
    required this.onSuccess,
    //required this.func,
  });

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  int price = 17;
  int taxa = 1;
  bool isLoading = false;

  double size = .35;

  final _settingsBloc = SettingBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: _settingsBloc.outSettings,
        builder: (context, snapshot) {
          return DraggableScrollableSheet(
            controller: widget.controller,
            initialChildSize: .12,
            minChildSize: .12,
            maxChildSize: size,
            builder: (BuildContext context, ScrollController scrollController) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                  ),
                );
              else
                return Container(
                    color: Colors.white,
                    child: UserModel.of(context).isLoading == false
                        ? ListView(
                            controller: scrollController,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                    //alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          margin:
                                              EdgeInsets.symmetric(vertical: 4),
                                          child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              color: Color.fromARGB(
                                                  255, 255, 68, 0),
                                              child: Text(
                                                'Adicionar ao Carrinho',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.045,
                                                ),
                                              ),
                                              onPressed: UserModel.of(context)
                                                      .pedindo
                                                      .isEmpty
                                                  ? null
                                                  : snapshot.data![
                                                              'funcionamentoState'] ==
                                                          false
                                                      ? null
                                                      : () {
                                                          if (UserModel.of(
                                                                      context)
                                                                  .size ==
                                                              "Pequena") {
                                                            setState(() {
                                                              price = snapshot
                                                                      .data![
                                                                  'precoP'];
                                                              taxa = snapshot
                                                                      .data![
                                                                  'entregaP'];
                                                            });
                                                          } else if (UserModel.of(
                                                                      context)
                                                                  .size ==
                                                              "Média") {
                                                            setState(() {
                                                              price = snapshot
                                                                      .data![
                                                                  'precoM'];
                                                              taxa = snapshot
                                                                      .data![
                                                                  'entregaM'];
                                                            });
                                                          } else {
                                                            setState(() {
                                                              price = snapshot
                                                                      .data![
                                                                  'precoG'];
                                                              taxa = snapshot
                                                                      .data![
                                                                  'entregaG'];
                                                            });
                                                          }
                                                          List<
                                                                  Map<String,
                                                                      dynamic>>
                                                              thisOrder = [];

                                                          double priceB = 0;
                                                          thisOrder =
                                                              widget.pedidos;

                                                          for (var op
                                                              in thisOrder) {
                                                            if (op['tipo'] ==
                                                                'bebida') {
                                                              var thisPriceB =
                                                                  double.parse(op[
                                                                      'preco']);

                                                              priceB =
                                                                  thisPriceB +
                                                                      priceB;
                                                            }
                                                          }

                                                          Map<String, dynamic>
                                                              pedido = {
                                                            "tamanho":
                                                                UserModel.of(
                                                                        context)
                                                                    .size,
                                                            "conteudo":
                                                                widget.pedidos,
                                                            "confirmado": false,
                                                            "quantidade": 1,
                                                            "precoUnitario":
                                                                price,
                                                            "preco": price,
                                                            "status": 0,
                                                            "taxa": taxa,
                                                            "hora":
                                                                DateTime.now(),
                                                            //"drinks": drinks,
                                                            "precoB": priceB,
                                                            "precoT":
                                                                priceB + price,
                                                            "uid": UserModel.of(
                                                                    context)
                                                                .firebaseUser
                                                                ?.uid
                                                          };

                                                          MenuModel.of(context)
                                                              .verifyOrder(
                                                                  orderContent:
                                                                      widget
                                                                          .pedidos,
                                                                  context:
                                                                      context,
                                                                  size: UserModel.of(
                                                                          context)
                                                                      .size,
                                                                  onSuccess:
                                                                      onSuccess,
                                                                  onFail:
                                                                      onFail,
                                                                  myOrder:
                                                                      pedido);
                                                        }),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            widget.controller.size == .12
                                                ? Icons.arrow_circle_up_sharp
                                                : Icons.arrow_circle_down_sharp,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.075,
                                            color: MyColors.backGround,
                                          ),
                                          onPressed: () {
                                            if (widget.controller.size == .35) {
                                              widget.controller.animateTo(.12,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeIn);
                                            } else {
                                              widget.controller.animateTo(.35,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeIn);
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.info,
                                            color: MyColors.backGround,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.075,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    InfoTab());
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(vertical: 4.0),
                                  child: widget.pedidos.isNotEmpty
                                      ? SingleChildScrollView(
                                          child: Column(
                                          children: widget.pedidos
                                              .map((op) => MenuTile(op: op))
                                              .toList(),
                                        ))
                                      : Text(
                                          "Seu pedido está vazio!",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.075,
                                          ),
                                        )),
                            ],
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(MyColors.backGround),
                            ),
                          ));
            },
          );
        });
  }

  onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Pedido adicionado ao carrinho com Sucesso!",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    ));
    widget.pedidos.clear();
    UserModel.of(context).notifyListeners();
    
  setState(() {
     UserModel.of(context).size = "Pequena";
  });

    widget.onSuccess();
  }

  void onFail() {
    showDialog(
        context: context,
        builder: (context) => WarningTab(
            title: "Ops....",
            description:
                "Algo deu errado na hora de adicionar seu pedido, tente novamente!"));
  }
}
