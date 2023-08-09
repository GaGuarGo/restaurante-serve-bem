// ignore_for_file: unused_field, prefer_final_fields, import_of_legacy_library_into_null_safe, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/tabs/warning_tab.dart';

class MenuModel extends Model {
  static MenuModel of(BuildContext context) =>
      ScopedModel.of<MenuModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    // getMenu();
    //_getDrinks();
    // _getCard();
  }

  // final _userModel = UserModel();

  late String fotoCard = "";
  late Map<String, String> option;

  List<Map<String, String>> options = [];
  List<Map<String, String>> principal = [];
  List<Map<String, String>> guarnicao = [];

  List<Map<String, String>> drinks = [];

  bool isLoading = false;

  getMenu() async {
    isLoading = true;

    final optionsDoc =
        await FirebaseFirestore.instance.collection('cardapio').get();

    for (var doc in optionsDoc.docs) {
      option = {
        'nome': doc['nome'],
        'tipo': doc['tipo'],
        'foto': doc['foto'],
        'id': doc.id,
      };

      options.add(option);
      isLoading = false;
      notifyListeners();
    }
    _separarPrincipal();
    _separarGuarnicao();
    notifyListeners();
  }

  Future _getDrinks() async {
    isLoading = true;

    final drinkDocs =
        await FirebaseFirestore.instance.collection('bebidas').get();
    for (var doc in drinkDocs.docs) {
      option = {
        'nome': doc['nome'],
        'preco': doc['preco'],
        'foto': doc['foto'],
        'quantidade': "1",
      };

      drinks.add(option);
      notifyListeners();
    }
    isLoading = false;
  }

  List<Map<String, String>> _separarPrincipal() {
    Map<String, String> principalOp;

    for (var doc in options) {
      if (doc['tipo'] == 'principal') {
        principalOp = doc;
        principal.add(principalOp);
      }
    }
    notifyListeners();
    return principal;
  }

  List<Map<String, String>> _separarGuarnicao() {
    Map<String, String> guarnicaoOp;

    for (var doc in options) {
      if (doc['tipo'] == 'guarnicao') {
        guarnicaoOp = doc;
        guarnicao.add(guarnicaoOp);
      }
    }

    notifyListeners();
    return guarnicao;
  }

  Future<String> _getCard() async {
    var doc = await FirebaseFirestore.instance
        .collection('menu')
        .doc('fotoMenu')
        .get();
    fotoCard = doc['foto'];
    return fotoCard;
  }

  void verifyOrder(
      {required List<Map<String, dynamic>> orderContent,
      required BuildContext context,
      required String size,
      required VoidCallback onSuccess,
      required VoidCallback onFail,
      required Map<String, dynamic> myOrder}) {
    Map<String, dynamic> order = {};
    List<Map<String, dynamic>> food = [];

    orderContent.map((e) {
      order = e;
      if (e['tipo'] != "bebida") {
        food.add(e);
      }
    }).toList();

    if (orderContent.length == 1 || food.length == 1) {
      if (order['tipo'] == 'guarnicao' || order['tipo'] == 'principal') {
        showDialog(
            context: context,
            builder: (context) => WarningTab(
                title: "Ops......",
                description:
                    "Adicione um prato principal ou uma guarnição para completar o pedido!"));
        notifyListeners();
      } else if (order['tipo'] == "bebida") {
        showDialog(
            context: context,
            builder: (context) => WarningTab(
                title: "Ops......",
                description:
                    "Você não pode apenas pedir bebida, tem que pedir uma marmita também!"));
        notifyListeners();
      }
    } else if (orderContent.length > 1 && food.isEmpty) {
      showDialog(
          context: context,
          builder: (context) => WarningTab(
              title: "Ops......",
              description:
                  "Você não pode apenas pedir bebida, tem que pedir uma marmita também!"));
      notifyListeners();
    } else if (orderContent.length > 1 && food.length == 1) {
      showDialog(
          context: context,
          builder: (context) => WarningTab(
              title: "Ops......",
              description:
                  "Adicione um prato principal ou uma guarnição para completar o pedido!"));
      notifyListeners();
    } else if (size == "Pequena") {
      int quantP = 0;
      int quantG = 0;

      food.forEach((element) {
        if (element['tipo'] == 'guarnicao') {
          quantG++;
        } else {
          quantP++;
        }
      });

      if (quantG > 1 || quantP > 1) {
        showDialog(
            context: context,
            builder: (context) => WarningTab(
                title: "Ops......",
                description:
                    "O tamanho pequeno acompanha 1 guarnição e 1 prato principal!"));
        notifyListeners();
      } else {
        UserModel.of(context).mandarPedido(
            onSuccess: onSuccess, onFail: onFail, pedido: myOrder);
        notifyListeners();
      }
    } else if (size == "Média" || size == "Grande") {
      int quantP = 0;
      int quantG = 0;

      food.forEach((element) {
        if (element['tipo'] == 'guarnicao') {
          quantG++;
        } else {
          quantP++;
        }
      });

      if (quantG == 1 && quantP <= 2 || quantG <= 2 && quantP == 1) {
        UserModel.of(context).mandarPedido(
            onSuccess: onSuccess, onFail: onFail, pedido: myOrder);
        notifyListeners();
      } else {
        showDialog(
            context: context,
            builder: (context) => WarningTab(
                title: "Ops......",
                description:
                    "O tamanho Médio ou Grande acompanha 1 ou 2  guarnições e 1 ou 2 pratos principais!"));
        notifyListeners();
      }
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> intermedOrders = [];

  getOrdersAndAnalyze({
    required List<Map<String, dynamic>> orderList,
    required BuildContext context,
    required VoidCallback onSucess,
  }) async {
    isLoading = true;

    orderList.map((e) {
      intermedOrders.add(e);
    }).toList();
    notifyListeners();

    if (intermedOrders.isNotEmpty) {
      for (var op in intermedOrders) {
        List<dynamic> content = [];

        List<Map<String, dynamic>> food = [];

        content = op['conteudo'];
        content.map((e) {
          if (e['tipo'] != 'bebida') {
            food.add(e);
          }
        }).toList();

        if (content.isNotEmpty && food.isEmpty) {
          showDialog(
              context: context,
              builder: (context) => WarningTab(
                  title: "Ops......",
                  description:
                      "Você não pode pedir apenas bebida, arrume esse pedido antes de mandar!"));
          isLoading = false;

          notifyListeners();
        } else if (food.length == 1 && food.single['tipo'] == "guarnicao") {
          showDialog(
              context: context,
              builder: (context) => WarningTab(
                  title: "Ops......",
                  description:
                      "Você não pode fazer o pedir apenas guarnição, arrume esse pedido antes de mandar!"));
          isLoading = false;

          notifyListeners();
        }
      }

      //onSucess();
      intermedOrders.clear();
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Pedido em Branco!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<bool> verificarAntesMandar({required String uid}) async {
    var orders = await FirebaseFirestore.instance
        .collection('users')
        .doc('uid')
        .collection('pedidos')
        .get();
    if (orders.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
    //notifyListeners();
  }

  @override
  notifyListeners();
}
