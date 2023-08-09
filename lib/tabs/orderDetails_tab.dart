// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_function_literals_in_foreach_calls, avoid_print, avoid_unnecessary_containers, must_be_immutable, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serve_bem_app/admin/blocs/settings_admin_bloc.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/menu_model.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/widgets/bottomSheetOrder_widget.dart';

enum Retirada { entrega, retirada }
enum Address { primeiro, segundo }
enum Pagamento { cartao, dinheiro, pix, vaAlelo }

class OrderDetails extends StatefulWidget {
  List<Map<String, dynamic>> orderList = [];
  String id;
  late TabController controller;
  OrderDetails(
      {required this.id, required this.orderList, required this.controller});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Retirada _ret = Retirada.retirada;
  Address _address = Address.primeiro;
  Pagamento _pag = Pagamento.cartao;

  String payment = "Cartão";
  bool isMoney = false;
  final _moneyController = TextEditingController();
  final _namePixController = TextEditingController();

  bool entrega = false;
  String address = "";

  bool isScheduled = false;

  final _dController = DraggableScrollableController();
  // final _timeC = TextEditingController();

  // TimeOfDay? _pickedTime;

  final _settingsBloc = SettingBloc();

  bool loadingPedido = false;

  @override
  void initState() {
    super.initState();
    UserModel.of(context).getTotalOrderPrice();

    address = "Retirar no Local";
    MenuModel.of(context)
        .verificarAntesMandar(uid: UserModel.of(context).firebaseUser!.uid);

    UserModel.of(context).calcularTaxaEntrega();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _dController,
      initialChildSize: .14,
      minChildSize: .14,
      maxChildSize: .8,
      builder: (BuildContext context, ScrollController scrollController) {
        return StreamBuilder<Map<String, dynamic>>(
            stream: _settingsBloc.outSettings,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(MyColors.backGround)),
                );
              } else {
                return Container(
                    color: Colors.white,
                    child: UserModel.of(context).isLoading == false
                        ? SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 2),
                                    decoration: BoxDecoration(
                                        color: MyColors.backGround,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _dController.size == 0.14
                                              ? Icons.keyboard_arrow_up_sharp
                                              : Icons.keyboard_arrow_down_sharp,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.075,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'Detalhes do Pagamento',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.045,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                ListTile(
                                    title: Text(
                                        "Retirar no Local (A partir das ${snapshot.data!['horarioEntrega']})"),
                                    subtitle: Text(snapshot
                                                .data!['tempoPreparo'] <
                                            60
                                        ? "Tempo mínimo de preparo: ${snapshot.data!['tempoPreparo']} minutos"
                                        : "Tempo mínimo de preparo: ${double.parse((snapshot.data!['tempoPreparo'] / 60).toString()).floor()}h ${snapshot.data!['tempoPreparo'] % 60}min "),
                                    trailing: Icon(
                                      Icons.store_mall_directory_rounded,
                                      color: MyColors.backGround,
                                    ),
                                    leading: Radio<Retirada>(
                                      activeColor: MyColors.backGround,
                                      value: Retirada.retirada,
                                      groupValue: _ret,
                                      onChanged: (Retirada? value) {
                                        setState(() {
                                          _ret = value!;
                                          entrega = false;
                                          address = "Retirar no Local";
                                        });

                                        // UserModel.of(context).calcularTaxaEntrega(choice: false);
                                      },
                                    )),
                                ListTile(
                                    title: Text(
                                        "Entrega (A partir das ${snapshot.data!['horarioEntrega']})"),
                                    subtitle: Text("*Há taxa de Entrega*"),
                                    trailing: Icon(
                                      Icons.motorcycle,
                                      color: MyColors.backGround,
                                    ),
                                    leading: Radio<Retirada>(
                                      activeColor: MyColors.backGround,
                                      value: Retirada.entrega,
                                      groupValue: _ret,
                                      onChanged: (Retirada? value) {
                                        setState(() {
                                          _ret = value!;
                                          entrega = true;
                                          address = UserModel.of(context)
                                              .userData['endereco'];
                                        });

                                        // UserModel.of(context).calcularTaxaEntrega(choice: true);
                                      },
                                    )),
                                _ret == Retirada.entrega
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 2),
                                        child: Column(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            ListTile(
                                                trailing: Icon(
                                                  Icons.home,
                                                  color: MyColors.backGround,
                                                ),
                                                title: Text(
                                                    "${UserModel.of(context).userData['endereco']}"),
                                                subtitle: Text("1° Endereço"),
                                                leading: Radio<Address>(
                                                  activeColor:
                                                      MyColors.backGround,
                                                  value: Address.primeiro,
                                                  groupValue: _address,
                                                  onChanged: (Address? value) {
                                                    setState(() {
                                                      _address = value!;
                                                      address = UserModel.of(
                                                              context)
                                                          .userData['endereco'];
                                                    });
                                                  },
                                                )),
                                            UserModel.of(context).userData[
                                                        'endereco2'] !=
                                                    ""
                                                ? ListTile(
                                                    title: Text(
                                                        "${UserModel.of(context).userData['endereco2']}"),
                                                    subtitle:
                                                        Text("2° Endereço"),
                                                    trailing: Icon(
                                                      Icons.motorcycle,
                                                      color:
                                                          MyColors.backGround,
                                                    ),
                                                    leading: Radio<Address>(
                                                      activeColor:
                                                          MyColors.backGround,
                                                      value: Address.segundo,
                                                      groupValue: _address,
                                                      onChanged:
                                                          (Address? value) {
                                                        setState(() {
                                                          _address = value!;
                                                          address = UserModel.of(
                                                                      context)
                                                                  .userData[
                                                              'endereco2'];
                                                        });
                                                      },
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                Container(
                                  //height: MediaQuery.of(context).size.height * 0.2,
                                  child: Column(children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Método de Pagamento:",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    ListTile(
                                        title: Text("Cartão"),
                                        subtitle: Text("Crédito ou Débito"),
                                        trailing: Icon(
                                          Icons.credit_card,
                                          color: MyColors.backGround,
                                        ),
                                        leading: Radio<Pagamento>(
                                          activeColor: MyColors.backGround,
                                          value: Pagamento.cartao,
                                          groupValue: _pag,
                                          onChanged: (Pagamento? value) {
                                            setState(() {
                                              _pag = value!;
                                              isMoney = false;
                                              payment = "Cartão";
                                            });
                                          },
                                        )),
                                    ListTile(
                                        title: Text("Pix"),
                                        subtitle: Text(
                                            "Pagamento adiantado para o pedido ser aprovado!"),
                                        trailing: Icon(
                                          Icons.pix,
                                          color: MyColors.backGround,
                                        ),
                                        leading: Radio<Pagamento>(
                                          activeColor: MyColors.backGround,
                                          value: Pagamento.pix,
                                          groupValue: _pag,
                                          onChanged: (Pagamento? value) {
                                            setState(() {
                                              _pag = value!;
                                              isMoney = false;
                                              payment = "Pix";
                                            });
                                          },
                                        )),
                                    _pag == Pagamento.pix
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: TextField(
                                              keyboardType: TextInputType.name,
                                              controller: _namePixController,
                                              style: TextStyle(
                                                  color: MyColors.backGround),
                                              decoration: InputDecoration(
                                                icon: Icon(
                                                  Icons.money_rounded,
                                                  color: MyColors.backGround,
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: MyColors
                                                                .backGround)),
                                                labelText:
                                                    'Digite o nome da conta do PIX:',
                                                labelStyle: TextStyle(
                                                    color: MyColors.backGround),
                                                hintText: "Digite aqui!",
                                                hintStyle: TextStyle(
                                                    color: MyColors.backGround),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    ListTile(
                                        title: Text("Dinheiro"),
                                        subtitle: Text(
                                            "Se não precisar de troco digite o mesmo valor do pedido!"),
                                        trailing: Icon(
                                          Icons.monetization_on,
                                          color: MyColors.backGround,
                                        ),
                                        leading: Radio<Pagamento>(
                                          activeColor: MyColors.backGround,
                                          value: Pagamento.dinheiro,
                                          groupValue: _pag,
                                          onChanged: (Pagamento? value) {
                                            setState(() {
                                              _pag = value!;
                                              isMoney = true;
                                              payment = "Dinheiro";
                                            });
                                          },
                                        )),
                                    isMoney == true
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: TextField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: _moneyController,
                                              style: TextStyle(
                                                  color: MyColors.backGround),
                                              decoration: InputDecoration(
                                                icon: Icon(
                                                  Icons.money_rounded,
                                                  color: MyColors.backGround,
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: MyColors
                                                                .backGround)),
                                                labelText: 'Troco Para:',
                                                labelStyle: TextStyle(
                                                    color: MyColors.backGround),
                                                hintText:
                                                    "Digite aqui o valor!",
                                                hintStyle: TextStyle(
                                                    color: MyColors.backGround),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    ListTile(
                                        title: Text("Vale Refeição"),
                                        subtitle:
                                            Text("Vale Refeição da Alelo"),
                                        trailing: Icon(
                                          Icons.food_bank_outlined,
                                          color: MyColors.backGround,
                                        ),
                                        leading: Radio<Pagamento>(
                                          activeColor: MyColors.backGround,
                                          value: Pagamento.vaAlelo,
                                          groupValue: _pag,
                                          onChanged: (Pagamento? value) {
                                            setState(() {
                                              _pag = value!;
                                              isMoney = false;
                                              payment = "VR Alelo";
                                            });
                                          },
                                        )),
                                  ]),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 4),
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        child: RaisedButton(
                                          onPressed: snapshot.data![
                                                      'funcionamentoState'] ==
                                                  true
                                              ? () async {
                                                  /*
                                                  final _time = TimeOfDay.now();
                                                  final listaHora = snapshot
                                                      .data!['horarioEntrega']
                                                      .toString()
                                                      .split(':');
                                                  int horaEntrega =
                                                      int.parse(listaHora[0]);
                                                  int minutoEntrega =
                                                      int.parse(listaHora[1]);
                                                      */
                                                  final troco = double.tryParse(
                                                      _moneyController.text);
                                                  if (widget
                                                      .orderList.isEmpty) {
                                                    onFail(
                                                        title:
                                                            "Pedido inválido!");
                                                  } else {
                                                    if (_pag ==
                                                                Pagamento
                                                                    .dinheiro &&
                                                            _moneyController
                                                                .text.isEmpty ||
                                                        _pag == Pagamento.pix &&
                                                            _namePixController
                                                                .text.isEmpty) {
                                                      onFail(
                                                          title:
                                                              "Preencha todos os campos necessários!");
                                                    } else if (_pag ==
                                                            Pagamento
                                                                .dinheiro &&
                                                        UserModel.of(context)
                                                                .totalOrderPrice >
                                                            troco!) {
                                                      onFail(
                                                          title:
                                                              "Troco insuficiente!");
                                                    } else if (_pag ==
                                                            Pagamento
                                                                .dinheiro &&
                                                        _ret ==
                                                            Retirada.entrega) {
                                                      if (UserModel.of(context)
                                                                  .totalOrderPrice +
                                                              UserModel.of(
                                                                      context)
                                                                  .taxa >
                                                          troco!) {
                                                        onFail(
                                                            title:
                                                                "Troco insuficiente para entrega, preço com frete: R\$${UserModel.of(context).totalOrderPrice + UserModel.of(context).taxa}0!");
                                                      } else {
                                                        opcaoPedido();
                                                      }
                                                    } else {
                                                      opcaoPedido();
                                                    }
                                                  }
                                                }
                                              : null,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          color: MyColors.backGround,
                                          child: Text(
                                            "Confirmar Pedido",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ),
                                      UserModel.of(context).isLoadingPrice ==
                                              false
                                          ? Text(
                                              'Total: R\$ ${UserModel.of(context).totalOrderPrice}',
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.045,
                                                  fontWeight: FontWeight.w300),
                                            )
                                          : Container(
                                              alignment: Alignment.center,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        MyColors.backGround),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                        : Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(MyColors.backGround),
                            ),
                          ));
              }
            });
      },
    );
  }

  opcaoPedido() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      enableDrag: true,
      isScrollControlled: true,
      builder: (context) => BottomSheetOrder(
        isDelivery: entrega,
        address: address,
        change: _moneyController.text,
        namePix: _namePixController.text,
        onSuccess: onSuccess,
        payment: payment,
        orderList: widget.orderList,
        // confirmarPedido: fazerPedido,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    );
  }

  onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "PEDIDO CONFIRMADO COM SUCESSO!",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    ));
    widget.controller.animateTo(1,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  onFail({required String title}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ));
  }
}
