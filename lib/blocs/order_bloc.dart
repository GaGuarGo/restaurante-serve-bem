// import 'package:flutter/material.dart';
// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class OrderBloc extends BlocBase {
  final _notConfirmedOrderController =
      BehaviorSubject<List<Map<String, dynamic>>>();
  Stream<List<Map<String, dynamic>>> get outNotConfirmedOrders =>
      _notConfirmedOrderController.stream;

  final _firestore = FirebaseFirestore.instance;

  final Map<String, Map<String, dynamic>> _ncOrderList = {};

  OrderBloc({String? uid}) {
    _addNotConfirmedOrderListener(uid: uid);
  }

  _addNotConfirmedOrderListener({String? uid}) {
    _firestore.collection('pedidos').orderBy('hora',descending: false).snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) async {
        String oid = change.doc.id;

        final order = change.doc.data()!;
        order.addAll({"oid": oid});

        switch (change.type) {
          case DocumentChangeType.added:
            if (order['uid'] == uid) {
              _ncOrderList[oid] = order;
              // _notConfirmedOrderController.add(_ncOrderList.values.toList());
            }
            break;
          case DocumentChangeType.modified:
            // _ncOrderList[oid]?.addAll(order);
            //_ncOrderList.remove(oid);
            if (order['uid'] == uid) {
              _ncOrderList.addAll({oid: order});
              // _notConfirmedOrderController.add(_ncOrderList.values.toList());
            }

            break;
          case DocumentChangeType.removed:
            _ncOrderList.remove(oid);
            // _notConfirmedOrderController.add(_ncOrderList.values.toList());
            break;
        }
      });
      _notConfirmedOrderController.add(_ncOrderList.values.toList());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _notConfirmedOrderController.close();
  }
}
