// ignore_for_file: must_call_super, unused_local_variable, avoid_function_literals_in_foreach_calls

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class MenuBloc extends BlocBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _principalItemsController =
      BehaviorSubject<List<Map<String, dynamic>>>();
  Stream<List<Map<String, dynamic>>> get outPrincipalItems =>
      _principalItemsController.stream;

  final _guarnicaoItemsController =
      BehaviorSubject<List<Map<String, dynamic>>>();
  Stream<List<Map<String, dynamic>>> get outGuarnicaoItems =>
      _guarnicaoItemsController.stream;

  final _bebidasController = BehaviorSubject<List>();
  Stream<List> get outBebidas => _bebidasController.stream;

  final _cardapioUrlController = BehaviorSubject<String>();
  Stream<String> get outCardpioUrl => _cardapioUrlController.stream;

  final List<Map<String, dynamic>> _principalItems = [];
  final List<Map<String, dynamic>> _guarnicaoItems = [];

  final Map<String, Map<String, dynamic>> _bebidas = {};

  String cardapioUrl = "";

  MenuBloc() {
    _addOrderListener();
    _addBebidasListener();
    _addCardpioPhoto();
  }

  void _addOrderListener() {
    _firestore.collection('cardapio').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        // String miid = change.doc.id;
        final menuItem = change.doc.data();

        switch (change.type) {
          case DocumentChangeType.added:
            if (menuItem?['tipo'] == 'principal') {
              _principalItems.add(menuItem!);
            } else {
              _guarnicaoItems.add(menuItem!);
            }

            break;
          case DocumentChangeType.modified:
            if (menuItem?['tipo'] == 'principal') {
              _principalItems
                  .removeWhere((item) => item['nome'] = menuItem?['nome']);
              _principalItems.add(menuItem!);
            } else {
              _guarnicaoItems
                  .removeWhere((item) => item['nome'] = menuItem?['nome']);
              _guarnicaoItems.add(menuItem!);
            }
            break;
          case DocumentChangeType.removed:
            if (menuItem?['tipo'] == 'principal') {
              _principalItems
                  .removeWhere((item) => item['nome'] = menuItem?['nome']);
            } else {
              _guarnicaoItems
                  .removeWhere((item) => item['nome'] = menuItem?['nome']);
            }

            break;
        }
      });
      _principalItemsController.add(_principalItems);
      _guarnicaoItemsController.add(_guarnicaoItems);
    });
  }

  _addBebidasListener() {
    _firestore
        .collection('bebidas')
        .orderBy('nome')
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((doc) {
        String bid = doc.doc.id;
        final Map<String, dynamic> bebida = doc.doc.data()!;

        switch (doc.type) {
          case DocumentChangeType.added:
            _bebidas[bid] = bebida;
            break;
          case DocumentChangeType.modified:
            _bebidas.addAll({bid: bebida});
            break;
          case DocumentChangeType.removed:
            _bebidas.remove(bid);
            break;
        }
      });
      _bebidasController.add(_bebidas.values.toList());
    });
  }

  _addCardpioPhoto() {
    _firestore.collection("menu").snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        final docPhoto = change.doc.data();

        switch (change.type) {
          case DocumentChangeType.added:
            cardapioUrl = docPhoto!['foto'];
            break;
          case DocumentChangeType.modified:
            cardapioUrl = docPhoto!['foto'];
            break;
          case DocumentChangeType.removed:
            cardapioUrl = "";
            break;
        }
      });
      _cardapioUrlController.add(cardapioUrl);
    });
  }

  @override
  void dispose() {
    _principalItemsController.close();
    _guarnicaoItemsController.close();
    _cardapioUrlController.close();
  }
}
