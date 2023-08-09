// ignore_for_file: prefer_final_fields, unnecessary_null_comparison, unrelated_type_equality_checks, prefer_is_empty, avoid_function_literals_in_foreach_calls, must_call_super, constant_identifier_names

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:serve_bem_app/admin/tabs/loading_tab.dart';

enum OrderState { IDLE, LOADING, SUCCESS, FAIL }

class PedidosBloc extends BlocBase {
  final _ncOdersController = BehaviorSubject<List>();
  Stream<List> get outncOrders => _ncOdersController.stream;

  final _dOrdersController = BehaviorSubject<List>();
  Stream<List> get outdOrders => _dOrdersController.stream;

  final _deOrdersController = BehaviorSubject<List>();
  Stream<List> get outdeOrders => _deOrdersController.stream;

  final _dnOrdersController = BehaviorSubject<List>();
  Stream<List> get outdnOrders => _dnOrdersController.stream;

  final _pedidosController = BehaviorSubject<List>();
  Stream<List> get outPedidos => _pedidosController.stream;

  final _stateController = BehaviorSubject<OrderState>();
  Stream<OrderState> get outState => _stateController.stream;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, Map<String, dynamic>> _nco = {};
  Map<String, Map<String, dynamic>> _do = {};
  Map<String, Map<String, dynamic>> _deo = {};
  Map<String, Map<String, dynamic>> _dno = {};

  Map<String, Map<String, dynamic>> _pedidos = {};

  bool isLoading = false;

  String oid = "";
  String mid = "";

  PedidosBloc() {
    _addOrderListener();
    _getMenuDrinkItems();
    _getMenuFoodItens();
    //_addPedidoListener();
    // getTotalConfirmedOrders();
  }

  void onChangedSearchPedidos(String search) {
    if (search.trim().isEmpty) {
      _pedidosController.add(_pedidos.values.toList());
    } else {
      _pedidosController.add(_filter(search.trim()));
    }
  }

  List<Map<String, dynamic>> _filter(String search) {
    List<Map<String, dynamic>> filteredOrders = List.from(_pedidos.values.toList());
    filteredOrders.retainWhere((order) {
      return order['nome'].toUpperCase().contains(search.toUpperCase());
    });
    return filteredOrders;
  }

  void onChangedSearchNCO(String search) {
    if (search.trim().isEmpty) {
      _ncOdersController.add(_nco.values.toList());
    } else {
      _ncOdersController.add(_filterNCO(search.trim()));
    }
  }

  List<Map<String, dynamic>> _filterNCO(String search) {
    List<Map<String, dynamic>> filteredOrders = List.from(_nco.values.toList());
    filteredOrders.retainWhere((order) {
      return order['nome'].toUpperCase().contains(search.toUpperCase());
    });
    return filteredOrders;
  }

  void onChangedSearchDO(String search) {
    if (search.trim().isEmpty) {
      _dOrdersController.add(_do.values.toList());
    } else {
      _dOrdersController.add(_filterDO(search.trim()));
    }
  }

  List<Map<String, dynamic>> _filterDO(String search) {
    List<Map<String, dynamic>> filteredOrders = List.from(_do.values.toList());
    filteredOrders.retainWhere((order) {
      return order['nome'].toUpperCase().contains(search.toUpperCase());
    });
    return filteredOrders;
  }

  void onChangedSearchDEO(String search) {
    if (search.trim().isEmpty) {
      _deOrdersController.add(_deo.values.toList());
    } else {
      _deOrdersController.add(_filterDEO(search.trim()));
    }
  }

  List<Map<String, dynamic>> _filterDEO(String search) {
    List<Map<String, dynamic>> filteredOrders = List.from(_deo.values.toList());
    filteredOrders.retainWhere((order) {
      return order['nome'].toUpperCase().contains(search.toUpperCase());
    });
    return filteredOrders;
  }

  void onChangedSearchDNO(String search) {
    if (search.trim().isEmpty) {
      _dnOrdersController.add(_dno.values.toList());
    } else {
      _dnOrdersController.add(_filterDNO(search.trim()));
    }
  }

  List<Map<String, dynamic>> _filterDNO(String search) {
    List<Map<String, dynamic>> filteredOrders = List.from(_dno.values.toList());
    filteredOrders.retainWhere((order) {
      return order['nome'].toUpperCase().contains(search.toUpperCase());
    });
    return filteredOrders;
  }

  fazerRelatorio({
    required double quant,
    required double price,
    required context,
    required VoidCallback onFail,
    required VoidCallback onSuccess,
  }) async {
    if (_dno.length > 0) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoadingTab()));

      List<Map<String, dynamic>> doneOrder = [];

      final order =
          await FirebaseFirestore.instance.collection('pedidosC').get();

      order.docs.map((o) {
        doneOrder.add(o.data());
        deleteOrder(orderId: o.id, uid: o.get('uid'));
      }).toList();

      Map<String, dynamic> pedidoRelatorio = {
        "pedido": doneOrder,
        "quantidade": quant,
        "preco": price,
        "dia": DateTime.now(),
      };

      await FirebaseFirestore.instance
          .collection('relatorio')
          .doc()
          .set(pedidoRelatorio);

      onSuccess();
      Navigator.pop(context);
    } else {
      onFail();
    }
  }

  addStatus({
    required String orderId,
    required VoidCallback onFail,
    required VoidCallback onSuccess,
  }) async {
    _stateController.add(OrderState.LOADING);

    try {
      final order = await FirebaseFirestore.instance
          .collection('pedidosC')
          .doc(orderId)
          .get();

      int status = order.get('status');
      status++;

      await FirebaseFirestore.instance
          .collection('pedidosC')
          .doc(orderId)
          .delete();

      Map<String, dynamic> orderUpdated = Map.from(order.data()!);

      orderUpdated['status'] = status;

      await FirebaseFirestore.instance
          .collection('pedidosC')
          .doc(orderId)
          .set(orderUpdated);
      onSuccess();
      _stateController.add(OrderState.SUCCESS);
    } catch (e) {
      onFail();
      _stateController.add(OrderState.FAIL);
    }
  }

  void decStatus({
    required String orderId,
    required VoidCallback onFail,
    required VoidCallback onSuccess,
  }) async {
    _stateController.add(OrderState.LOADING);
    try {
      final order = await FirebaseFirestore.instance
          .collection('pedidosC')
          .doc(orderId)
          .get();

      int status = order.get('status');
      status--;

      await FirebaseFirestore.instance
          .collection('pedidosC')
          .doc(orderId)
          .delete();

      Map<String, dynamic> orderUpdated = Map.from(order.data()!);

      orderUpdated['status'] = status;

      await FirebaseFirestore.instance
          .collection('pedidosC')
          .doc(orderId)
          .set(orderUpdated);
      onSuccess();
      _stateController.add(OrderState.SUCCESS);
    } catch (e) {
      onFail();
      _stateController.add(OrderState.FAIL);
    }
  }

  void deleteOrder({
    required String orderId,
    required String uid,
  }) async {
    _stateController.add(OrderState.LOADING);
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection('pedidosC')
          .doc(orderId)
          .delete()
          .then((order) async {
        await FirebaseFirestore.instance
            .collection('pedidosC')
            .doc(orderId)
            .delete();
      });

      _stateController.add(OrderState.SUCCESS);
    } catch (e) {
      _stateController.add(OrderState.FAIL);
    }
  }

  String getOid(String orderId) {
    oid = orderId;

    return oid;
  }

  deleteMenu() async {
    _stateController.add(OrderState.LOADING);
    try {
      final menuItens =
          await FirebaseFirestore.instance.collection('cardapio').get();

      menuItens.docs.forEach((menu) async {
        final itemMenu = await FirebaseFirestore.instance
            .collection('cardapio')
            .doc(menu.id)
            .get();

        final storageRef = FirebaseStorage.instance.ref();
        final imgRef = storageRef.child(itemMenu.data()!['nome']);
        await imgRef.delete();

        await itemMenu.reference.delete();
      });
      _stateController.add(OrderState.SUCCESS);
    } catch (e) {
      _stateController.add(OrderState.FAIL);
    }
  }

  deleteFoodMenu(
      {required String itemId,
      required String imageRef,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) async {
    _stateController.add(OrderState.LOADING);

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imgRef = storageRef.child(imageRef);
      await imgRef.delete();
      await _firestore.collection('cardapio').doc(itemId).delete();

      _stateController.add(OrderState.SUCCESS);
      onSuccess();
    } catch (e) {
      _stateController.add(OrderState.FAIL);
      onFail();
    }
  }

  deleteDrinkMenu({required String id, required String imageRef}) async {
    _stateController.add(OrderState.LOADING);

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imgRef = storageRef.child(imageRef);
      await imgRef.delete();
      await FirebaseFirestore.instance.collection('bebidas').doc(id).delete();
      _stateController.add(OrderState.SUCCESS);
    } catch (e) {
      _stateController.add(OrderState.FAIL);
    }
  }

  void _addOrderListener() {
    _firestore
        .collection('pedidosC')
        .orderBy('horaOrdem', descending: true)
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        String oid = change.doc.id;

        final Map<String, dynamic> order = change.doc.data()!;

        order.addAll({"id": oid});

        switch (change.type) {
          case DocumentChangeType.added:
            if (change.doc.get('status') == 0) {
              _nco[oid] = order;
            } else if (change.doc.get('status') == 1) {
              _do[oid] = order;
            } else if (change.doc.get('status') == 2) {
              _deo[oid] = order;
            } else {
              _dno[oid] = order;
            }

            break;
          case DocumentChangeType.modified:
            if (change.doc.get('status') == 0) {
              //_nco[oid]?.remove(oid);
              _nco[oid]?.addAll(change.doc.data()!);
              _ncOdersController.add(_nco.values.toList());
            } else if (change.doc.get('status') == 1) {
              // _do[oid]?.remove(oid);
              _do[oid]?.addAll(change.doc.data()!);
              _dOrdersController.add(_do.values.toList());
            } else if (change.doc.get('status') == 2) {
              //_deo[oid]?.remove(oid);
              _deo[oid]?.addAll(change.doc.data()!);
              _deOrdersController.add(_deo.values.toList());
            } else {
              //  _dno[oid]?.remove(oid);
              _dno[oid]?.addAll(change.doc.data()!);
              _dnOrdersController.add(_dno.values.toList());
            }

            break;
          case DocumentChangeType.removed:
            if (change.doc.get('status') == 0) {
              _nco.remove(oid);
            } else if (change.doc.get('status') == 1) {
              _do.remove(oid);
            } else if (change.doc.get('status') == 2) {
              _deo.remove(oid);
            } else {
              _dno.remove(oid);
            }

            break;
        }
      });

      _ncOdersController.add(_nco.values.toList());
      _dOrdersController.add(_do.values.toList());
      _deOrdersController.add(_deo.values.toList());
      _dnOrdersController.add(_dno.values.toList());
    });
  }

/*
  _addPedidoListener() {
    _firestore
        .collection("pedidosC")
        .orderBy('horaOrdem', descending: true)
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((doc) {
        String pid = doc.doc.id;
        final Map<String, dynamic> pedido = doc.doc.data()!;

        pedido.addAll({"id": pid});

        switch (doc.type) {
          case DocumentChangeType.added:
            _pedidos[pid] = pedido;
            break;
          case DocumentChangeType.modified:
            _pedidos[pid]!.addAll({pid: pedido});
            break;
          case DocumentChangeType.removed:
            _pedidos.remove(pid);
            break;
        }
      });
      _pedidosController.add(_pedidos.values.toList());
    });
  }
  */

  bool canSend() {
    if (_nco.isEmpty && _do.isEmpty && _deo.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  final _principalFoodItensController = BehaviorSubject<List>();
  Stream<List> get getOutPrincipalFoodItens =>
      _principalFoodItensController.stream;

  final _guarnicaoFoodItensController = BehaviorSubject<List>();
  Stream<List> get getOutGuarnicaoFoodItens =>
      _guarnicaoFoodItensController.stream;

  final _drinkItensController = BehaviorSubject<List>();
  Stream<List> get getOutdrinkItens => _drinkItensController.stream;

  Map<String, Map<String, dynamic>> pratosPrincipais = {};
  Map<String, Map<String, dynamic>> guarnicao = {};
  Map<String, Map<String, dynamic>> _bebidas = {};

  _getMenuFoodItens() {
    _firestore.collection('cardapio').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        String id = change.doc.id;

        switch (change.type) {
          case DocumentChangeType.added:
            final Map<String, dynamic> foodItem = change.doc.data()!;

            foodItem.addAll({"id": id});

            if (change.doc.get('tipo') == 'principal') {
              pratosPrincipais[id] = foodItem;
            } else {
              guarnicao[id] = foodItem;
            }

            break;
          case DocumentChangeType.modified:
            if (change.doc.get('tipo') == 'principal') {
              pratosPrincipais[oid]?.addAll(change.doc.data()!);
              _principalFoodItensController
                  .add(pratosPrincipais.values.toList());
            } else {
              guarnicao[oid]?.addAll(change.doc.data()!);
              _guarnicaoFoodItensController.add(guarnicao.values.toList());
            }

            break;
          case DocumentChangeType.removed:
            if (change.doc.get('tipo') == 'principal') {
              pratosPrincipais.remove(id);
            } else {
              guarnicao.remove(id);
            }

            break;
        }
      });

      _principalFoodItensController.add(pratosPrincipais.values.toList());
      _guarnicaoFoodItensController.add(guarnicao.values.toList());
    });
  }

  _getMenuDrinkItems() {
    _firestore.collection('bebidas').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        String id = change.doc.id;

        switch (change.type) {
          case DocumentChangeType.added:
            Map<String, String> drinkItem = Map.from(change.doc.data()!);
            drinkItem.addAll({"id": id});

            _bebidas[id] = drinkItem;

            break;

          case DocumentChangeType.modified:
            _bebidas[id]?.addAll(change.doc.data()!);
            _drinkItensController.add(_bebidas.values.toList());

            break;

          case DocumentChangeType.removed:
            _bebidas.remove(id);

            break;
        }
      });

      _drinkItensController.add(_bebidas.values.toList());
    });
  }

  @override
  void dispose() {
    _deOrdersController.close();
    _ncOdersController.close();
    _dOrdersController.close();
    _dnOrdersController.close();
    _principalFoodItensController.close();
    _guarnicaoFoodItensController.close();
    _drinkItensController.close();
  }
}
