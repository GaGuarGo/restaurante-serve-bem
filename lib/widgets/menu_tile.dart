// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/user_model.dart';

class MenuTile extends StatefulWidget {
  final Map<String, dynamic> op;

  const MenuTile({required this.op});

  @override
  State<MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<MenuTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color.fromARGB(255, 234, 234, 234),
      ),
      height: MediaQuery.of(context).size.height * 0.12,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: ListTile(
        iconColor: Colors.grey,
        textColor: Colors.grey,
        style: ListTileStyle.drawer,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: "${widget.op['foto']}",
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.12,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(MyColors.backGround),
            )),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Text(
          "${widget.op["nome"]}",
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.w300),
        ),
        trailing: IconButton(
          icon: Icon(CupertinoIcons.trash),
          onPressed: () {
            UserModel.of(context).removePedindo(pedido: widget.op);
          },
        ),
      ),
    );
  }
}
