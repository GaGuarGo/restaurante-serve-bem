// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sized_box_for_whitespace, must_be_immutable, use_key_in_widget_constructors

// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:serve_bem_app/helpers/color_helper.dart';
// import 'package:serve_bem_app/models/user_model.dart';
// import 'package:serve_bem_app/tabs/notConfirmedOrder2_tab.dart';
// import 'package:serve_bem_app/tabs/orderDetails_tab.dart';
// import 'package:serve_bem_app/tabs/order_tab.dart';
import 'package:flutter/material.dart';

class Teste extends StatefulWidget {
  late TabController controller;
  Teste({required this.controller});

  @override
  State<Teste> createState() => _TesteState();
}

class _TesteState extends State<Teste> {
  // String orderId = "";

  List<Map<String, dynamic>> ordersList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [/*
          Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: 
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(UserModel.of(context).firebaseUser?.uid)
                    .collection('pedidos')
                    .orderBy('hora')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                      ),
                    );
                  else if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Icon(
                        Icons.production_quantity_limits_sharp,
                        color: MyColors.backGround,
                        size: MediaQuery.of(context).size.width * 0.2,
                      ),
                    );
                  } else {
                    return ListView(
                      children: snapshot.data!.docs.map((op) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.62,
                          child: StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('pedidos')
                                  .doc(op.id)
                                  .snapshots(),
                              builder: ((context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          MyColors.backGround),
                                    ),
                                  );
                                } else {
                                  ordersList.add(snapshot.data!.data()!);

                                  return OrderTab(
                                    data: snapshot.data!.data()!,
                                    id: op.id,
                                  );
                                }
                              })),
                        );
                      }).toList(),
                    );
                  }
                },
              )
              ),
          OrderDetails(
            orderList: ordersList,
            id: "",
            controller: widget.controller,
          ),*/
        ],
      ),
    );
  }
}
