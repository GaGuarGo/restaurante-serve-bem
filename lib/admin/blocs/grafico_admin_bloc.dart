// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print, unrelated_type_equality_checks, constant_identifier_names

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:serve_bem_app/admin/screens/screen_grafico/itemGrafico_class.dart';
import 'package:serve_bem_app/admin/screens/screen_grafico/tamanhoGrafico_class.dart';

enum GraficoState { IDLE, LOADING, SUCCESS, FAIL }

class GraficoBlocADM extends BlocBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _graficoController = BehaviorSubject<List<ItemGrafico>>();
  Stream<List<ItemGrafico>> get getOutGrafico => _graficoController.stream;

  final _graficoPizzaController = BehaviorSubject<Map<String, dynamic>>();
  Stream<Map<String, dynamic>> get getOutGraficoPizza =>
      _graficoPizzaController.stream;

  final _mesesController = BehaviorSubject<List<String>>();
  Stream<List<String>> get getOutMeses => _mesesController.stream;

  final _stateController = BehaviorSubject<GraficoState>();
  Stream<GraficoState> get outState => _stateController.stream;

  List<ItemGrafico> listaGrafico = [];

  List<String> meses = [];
  String mesGrafico = "";
  List<DropdownMenuItem<String>> itemsMeses = [];

  Map<String, dynamic> info = {};
  List<TamanhoMarmita> listaGraficoPizza = [];

  GraficoBlocADM() {
    addGrafico();
    getMesGrafico();
    getMeses();
    getItensMenuDropDown();
  }

  addGrafico({String? mesEscolhido}) {
    listaGrafico.clear();

    _firestore
        .collection('relatorio')
        .orderBy('dia')
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((item) {
        final itemGrafico = ItemGrafico();
        itemGrafico.quantidade = item.doc.data()!['quantidade'];
        itemGrafico.hora = item.doc.data()!['dia'];
        itemGrafico.totalPrice = item.doc.data()!['preco'];
        final List<Map<String, dynamic>> pedidos = [];

        List<dynamic> items = item.doc.data()!['pedido'];
        items.forEach((element) {
          pedidos.add(element);
        });

        itemGrafico.pedidos = pedidos;

        switch (item.type) {
          case DocumentChangeType.added:
            if (mesEscolhido != null) {
              if (mesEscolhido == mesAtual(itemGrafico.hora.toDate().month)) {
                listaGrafico.add(itemGrafico);
              }
            } else {
              if (getMesGrafico() ==
                  mesAtual(itemGrafico.hora.toDate().month)) {
                listaGrafico.add(itemGrafico);
              }
            }

            break;
          case DocumentChangeType.modified:
            break;
          case DocumentChangeType.removed:
            if (mesEscolhido != null) {
              if (mesEscolhido == mesAtual(itemGrafico.hora.toDate().month)) {
                listaGrafico.remove(itemGrafico);
              }
            } else {
              if (getMesGrafico() ==
                  mesAtual(itemGrafico.hora.toDate().month)) {
                listaGrafico.remove(itemGrafico);
              }
            }

            break;
        }
      });
      _graficoController.add(listaGrafico);
      _graficoPizzaController.add(getQuantTamanhos(list: listaGrafico));
    });
  }

  Map<String, dynamic> getQuantTamanhos({required List<ItemGrafico> list}) {
    final tamanhoPequeno = TamanhoMarmita();
    final tamanhoMedio = TamanhoMarmita();
    final tamanhoGrande = TamanhoMarmita();

    tamanhoPequeno.tamanho = "Pequena";
    tamanhoMedio.tamanho = "Média";
    tamanhoGrande.tamanho = "Grande";

    double priceT = 0;
    double priceB = 0;

    listaGraficoPizza.clear();

    list.forEach((item) {
      item.pedidos.forEach((itemPedido) {
        List<Map<String, dynamic>> listaPedidos = [];
        List<dynamic> itens = itemPedido['content'];
        itens.forEach((element) {
          listaPedidos.add(element);
        });

        if (itemPedido['entrega'] == true) {
          priceT += itemPedido['taxa'];
        }

        listaPedidos.forEach((itemsPedidoIndividual) {
          priceB += itemsPedidoIndividual['precoB'];

          if (itemsPedidoIndividual['tamanho'] == "Pequena") {
            tamanhoPequeno.quantidadeVendida =
                tamanhoPequeno.quantidadeVendida +
                    int.parse(itemsPedidoIndividual['quantidade'].toString());
            tamanhoPequeno.precoTotalVendido =
                tamanhoPequeno.precoTotalVendido +
                    double.parse(itemsPedidoIndividual['preco'].toString());
          } else if (itemsPedidoIndividual['tamanho'] == "Média") {
            tamanhoMedio.quantidadeVendida = tamanhoMedio.quantidadeVendida +
                int.parse(itemsPedidoIndividual['quantidade'].toString());
            tamanhoMedio.precoTotalVendido = tamanhoMedio.precoTotalVendido +
                double.parse(itemsPedidoIndividual['preco'].toString());
          } else {
            tamanhoGrande.quantidadeVendida = tamanhoGrande.quantidadeVendida +
                int.parse(itemsPedidoIndividual['quantidade'].toString());
            tamanhoGrande.precoTotalVendido = tamanhoGrande.precoTotalVendido +
                double.parse(itemsPedidoIndividual['preco'].toString());
          }
        });
      });
    });

    listaGraficoPizza.add(tamanhoPequeno);
    listaGraficoPizza.add(tamanhoMedio);
    listaGraficoPizza.add(tamanhoGrande);

    return getInfoGraficoPizza(
      list: listaGraficoPizza,
      taxa: priceT,
      priceB: priceB,
    );
  }

  Map<String, dynamic> getInfoGraficoPizza(
      {required List<TamanhoMarmita> list,
      required double taxa,
      required double priceB}) {
    Map<String, dynamic> informacoes = {};
    informacoes.clear();

    double totalQuant = 0;
    double totalPrice = 0;

    int quantP = 0;
    int quantM = 0;
    int quantG = 0;

    double priceP = 0;
    double priceM = 0;
    double priceG = 0;

    list.forEach((item) {
      totalQuant = totalQuant + item.quantidadeVendida;
      totalPrice = totalPrice + item.precoTotalVendido;
    });

    list.forEach((item) {
      if (item.tamanho == "Pequena") {
        quantP = item.quantidadeVendida;
        priceP = item.precoTotalVendido;
      } else if (item.tamanho == "Média") {
        quantM = item.quantidadeVendida;
        priceM = item.precoTotalVendido;
      } else {
        quantG = item.quantidadeVendida;
        priceG = item.precoTotalVendido;
      }
    });

    informacoes = {
      "totalQuant": totalQuant,
      "totalPrice": totalPrice,
      "quantP": quantP,
      "quantM": quantM,
      "quantG": quantG,
      "priceP": priceP,
      "priceM": priceM,
      "priceG": priceG,
      "priceB": priceB,
      "priceT": taxa,
    };

    print(informacoes);
    return informacoes;
  }

  deleteRelatorio() async {
    _stateController.add(GraficoState.LOADING);

    try {
      final relatorioDocs = await _firestore.collection('relatorio').get();

      relatorioDocs.docs.forEach((element) async {
        await _firestore.collection('relatorio').doc(element.id).delete();
      });
      _graficoController.add([]);
      _graficoPizzaController.add({});
      _stateController.add(GraficoState.SUCCESS);
    } catch (e) {
      _stateController.add(GraficoState.FAIL);
    }
  }

  List<String> getMeses() {
    meses.add(getMesGrafico());
    for (int i = 1; i <= 12; i++) {
      if (mesAtual(i) != getMesGrafico()) {
        meses.add(mesAtual(i));
      }
    }

    return meses;
  }

  String getMesGrafico() {
    final timestamp = Timestamp.now();

    return mesAtual(timestamp.toDate().month);
  }

  List<DropdownMenuItem<String>> getItensMenuDropDown() {
    for (int i = 0; i < meses.length; i++) {
      final mesItem = DropdownMenuItem<String>(
        child: Text(meses[i]),
        value: meses[i],
        onTap: () {},
      );

      itemsMeses.add(mesItem);
    }

    return itemsMeses;
  }

  String mesAtual(int? mes) {
    if (mes == 1) {
      return "Janeiro";
    } else if (mes == 2) {
      return "Fevereiro";
    } else if (mes == 3) {
      return "Março";
    } else if (mes == 4) {
      return "Abril";
    } else if (mes == 5) {
      return "Maio";
    } else if (mes == 6) {
      return "Junho";
    } else if (mes == 7) {
      return "Julho";
    } else if (mes == 8) {
      return "Agosto";
    } else if (mes == 9) {
      return "Setembro";
    } else if (mes == 10) {
      return "Outubro";
    } else if (mes == 11) {
      return "Novembro";
    } else {
      return "Dezembro";
    }
  }
}
