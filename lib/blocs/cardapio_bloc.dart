// ignore: import_of_legacy_library_into_null_safe
// ignore_for_file: must_call_super

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class CardapioBloc extends BlocBase {

  final _ordersController = BehaviorSubject<List>();
  Stream get outOrders => _ordersController.stream;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<DocumentSnapshot> _orders = [];

  CardapioBloc() {
    _addOrderListener();
  }

  void _addOrderListener() {
    _firestore.collection('cardapio').snapshots().listen((snapshot) {
      // ignore: avoid_function_literals_in_foreach_calls
      snapshot.docChanges.forEach((change) {
        String uid = change.doc.id;

        switch (change.type) {
          case DocumentChangeType.added:
            _orders.add(change.doc);
            break;
          case DocumentChangeType.modified:
            _orders.removeWhere((order) => order.id == uid);
            _orders.add(change.doc);
            break;
          case DocumentChangeType.removed:
            _orders.removeWhere((order) => order.id == uid);
            break;
        }
      });
      _ordersController.add(_orders);
    });
  }

  @override
  void dispose() {
    _ordersController.close();
  }
}
