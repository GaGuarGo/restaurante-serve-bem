// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls, prefer_final_fields

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class PedidosBlocTeste extends BlocBase {
  final _pedidosController = BehaviorSubject<List>();
  Stream<List> get outPedidos => _pedidosController.stream;

  final _firestore = FirebaseFirestore.instance;

  Map<String, Map<String, dynamic>> _pedidos = {};

  PedidosBlocTeste() {
    _addPedidosListener();
  }

  _addPedidosListener() {
    _firestore.collection("pedidosC").snapshots().listen((snapshot) {
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
}
