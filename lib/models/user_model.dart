// ignore_for_file: prefer_conditional_assignment, unnecessary_null_comparison, avoid_print, unused_catch_clause, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:scoped_model/scoped_model.dart';
import 'package:serve_bem_app/blocs/login_bloc.dart';
import 'package:serve_bem_app/screens/initial_screen.dart';

class UserModel extends Model {
  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    loadCurrentUser();
    //getUserOrders();
    //getOrders();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? firebaseUser;
  Map<String, dynamic> userData = {};
  bool isLoading = false;

  List<Map<String, dynamic>> pedindo = [];

  List<dynamic> orderContent = [];
  Map<String, dynamic> pedido = {};

  String size = "Pequena";

  int quant = 1;
  int price = 17;
  int realPrice = 0;

  final loginBloc = LoginBloc();

  void getSize({required String tamanho}) {
    size = tamanho;
    notifyListeners();
  }

  void signUp({
    required Map<String, dynamic> userData,
    required String pass,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      _auth
          .createUserWithEmailAndPassword(
              email: userData["email"], password: pass)
          .then((user) async {
        firebaseUser = user.user;

        saveUserData(userData);
        notifyListeners();
        // loadCurrentUser();
        isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  void recoverPass({
    required String email,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();
    await _auth.sendPasswordResetEmail(email: email).then((_) {
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      isLoading = false;
      notifyListeners();
      onFail();
    });
  }

  void signIn({
    required String email,
    required String pass,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      firebaseUser = userCredential.user;

      await loadCurrentUser();

      onSuccess();
      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      onFail();
      isLoading = false;
      notifyListeners();
    }
  }

  void updateInfo({
    required Map<String, dynamic> data,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) {
    isLoading = true;
    notifyListeners();
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser?.uid)
          .update(data);
      onSuccess();
      isLoading = false;

      loadCurrentUser();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      onFail();
      isLoading = false;

      notifyListeners();
    }
  }

  void removeSecondAdress({
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();

    final data = {"endereco2": ""};

    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser?.uid)
          .update(data);
      onSuccess();
      isLoading = false;

      loadCurrentUser();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      onFail();
      isLoading = false;

      notifyListeners();
    }
  }

  int taxa = 0;

  calcularTaxaEntrega() async {
    taxa = 0;

    var orderUserDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser?.uid)
        .collection('pedidos')
        .get();

    orderUserDocs.docs.forEach((op) async {
      var orderDoc = await FirebaseFirestore.instance
          .collection('pedidos')
          .doc(op.id)
          .get();

      taxa = orderDoc.get('taxa') * orderDoc.get('quantidade') + taxa;
    });
    notifyListeners();
  }

  confirmarPedidoChegou({
    required String id,
    required VoidCallback onFail,
  }) async {
    var order =
        await FirebaseFirestore.instance.collection('pedidosC').doc(id).get();

    int i = order.get('status');

    if (i < 2) {
      onFail();
      notifyListeners();
    } else {
      final Map<String, dynamic> pedidoEntregue = Map.from(order.data()!);
      pedidoEntregue.update("status", (value) => 3);

      await FirebaseFirestore.instance
          .collection('pedidosC')
          .doc(id)
          .delete()
          .then((_) async {
        await FirebaseFirestore.instance
            .collection('pedidosC')
            .doc(id)
            .set(pedidoEntregue);
      });
      notifyListeners();
    }
  }

  bool deleteConfirmedOrder = false;

  deletarPedidoConfirmado(
      {required String id, required VoidCallback onSuccess}) async {
    deleteConfirmedOrder = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser?.uid)
          .collection('pedidosC')
          .doc(id)
          .delete()
          .then((_) async {
        await FirebaseFirestore.instance
            .collection('pedidosC')
            .doc(id)
            .delete();
        notifyListeners();
      });
      deleteConfirmedOrder = false;
      onSuccess();
      notifyListeners();
    } catch (e) {
      deleteConfirmedOrder = false;
      notifyListeners();
    }
  }

  confirmarPedido({
    required List<Map<String, dynamic>> orderList,
    required String address,
    required bool delivery,
    required String payment,
    required String namePix,
    required String change,
    required String orderTime,
    required bool isScheduled,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();

    int hora = Timestamp.now().microsecondsSinceEpoch;
    var format = DateFormat('dd/MM/yyyy - HH:mm');
    var date = DateTime.fromMicrosecondsSinceEpoch(hora);
    var diaHora = format.format(date);

    notifyListeners();

    if (delivery == true) {
      totalOrderPrice = totalOrderPrice + taxa;
    } else {
      totalOrderPrice;
    }

    Map<String, dynamic> confirmedOrder = {
      "content": orderList,
      "precoTotal": totalOrderPrice,
      "endereco": address,
      "entrega": delivery,
      "agendado": isScheduled,
      "taxa": taxa,
      "status": 0,
      "pagamento": payment,
      "nomePix": namePix,
      "uid": firebaseUser?.uid,
      "troco": change,
      "hora": diaHora,
      "horaPedido": orderTime,
      "horaOrdem": Timestamp.now(),
      "nome": userData['nome'],
    };

    try {
      mandarPedidoConfirmado(confirmedOder: confirmedOrder);
      var userOrders = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser?.uid)
          .collection('pedidos')
          .get();

      userOrders.docs.forEach((doc) {
        deleteOrder(orderId: doc.id);
      });

      isLoading = false;
      onSuccess();
      notifyListeners();
    } catch (e) {
      print("EERRRROOOOOOO:" "$e");
      isLoading = false;
      onFail();
      notifyListeners();
    }
  }

  void mandarPedidoConfirmado(
      {required Map<String, dynamic> confirmedOder}) async {
    await FirebaseFirestore.instance
        .collection('pedidosC')
        .add(confirmedOder)
        .then((op) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser?.uid)
          .collection('pedidosC')
          .doc(op.id)
          .set({'orderId': op.id, 'hora': DateTime.now()});
    });
    notifyListeners();
  }

  void addPedindo(
      {required Map<String, dynamic> pedido, required VoidCallback onFail}) {
    if (pedindo.any((element) => element['nome'] == pedido['nome'])) {
      onFail();
      notifyListeners();
    } else {
      pedindo.add(pedido);
      notifyListeners();
    }
  }

  void removePedindo({required Map<String, dynamic> pedido}) {
    pedindo.remove(pedido);
    notifyListeners();
    //print(pedindo);
  }

  mandarPedido(
      {required Map<String, dynamic> pedido,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('pedidos')
          .add(pedido)
          .then((doc) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser?.uid)
            .collection('pedidos')
            .doc(doc.id)
            .set({"id": doc.id, "hora": DateTime.now()});
      });
      isLoading = false;
      onSuccess();
      notifyListeners();
      //getUserOrders();
    } catch (e) {
      isLoading = false;
      onFail();
      notifyListeners();
      //getUserOrders();
    }
  }

  void signOut({required BuildContext context}) async {
    await _auth.signOut();
    loginBloc.logoff();

    userData = {};
    notifyListeners();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => const InitialScreen())));
  }

  void removeOption(
      {required String id, required Map<String, dynamic> option}) async {
    List<dynamic> orders;
    final doc =
        await FirebaseFirestore.instance.collection('pedidos').doc(id).get();

    print(id);

    orders = doc.get('conteudo');
    orders.remove(option);
    print(orders);
    notifyListeners();
  }

  bool deletingOrder = false;

  void deleteOrder({required String orderId, VoidCallback? onSuccess}) async {
    deletingOrder = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser?.uid)
          .collection('pedidos')
          .doc(orderId)
          .delete()
          .then((_) {
        FirebaseFirestore.instance.collection('pedidos').doc(orderId).delete();
        totalOrderPrice = 0;
        calcularTaxaEntrega();
        getTotalOrderPrice();
      });

      onSuccess!();
      deletingOrder = false;
      notifyListeners();
    } catch (e) {
      deletingOrder = false;
      notifyListeners();
    }
  }

  double totalOrderPrice = 0;
  bool isLoadingPrice = false;

  void getTotalOrderPrice() async {
    try {
      isLoadingPrice = true;
      notifyListeners();

      final userOrder = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser?.uid)
          .collection('pedidos')
          .get();

      if (userOrder.docs.length > 1) {
        totalOrderPrice = 0;
        userOrder.docs.forEach((op) async {
          final order = await FirebaseFirestore.instance
              .collection('pedidos')
              .doc(op.id)
              .get();

          totalOrderPrice = order['precoT'] + totalOrderPrice;
          notifyListeners();
        });
      } else if (userOrder.docs.length == 1) {
        userOrder.docs.forEach((op) async {
          final order = await FirebaseFirestore.instance
              .collection('pedidos')
              .doc(op.id)
              .get();

          totalOrderPrice = order['precoT'];
          notifyListeners();
        });
      }
      isLoadingPrice = false;
      notifyListeners();
    } catch (e) {
      isLoadingPrice = false;
      notifyListeners();
    }
  }

  bool loadingaddOrDecDrink = false;

  void addOrDecDrink(
      {required String id,
      required Map<String, dynamic> drink,
      required bool choice}) async {
    loadingaddOrDecDrink = true;
    notifyListeners();

    int quantidade = 1;
    // int quantidade2 = 1;
    int position = 0;
    // int position2 = 0;

    List<dynamic> content = [];
    //List<dynamic> content2 = [];
    Map<String, dynamic> thisDrink = {};
    // int price;

    //Map<String, dynamic> thisDrink2 = {};

    final order =
        await FirebaseFirestore.instance.collection('pedidos').doc(id).get();

    content = order.get('conteudo');

    // content2 = order.get('drinks');
    content.map((e) {
      if (e['nome'] == drink['nome']) {
        thisDrink = e;
      }
    }).toList();

    position = content.indexOf(thisDrink);
    quantidade = content[position]['quant'];
    var priceN = double.parse(content[position]['preco']);
    if (choice == true) {
      quantidade++;
      // quantidade2++;
      content[position]['quant'] = quantidade;
      content[position]['precoT'] = quantidade * priceN;

      // content2[position2]['quant'] = quantidade2;

      await FirebaseFirestore.instance.collection('pedidos').doc(id).update({
        'conteudo': content,
      });
      //.update({'conteudo': content, 'drinks': content2});

      loadingaddOrDecDrink = false;
      notifyListeners();
      getPrice(id: id);
    } else {
      if (quantidade > 1) {
        quantidade--;
        //  quantidade2--;
        content[position]['quant'] = quantidade;
        content[position]['precoT'] = quantidade * priceN;
        // content2[position2]['quant'] = quantidade2;

        await FirebaseFirestore.instance.collection('pedidos').doc(id).update({
          'conteudo': content,
        });
        //.update({'conteudo': content, 'drinks': content2});
        loadingaddOrDecDrink = false;
        notifyListeners();
        getPrice(id: id);
      } else if (quantidade == 1) {
        deleteOrderOption(order: thisDrink, id: id);
        loadingaddOrDecDrink = false;
        notifyListeners();
      }
    }
  }

  bool isPriceLoading = false;

  void addOrDec({required String id, required bool choice}) async {
    int quant;
    final order =
        await FirebaseFirestore.instance.collection('pedidos').doc(id).get();

    quant = order['quantidade'];

    isPriceLoading = true;
    notifyListeners();

    if (choice == true) {
      quant++;
      await FirebaseFirestore.instance
          .collection('pedidos')
          .doc(id)
          .update({'quantidade': quant});

      // notifyListeners();
      getPrice(id: id);
      calcularTaxaEntrega();
    } else {
      if (quant > 1) {
        quant--;
        await FirebaseFirestore.instance
            .collection('pedidos')
            .doc(id)
            .update({'quantidade': quant});

        // notifyListeners();
        getPrice(id: id);
        calcularTaxaEntrega();
      } else {}
    }

    isPriceLoading = false;
    notifyListeners();
  }

  void getPrice({required String id}) async {
    int price;
    int realPrice;
    int quant;
    double realPriceB = 0;
    double priceTotal;

    List<dynamic> content = [];
    List<Map<String, dynamic>> drinks = [];

    final order =
        await FirebaseFirestore.instance.collection('pedidos').doc(id).get();

    content = order.get('conteudo');
    content.map((e) {
      if (e['tipo'] == 'bebida') {
        drinks.add(e);
      }
    }).toList();

    drinks.forEach((element) {
      realPriceB = element['precoT'] + realPriceB;
    });

    price = order['precoUnitario'];
    quant = order['quantidade'];

    realPrice = price * quant;

    priceTotal = realPrice + realPriceB;

    await FirebaseFirestore.instance.collection('pedidos').doc(id).update(
        {'preco': realPrice, 'precoB': realPriceB, 'precoT': priceTotal});

    getTotalOrderPrice();
    notifyListeners();
  }

  saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser!.uid)
        .set(userData);
    notifyListeners();
  }

  void deleteOrderOption(
      {required Map<String, dynamic> order, required String id}) async {
    List<dynamic> content = [];
    List<Map<String, dynamic>> thisContent = [];
    Map<String, dynamic> thisOrder = {};

    var pedido =
        await FirebaseFirestore.instance.collection('pedidos').doc(id).get();

    content = pedido.get('conteudo');
    content.map((op) {
      thisContent.add(op);
    }).toList();

    thisContent.map((op) {
      if (op['nome'] == order['nome']) {
        thisOrder = op;
      }
    }).toList();

    if (thisContent.length > 1) {
      thisContent.remove(thisOrder);

      await FirebaseFirestore.instance
          .collection('pedidos')
          .doc(id)
          .update({"conteudo": thisContent});
      notifyListeners();
      getPrice(id: id);
    } else if (thisContent.length == 1) {
      deleteOrder(orderId: id);
      getPrice(id: id);
    }

    notifyListeners();
  }

  Future<void> loadCurrentUser() async {
    if (firebaseUser == null)
      //ignore: curly_braces_in_flow_control_structures
      firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      if (userData["nome"] == null) {
        DocumentSnapshot<Map<String, dynamic>> docUser = await FirebaseFirestore
            .instance
            .collection("users")
            .doc(firebaseUser?.uid)
            .get();
        userData = docUser.data()!;
      }
      notifyListeners();
    }
  }

  @override
  notifyListeners();
}
