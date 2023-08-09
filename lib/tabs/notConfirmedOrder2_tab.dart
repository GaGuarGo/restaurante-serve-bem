// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:serve_bem_app/blocs/order_bloc.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/tabs/orderDetails_tab.dart';
import 'package:serve_bem_app/tabs/order_tab.dart';

class NotConfirmedOrderTab extends StatefulWidget {
  TabController tabController;
  NotConfirmedOrderTab({Key? key, required this.tabController})
      : super(key: key);

  @override
  State<NotConfirmedOrderTab> createState() => _NotConfirmedOrderTabState();
}

class _NotConfirmedOrderTabState extends State<NotConfirmedOrderTab> {
  late OrderBloc _orderBloc;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _orderBloc = OrderBloc(uid: UserModel.of(context).firebaseUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _orderBloc.outNotConfirmedOrders,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(MyColors.backGround),
              ),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Icon(
                Icons.production_quantity_limits_sharp,
                color: MyColors.backGround,
                size: MediaQuery.of(context).size.width * 0.2,
              ),
            );
          } else {
            return ScopedModelDescendant<UserModel>(
                builder: (context, snapshot2, model) {
              if (model.deletingOrder == true) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                    ),
                  ),
                );
              } else {
                return Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.62,
                      child: ListView(
                        children: snapshot.data!
                            .map((order) => OrderTab(
                                  data: order,
                                  id: "",
                                  onSuccess: onSuccess,
                                ))
                            .toList(),
                      ),
                    ),
                    OrderDetails(
                        id: "",
                        orderList: snapshot.data!,
                        controller: widget.tabController),
                  ],
                );
              }
            });
          }
        },
      ),
    );
  }

  onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: MyColors.backGround,
      content: Text(
        "Pedido Removido do Carrinho!",
        style: TextStyle(color: Colors.white),
      ),
    ));
  }
}
