// ignore_for_file: file_names, unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

class ItemGrafico {
  late double _quantidade;
  late double _totalPrice;
  late Timestamp _hora;

  late List<Map<String, dynamic>> _pedidos;

  List<Map<String, dynamic>> get pedidos => _pedidos;

  set pedidos(List<Map<String, dynamic>> pedidos) {
    _pedidos = pedidos;
  }

  Timestamp get hora => _hora;

  set hora(Timestamp hora) {
    _hora = hora;
  }

  double get totalPrice => _totalPrice;

  set totalPrice(double totalPrice) {
    _totalPrice = totalPrice;
  }

  double get quantidade => _quantidade;

  set quantidade(double quantidade) {
    _quantidade = quantidade;
  }
}
