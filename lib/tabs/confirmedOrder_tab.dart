// ignore_for_file: file_names, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/widgets/confirmedOrder_widget.dart';

class ConfirmedOrderTab extends StatefulWidget {
  const ConfirmedOrderTab({Key? key}) : super(key: key);

  @override
  State<ConfirmedOrderTab> createState() => _ConfirmedOrderTabState();
}

class _ConfirmedOrderTabState extends State<ConfirmedOrderTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(UserModel.of(context).firebaseUser?.uid)
            .collection('pedidosC')
            .orderBy('hora', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(MyColors.backGround),
              ),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Icon(
                Icons.production_quantity_limits_sharp,
                color: MyColors.backGround,
                size: MediaQuery.of(context).size.width * 0.2,
              ),
            );
          } else
            // ignore: curly_braces_in_flow_control_structures
            return ScopedModelDescendant<UserModel>(
                builder: (context, snapshot2, model) {
              if (model.deleteConfirmedOrder == true) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                  ),
                );
              } else {
                return ListView(
                  children: snapshot.data!.docs.map((op) {
                    return ConfirmedOrderWidget(
                      orderId: op.id,
                    );
                  }).toList(),
                );
              }
            });
        },
      ),
    );
  }
}
